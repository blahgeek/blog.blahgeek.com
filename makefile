SSH_PORT=22
OUTPUTDIR=_site
SSH_USER=blahgeek
SSH_HOST=blog.blahgeek.com
SSH_TARGET_DIR=/srv/http/blog.blahgeek.com/

# all:
# 	rsync -e "ssh -p $(SSH_PORT)" -P -rvz --no-p --delete $(OUTPUTDIR) $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

# .PHONY: all


##################################
# Directories
##################################
TARGET_DIR = site
BUILD_DIR = build
TEMPLATE_DIR = template

CONFIG = site.yaml
POSTS = $(shell find _posts -name "*.md")
POSTS_MDHTML = $(POSTS_YAML:.yaml=.md.html)

RENDER = ./scripts/render.py

#################################
# Post Metadata
#################################
YAML_ADD_DATE = ./scripts/posts_date.py
YAML_CALC_RELATED = ./scripts/posts_related.py

POSTS_YAML = $(addprefix $(BUILD_DIR)/,$(POSTS:.md=.yaml))
$(BUILD_DIR)/%.yaml: %.md
	@mkdir -pv $(dir $@)
	sed -e '1d' -e '/---/q' "$<" | sed -e 's/---//' > $@.raw
	$(YAML_ADD_DATE) $@.raw > $@

$(BUILD_DIR)/posts.yaml: $(POSTS_YAML) $(YAML_CALC_RELATED)
	$(YAML_CALC_RELATED) $(POSTS_YAML) > $@

#################################
# Index Pages
#################################
define indexpagerule
$$(BUILD_DIR)/indexpage-$(1)-page.yaml:
	@mkdir -pv $$(dir $$@)
	echo "page:\n  classification: $(1)\n" > $$@

$$(TARGET_DIR)/$(1)/index.html: $$(CONFIG) $$(BUILD_DIR)/posts.yaml \
								$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
								$$(TEMPLATE_DIR)/index.html 
	@mkdir -pv $$(dir $$@)
	$(RENDER) --data site:$$(CONFIG) posts:$$(BUILD_DIR)/posts.yaml \
			page:$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
			--template $$(TEMPLATE_DIR)/index.html > $$@

indexpages: $$(TARGET_DIR)/$(1)/index.html
endef

$(eval $(call indexpagerule,))  # All
$(eval $(call indexpagerule,tech))
$(eval $(call indexpagerule,misc))
$(eval $(call indexpagerule,project))
$(eval $(call indexpagerule,life))

site: indexpages


#################################
# Feed XML
#################################
$(TARGET_DIR)/all.rss.xml: feeds/all.rss.xml

##################################
# Static Files
##################################
CSS_SRCS = css/syntax.css css/post.css css/main.css
CSS_TARGET = min.css

$(TARGET_DIR)/$(CSS_TARGET): $(CSS_SRCS)
	@mkdir -pv $(dir $@)
	minify $^ > $@

define postrule
_TARGET=$$(shell grep "permalink:" "$(1)" | sed -e "s/.*:[ \t]*//" -e "s/\/\$$$$/\/index.html/")
$$(TARGET_DIR)/$$(_TARGET): $$(BUILD_DIR)/$(1).html
	@echo "Building" $$(_TARGET)
	@mkdir -pv $$(dir $$@)
	echo "Prefix" > $$@  # TODO
	cat $$< >> $$@
site: $$(TARGET_DIR)/$$(_TARGET)
endef

$(foreach post,$(POSTS),$(eval $(call postrule,$(post))))



$(BUILD_DIR)/%.md.html: %.md
	@mkdir -pv $(dir $@)
	pandoc $< -t html -o $@

mdhtml: $(POSTS_MDHTML)

.PHONY: deps mdhtml site indexpages
