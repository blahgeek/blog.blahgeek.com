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
# Markdown to HTML
#################################
$(BUILD_DIR)/%.md.html: %.md
	@mkdir -pv $(dir $@)
	pandoc $< -t html -o $@

#################################
# Post Metadata
#################################
YAML_CALC_RELATED = ./scripts/posts_related.py
YAML_ADD_BODY = ./scripts/posts_addbody.py

POSTS_YAML = $(addprefix $(BUILD_DIR)/,$(POSTS:.md=.yaml))
POSTS_YAML_RAW = $(addprefix $(BUILD_DIR)/,$(POSTS:.md=.yaml.raw))
# Extract metadata from post source, and date from filename
$(BUILD_DIR)/%.yaml.raw: %.md $(BUILD_DIR)/%.md.html $(YAML_ADD_BODY)
	@mkdir -pv $(dir $@)
	echo "date: "$$(date -j -f %Y-%m-%d $$(basename "$<") +%Y-%m-%d 2> /dev/null) > $@
	echo "date_human: "$$(date -j -f "%Y-%m-%d" $$(basename "$<") "+%d %b %Y" 2> /dev/null) >> $@
	sed -e '1d' -e '/---/q' "$<" | sed -e 's/---//' >> $@
	$(YAML_ADD_BODY) $@ $(word 2,$^)

$(BUILD_DIR)/posts.yaml: $(POSTS_YAML_RAW) $(YAML_CALC_RELATED)
	$(YAML_CALC_RELATED) $(POSTS_YAML_RAW) > $(BUILD_DIR)/posts.yaml

$(BUILD_DIR)/%.yaml: $(BUILD_DIR)/posts.yaml

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
$(TARGET_DIR)/feeds/all.rss.xml: template/all.rss.xml $(CONFIG) $(BUILD_DIR)/posts.yaml
	@mkdir -pv $(dir $@)
	$(RENDER) --data site:$(CONFIG) posts:$(BUILD_DIR)/posts.yaml \
		--template "$<" > $@

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


mdhtml: $(POSTS_MDHTML)

.PHONY: deps mdhtml site indexpages
