all: site

##################################
# Directories
##################################
TARGET_DIR = site
BUILD_DIR = build
TEMPLATE_DIR = template
V ?= @

CONFIG = site.yaml
POSTS = $(shell find _posts -name "*.md" -and -not -name "*.disabled.md")
POSTS_DIR = _posts   # list as dep so that the site will be updated after "disabling" some posts
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

$(BUILD_DIR)/posts.yaml: $(POSTS_YAML_RAW) $(YAML_CALC_RELATED) $(POSTS_DIR)
	$(V)echo "[YAML] All Posts"
	$(V)$(YAML_CALC_RELATED) $(POSTS_YAML_RAW) > $(BUILD_DIR)/posts.yaml

$(BUILD_DIR)/%.yaml: $(BUILD_DIR)/posts.yaml
	$(V)true

################################
# Badges
################################

BADGES_SIMPLE_TXT = $(shell find badges -name "*.txt")
BADGES_SIMPLE_SVG = $(addprefix $(BUILD_DIR)/,$(BADGES_SIMPLE_TXT:.txt=.svg))
BADGES_TEMPLATE = $(shell find badges -name "*.txt.jinja2")
BADGES_DONE = $(BUILD_DIR)/badges.done

$(BUILD_DIR)/badges/%.svg: badges/%.txt
	$(V)echo "[WGET]" "$<"
	$(V)mkdir -pv $(dir $@)
	$(V)cat $< | xargs wget -O $@ 2> /dev/null
	$(V)touch $@

$(BADGES_DONE): $(BADGES_SIMPLE_SVG)
	$(V)touch $@
	$(V)echo "[BADGES] Done"

define badge_template_rule
$$(BUILD_DIR)/$(1).svg: $$(BUILD_DIR)/posts.yaml $$(RENDER) \
							$(1).txt.jinja2
	$$(V)echo "[WGET]" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --data posts:$$< \
		--template $(1).txt.jinja2 | xargs wget -O $$@ 2> /dev/null
	$$(V)touch $$@

$(BADGES_DONE): $$(BUILD_DIR)/$(1).svg

endef

$(foreach badge,$(BADGES_TEMPLATE:.txt.jinja2=),$(eval $(call badge_template_rule,$(badge))))

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
$(TARGET_DIR)/friends/index.html: $(TEMPLATE_DIR)/friends.html friends.yaml $(BADGES_DONE)
	$(V)echo "[RENDER] Friends"
	$(V)mkdir -pv $(dir $@)
	$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
		--data site:$(CONFIG) friends:friends.yaml \
		--template friends.html > $@

indexpages: $(TARGET_DIR)/friends/index.html

#################################
# Index Pages
#################################
define indexpagerule
$$(BUILD_DIR)/indexpage-$(1)-page.yaml:
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)echo "classification: $(1)" > $$@

$$(TARGET_DIR)/$(1)/index.html: $$(CONFIG) $$(BUILD_DIR)/posts.yaml \
								$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
								$$(TEMPLATE_DIR)/index.html $$(RENDER) $$(BADGES_DONE)
	$$(V)echo "[RENDER] Index" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
			--data site:$$(CONFIG) posts:$$(BUILD_DIR)/posts.yaml \
			page:$$(BUILD_DIR)/indexpage-$(1)-page.yaml \
			--template index.html > $$@

indexpages: $$(TARGET_DIR)/$(1)/index.html
endef

$(eval $(call indexpagerule,all))
$(eval $(call indexpagerule,tech))
$(eval $(call indexpagerule,misc))
$(eval $(call indexpagerule,project))
$(eval $(call indexpagerule,life))

site: indexpages


define extrapagerule
$$(TARGET_DIR)/$(1)/index.html: $$(TEMPLATE_DIR)/$(1).html $$(RENDER) $$(CONFIG) $$(BADGES_DONE)
	$$(V)echo "[RENDER] Page" "$(1)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) $(1): --template $(1).html > $$@

$$(TEMPLATE_DIR)/$(1).html: $$(TEMPLATE_DIR)/base.html
	$$(V)touch $$@

extrapages: $$(TARGET_DIR)/$(1)/index.html
endef

$(eval $(call extrapagerule,404))
$(eval $(call extrapagerule,search))


$(TARGET_DIR)/index.html: $(TEMPLATE_DIR)/main.html $(BUILD_DIR)/_specials/main.yaml.raw $(RENDER) $(CONFIG) $(BADGES_DONE)
	$(V)echo "[RENDER] Page Main"
	$(V)mkdir -pv $(dir $@)
	$(V)$(RENDER) --dir $(TEMPLATE_DIR) \
		--data site:$(CONFIG) page:$(BUILD_DIR)/_specials/main.yaml.raw \
		--template main.html > $@


site: extrapages $(TARGET_DIR)/index.html

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
							$$(RENDER) $$(BADGES_DONE)
	$$(V)echo "[RENDER]" "$(2)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--data site:$$(CONFIG) page:$$(BUILD_DIR)/$(3).yaml \
		--template post.html > $$@

$$(TARGET_DIR)/_sig/$(2): $$(BUILD_DIR)/$(1).asc \
							$$(TEMPLATE_DIR)/sig.html \
							$$(RENDER)
	$$(V)echo "[RENDER SIG]" "$(2)"
	$$(V)mkdir -pv $$(dir $$@)
	$$(V)$$(RENDER) --dir $$(TEMPLATE_DIR) \
		--body $$< --template sig.html > $$@

site: $$(TARGET_DIR)/$(2) $$(TARGET_DIR)/_sig/$(2)

endef

postrule_wrap=$(call postrule,$(1),$(shell grep "permalink:" "$(1)" | sed -e "s/.*:[ ]*//" -e "s/\/\$$/\/index.html/"),$(shell dirname "$(1)")/$(shell basename "$(1)" .md))

$(foreach post,$(POSTS),$(eval $(call postrule_wrap,$(post))))

#################################
# Other Rules
#################################

clean:
	rm -rf $(BUILD_DIR) $(TARGET_DIR)

upload:
	rclone -v sync --transfers=16 site fastmail:/blog.blahgeek.com


.FORCE:

.PHONY: site indexpages clean all upload .FORCE
