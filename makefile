SSH_PORT=22
OUTPUTDIR=_site
SSH_USER=blahgeek
SSH_HOST=nodex.blahgeek.com
SSH_TARGET_DIR=/srv/http/blog.blahgeek.com/

all:
	rsync -e "ssh -p $(SSH_PORT)" -P -rvz --delete $(OUTPUTDIR) $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

.PHONY: all
