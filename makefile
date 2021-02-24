all: site

##################################
# Directories
##################################
TARGET_DIR = site
BUILD_DIR = build
TEMPLATE_DIR = template
V ?= @

CONFIG = site.yaml
POSTS = $(shell find _posts -name "*.md")
POSTS_MDHTML = $(POSTS_YAML:.yaml=.md.html)
POSTS_DEP = $(POSTS_YAML:.yaml=.d)

GPG = gpg

RENDER = ./scripts/render.py

##################################
# Static Files
##################################
CSS_SRCS = css/syntax.css css/markdown.css css/post.css css/main.css
CSS_TARGET = $(TARGET_DIR)/css/min.css
MINIFY = python -m csscompressor

$(CSS_TARGET): $(CSS_SRCS)
	$(V)echo "[MINIFY]" "$^" "->" "$@"
	$(V)mkdir -pv $(dir $@)
	$(V)$(MINIFY) $^ > $@

site: $(CSS_TARGET)

STATIC_FOLDERS = js files/ images/ favicon.png css/font-awesome-4.4.0 .well-known
define staticrule
$$(TARGET_DIR)/$(1): .FORCE
	$$(V)echo "[CP]" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)rm -rf $$@
	$$(V)cp -r $(1) $$@

site: $$(TARGET_DIR)/$(1)

endef

$(foreach folder,$(STATIC_FOLDERS),$(eval $(call staticrule,$(folder))))

#################################
# Markdown to HTML
#################################
$(BUILD_DIR)/%.md.html: %.md
	$(V)echo "[MARKDOWN]" "$<"
	$(V)mkdir -pv $(dir $@)
	$(V)cat "$<" | sed -E 's/!\[([^]]*)\]\(images\//![\1](\/images\//' | markdown2 -x code-friendly,metadata,fenced-code-blocks > $@

#################################
# GPG Sign content
#################################

$(BUILD_DIR)/%.md.asc: %.md
	$(V)echo "[GPG]" "$<" "..."
	$(V)$(GPG) --yes --sign -a -o $@ $<

#################################
# Post Metadata
#################################
YAML_CALC_RELATED = ./scripts/posts_related.py
YAML_ADD_BODY = ./scripts/posts_addbody.py

POSTS_YAML = $(addprefix $(BUILD_DIR)/,$(POSTS:.md=.yaml))
POSTS_YAML_RAW = $(addprefix $(BUILD_DIR)/,$(POSTS:.md=.yaml.raw))
CONVERT_DATETIME = ./scripts/convert_datetime.py
# Extract metadata from post source, and date from filename
$(BUILD_DIR)/%.yaml.raw: %.md $(BUILD_DIR)/%.md.html $(YAML_ADD_BODY)
	$(V)echo "[YAML]" "$<"
	$(V)mkdir -pv $(dir $@)
	$(V)echo "date: "$$(basename "$<" | cut -d - -f 1-3 | $(CONVERT_DATETIME) "%Y-%m-%d" "%Y-%m-%d" 2> /dev/null) > $@
	$(V)echo "date_human: "$$(basename "$<" | cut -d - -f 1-3 | $(CONVERT_DATETIME) "%Y-%m-%d" "%d %b %Y" 2> /dev/null) >> $@
	$(V)echo "date_rss: "$$(basename "$<" | cut -d - -f 1-3 | $(CONVERT_DATETIME) "%Y-%m-%d" "%a, %d %b %Y %H:%M:%S %Z" 2> /dev/null) >> $@
	$(V)sed -e '1d' -e '/---/q' "$<" | sed -e 's/---//' >> $@
	$(V)$(YAML_ADD_BODY) $@ $(word 2,$^)

$(BUILD_DIR)/posts.yaml: $(POSTS_YAML_RAW) $(YAML_CALC_RELATED)
	$(V)echo "[YAML] All Posts"
	$(V)$(YAML_CALC_RELATED) $(POSTS_YAML_RAW) > $(BUILD_DIR)/posts.yaml

$(BUILD_DIR)/%.yaml: $(BUILD_DIR)/posts.yaml
	$(V)true

################################
# Badges
################################

BADGES = $(shell find badges -name "*.txt")
BADGES_SVG = $(addprefix $(BUILD_DIR)/,$(BADGES:.txt=.svg))
BADGES_TEMPLATE = $(shell find badges -name "*.txt.jinja2")

$(BUILD_DIR)/badges/%.svg: badges/%.txt
	$(V)echo "[WGET]" "$<"
	$(V)mkdir -pv $(dir $@)
	$(V)cat $< | xargs wget -O $@ 2> /dev/null
	$(V)touch $@

badges: $(BADGES_SVG)

define badgerule
$$(BUILD_DIR)/$(1).svg: $$(BUILD_DIR)/posts.yaml $$(RENDER) \
							$(1).txt.jinja2
	$$(V)echo "[WGET]" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --data posts:$$< \
		--template $(1).txt.jinja2 | xargs wget -O $$@ 2> /dev/null
	$$(V)touch $$@

badges: $$(BUILD_DIR)/$(1).svg

endef

$(foreach badge,$(BADGES_TEMPLATE:.txt.jinja2=),$(eval $(call badgerule,$(badge))))

site: badges

#################################
# Template Dependency
#################################

$(TEMPLATE_DIR)/index.html: $(TEMPLATE_DIR)/base.html
	$(V)touch $@

$(TEMPLATE_DIR)/post.html: $(TEMPLATE_DIR)/base.html
	$(V)touch $@

$(TEMPLATE_DIR)/friends.html: $(TEMPLATE_DIR)/base.html
	$(V)touch $@

#################################
# Friends Page
#################################
$(TARGET_DIR)/friends/index.html: $(TEMPLATE_DIR)/friends.html friends.yaml $(CSS_TARGET) badges
	$(V)echo "[RENDER] Friends"
	$(V)mkdir -pv $(dir $@)
	$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
		--data site:$(CONFIG) friends:friends.yaml \
		--template friends.html > $@

$(TARGET_DIR)/_pjax/friends/index.html: $(TEMPLATE_DIR)/friends.html friends.yaml
	$(V)echo "[RENDER PJAX] Friends"
	$(V)mkdir -pv $(dir $@)
	$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
		--data site:$(CONFIG) friends:friends.yaml pjax: \
		--template friends.html > $@

indexpages: $(TARGET_DIR)/friends/index.html
indexpages: $(TARGET_DIR)/_pjax/friends/index.html

#################################
# Index Pages
#################################
define indexpagerule
$$(BUILD_DIR)/indexpage-$(1)-page.yaml:
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)echo "classification: $(1)" > $$@

$$(TARGET_DIR)/$(1)/index.html: $$(CONFIG) $$(BUILD_DIR)/posts.yaml \
								$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
								$$(TEMPLATE_DIR)/index.html $$(RENDER) $$(CSS_TARGET) badges
	$$(V)echo "[RENDER] Index" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
			--data site:$$(CONFIG) posts:$$(BUILD_DIR)/posts.yaml \
			page:$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
			--template index.html > $$@

$$(TARGET_DIR)/_pjax/$(1)/index.html: $$(CONFIG) $$(BUILD_DIR)/posts.yaml \
									$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
									$$(TEMPLATE_DIR)/index.html $$(RENDER)
	$$(V)echo "[RENDER PJAX] Index" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
			--data site:$$(CONFIG) posts:$$(BUILD_DIR)/posts.yaml \
			page:$$(BUILD_DIR)/indexpage-$(1)-page.yaml pjax: \
			--template index.html > $$@

indexpages: $$(TARGET_DIR)/$(1)/index.html $$(TARGET_DIR)/_pjax/$(1)/index.html
endef

$(eval $(call indexpagerule,))  # All
$(eval $(call indexpagerule,tech))
$(eval $(call indexpagerule,misc))
$(eval $(call indexpagerule,project))
$(eval $(call indexpagerule,life))

site: indexpages


define extrapagerule
$$(TARGET_DIR)/$(1)/index.html: $$(TEMPLATE_DIR)/$(1).html $$(RENDER) $$(CONFIG) $$(CSS_TARGET) badges
	$$(V)echo "[RENDER] Page" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) $(1): --template $(1).html > $$@

$$(TARGET_DIR)/_pjax/$(1)/index.html: $$(TEMPLATE_DIR)/$(1).html $$(RENDER) $$(CONFIG)
	$$(V)echo "[RENDER PJAX] Page" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) $(1): pjax: --template $(1).html > $$@

$$(TEMPLATE_DIR)/$(1).html: $$(TEMPLATE_DIR)/base.html
	$$(V)touch $$@

extrapages: $$(TARGET_DIR)/$(1)/index.html $$(TARGET_DIR)/_pjax/$(1)/index.html
endef

$(eval $(call extrapagerule,404))
$(eval $(call extrapagerule,search))

site: extrapages

#################################
# Feed XML
#################################
RSS_FEED = feeds/all.rss.xml
$(TARGET_DIR)/$(RSS_FEED): $(TEMPLATE_DIR)/all.rss.xml $(CONFIG) \
							$(BUILD_DIR)/posts.yaml $(RENDER)
	$(V)echo "[RENDER] all.rss.xml"
	$(V)mkdir -pv $(dir $@)
	$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
		--data site:$(CONFIG) posts:$(BUILD_DIR)/posts.yaml \
		--template all.rss.xml > $@

site: $(TARGET_DIR)/$(RSS_FEED)

#################################
# Posts
#################################
define postrule
$$(TARGET_DIR)/$(2): $$(BUILD_DIR)/$(1).html \
							$$(CONFIG) $$(BUILD_DIR)/$(3).yaml \
							$$(TEMPLATE_DIR)/post.html \
							$$(RENDER) $$(CSS_TARGET) badges
	$$(V)echo "[RENDER]" "$(2)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) page:$$(BUILD_DIR)/$(3).yaml \
		--template post.html > $$@

$$(TARGET_DIR)/_pjax/$(2): $$(BUILD_DIR)/$(1).html \
							$$(CONFIG) $$(BUILD_DIR)/$(3).yaml \
							$$(TEMPLATE_DIR)/post.html \
							$$(RENDER)
	$$(V)echo "[RENDER PJAX]" "$(2)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) page:$$(BUILD_DIR)/$(3).yaml pjax: \
		--template post.html > $$@

$$(TARGET_DIR)/_sig/$(2): $$(BUILD_DIR)/$(1).asc \
							$$(TEMPLATE_DIR)/sig.html \
							$$(RENDER)
	$$(V)echo "[RENDER SIG]" "$(2)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--body $$< --template sig.html > $$@

site: $$(TARGET_DIR)/$(2) $$(TARGET_DIR)/_pjax/$(2) $$(TARGET_DIR)/_sig/$(2)

endef

postrule_wrap=$(call postrule,$(1),$(shell grep "permalink:" "$(1)" | sed -e "s/.*:[ ]*//" -e "s/\/\$$/\/index.html/"),$(shell dirname "$(1)")/$(shell basename "$(1)" .md))

$(foreach post,$(POSTS),$(eval $(call postrule_wrap,$(post))))

#################################
# Other Rules
#################################

clean:
	rm -rf $(BUILD_DIR) $(TARGET_DIR)

SSH_PORT ?= 22
SSH_USER ?= blahgeek
SSH_HOST ?= blog.blahgeek.com
SSH_TARGET_DIR ?= /srv/http/blog.blahgeek.com/

love:
	rsync -e "ssh -p $(SSH_PORT)" -P -rvz --delete $(TARGET_DIR) $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)


.FORCE:

.PHONY: site badges indexpages clean all love .FORCE
