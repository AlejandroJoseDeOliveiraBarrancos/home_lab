-include inventory/hosts.env
export

REPO_DIR := $(shell pwd)
SSH_KEY := $(REPO_DIR)/inventory/homelab-server
SSH_OPTS := -o IdentityFile=$(SSH_KEY) -o IdentitiesOnly=yes
RSYNC_RSH := ssh $(SSH_OPTS)

REMOTE := $(SERVER_USER)@$(SERVER_IP)
REMOTE_DIR := $(_REMOTE_DIR)

.PHONY: all bootstrap sync apply ssh status test sudo-nopasswd

all: apply

bootstrap: sync
	@echo "Bootstrapping server..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/bootstrap/bootstrap.sh"

sync:
	@echo "Initializing remote directory..."
	ssh $(SSH_OPTS) $(REMOTE) "mkdir -p $(REMOTE_DIR)/{configs,roles,scripts,bootstrap,stacks,inventory,scripts/{core,security,maintenance,utils}}"
	@echo "Syncing repository to server..."
	RSYNC_RSH="$(RSYNC_RSH)" rsync -avz --delete \
		--exclude '.git' \
		--exclude 'inventory/hosts.env' \
		--exclude 'inventory/homelab-server' \
		--exclude 'inventory/server' \
		--exclude '*.swp' \
		--exclude '*~' \
		$(REPO_DIR)/ $(REMOTE):$(REMOTE_DIR)/

apply: sync
	@echo "Applying all configurations..."
	ssh $(SSH_OPTS) $(REMOTE) "bash $(REMOTE_DIR)/scripts/apply.sh"

sudo-nopasswd: sync
	@echo "Making sudo passwordless on server..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/security/make-sudo-nopasswd.sh"

ssh:
	ssh $(SSH_OPTS) $(REMOTE)

status:
	ssh $(SSH_OPTS) $(REMOTE) "hostnamectl && echo '---' && ip -4 addr show $(SERVER_INTERFACE) 2>/dev/null || ip -4 addr show && echo '---' && docker ps 2>/dev/null || true"

test:
	@echo "Testing connectivity to $(REMOTE)..."
	ssh $(SSH_OPTS) -o ConnectTimeout=5 -p $(SSH_PORT) $(REMOTE) "echo 'OK'" || echo "FAILED"
