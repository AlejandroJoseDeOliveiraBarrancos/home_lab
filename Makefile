-include inventory/hosts.env
export

REPO_DIR := $(shell pwd)
SSH_KEY := $(REPO_DIR)/inventory/homelab-server
SSH_OPTS := -o IdentityFile=$(SSH_KEY) -o IdentitiesOnly=yes
RSYNC_RSH := ssh $(SSH_OPTS)

REMOTE := $(SERVER_USER)@$(SERVER_IP)
REMOTE_DIR := $(_REMOTE_DIR)

.PHONY: all sync apply ssh status test sudo-nopasswd docker firewall npm-up npm-down adguard-up adguard-down tailscale-up up down stats fail2ban-up

all: apply

sync:
	@echo "Initializing remote directory..."
	ssh $(SSH_OPTS) $(REMOTE) "mkdir -p $(REMOTE_DIR)/{configs,roles,scripts,bootstrap,stacks,inventory,scripts/{core,security,maintenance,utils},stacks/core/{nginx-proxy-manager,adguardhome},stacks/security/{crowdsec,gluetun},stacks/media/{jellyfin,syncthing},stacks/storage/{duplicati,kopia},stacks/apps/{homepage,vaultwarden,ollama-openwebui,ntfy,authelia},stacks/games/{minecraft,pterodactyl},stacks/infra/{step-ca}}"
	@echo "Syncing repository to server..."
	RSYNC_RSH="$(RSYNC_RSH)" rsync -avz --delete \
		--exclude '.git' \
		--exclude 'inventory/hosts.env' \
		--exclude 'inventory/homelab-server' \
		--exclude 'inventory/server' \
		--exclude '*.swp' \
		--exclude '*~' \
		$(REPO_DIR)/ $(REMOTE):$(REMOTE_DIR)/

apply: sync-safe
	@echo "Applying all configurations..."
	ssh $(SSH_OPTS) $(REMOTE) "bash $(REMOTE_DIR)/scripts/apply.sh"

sudo-nopasswd: sync
	@echo "Making sudo passwordless on server..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/security/make-sudo-nopasswd.sh"

docker: sync
	@echo "Installing Docker on server..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/core/install-docker.sh"

firewall: sync
	@echo "Configuring UFW firewall..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/security/setup-ufw.sh"

npm-up: sync
	@echo "Starting Nginx Proxy Manager..."
	ssh $(SSH_OPTS) $(REMOTE) "docker network inspect proxy >/dev/null 2>&1 || docker network create proxy; cd $(REMOTE_DIR)/stacks/core/nginx-proxy-manager && docker compose up -d"

npm-down:
	ssh $(SSH_OPTS) $(REMOTE) "cd $(REMOTE_DIR)/stacks/core/nginx-proxy-manager && docker compose down"

adguard-up: sync
	@echo "Starting AdGuardHome..."
	ssh $(SSH_OPTS) $(REMOTE) "docker network inspect proxy >/dev/null 2>&1 || docker network create proxy; cd $(REMOTE_DIR)/stacks/core/adguardhome && docker compose up -d"

adguard-down:
	ssh $(SSH_OPTS) $(REMOTE) "cd $(REMOTE_DIR)/stacks/core/adguardhome && docker compose down"

tailscale-up: sync
	@echo "Installing Tailscale..."
	ssh $(SSH_OPTS) -t $(REMOTE) "curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up"

fail2ban-up: sync
	@echo "Installing and configuring Fail2ban..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/security/setup-fail2ban.sh"

up: sync
	@echo "Starting all services..."
	@ssh $(SSH_OPTS) $(REMOTE) 'docker network inspect proxy >/dev/null 2>&1 || docker network create proxy; find $$HOME/homelab/stacks -name "docker-compose.yml" -exec sh -c '"'"'d=$$(dirname "{}"); echo "Starting $$d"; (cd "$$d" && docker compose up -d || true)'"'"' \;'

down:
	@echo "Stopping all services..."
	@ssh $(SSH_OPTS) $(REMOTE) 'find $$HOME/homelab/stacks -name "docker-compose.yml" -exec sh -c '"'"'d=$$(dirname "{}"); echo "Stopping $$d"; (cd "$$d" && docker compose down || true)'"'"' \;'

stats: sync
	@echo "Fetching server stats..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/maintenance/server-stats.sh"

ssh:
	ssh $(SSH_OPTS) $(REMOTE)

status:
	ssh $(SSH_OPTS) $(REMOTE) "hostnamectl && echo '---' && ip -4 addr show $(SERVER_INTERFACE) 2>/dev/null || ip -4 addr show && echo '---' && docker ps 2>/dev/null || true"

test:
	@echo "Testing connectivity to $(REMOTE)..."
	ssh $(SSH_OPTS) -o ConnectTimeout=5 -p $(SSH_PORT) $(REMOTE) "echo 'OK'" || echo "FAILED"

fix-perms: sync
	@echo "Fixing permissions..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/maintenance/fix-perms.sh"

sync-safe: 
	@echo "Syncing with permission fix..."
	ssh $(SSH_OPTS) -t $(REMOTE) "bash $(REMOTE_DIR)/scripts/maintenance/fix-perms.sh 2>/dev/null || true"
	@echo "Initializing remote directory..."
	ssh $(SSH_OPTS) $(REMOTE) "mkdir -p $(REMOTE_DIR)/{configs,roles,scripts,bootstrap,stacks,inventory,scripts/{core,security,maintenance,utils},stacks/core/{nginx-proxy-manager,adguardhome},stacks/security/{crowdsec,gluetun},stacks/media/{jellyfin,syncthing},stacks/storage/{duplicati,kopia},stacks/apps/{homepage,vaultwarden,ollama-openwebui,ntfy,authelia},stacks/games/{minecraft,pterodactyl},stacks/infra/{step-ca}}"
	RSYNC_RSH="$(RSYNC_RSH)" rsync -avz --ignore-errors \
		--exclude '.git' \
		--exclude 'inventory/hosts.env' \
		--exclude 'inventory/homelab-server' \
		--exclude 'inventory/server' \
		--exclude '*.swp' \
		--exclude '*~' \
		$(REPO_DIR)/ $(REMOTE):$(REMOTE_DIR)/ || true
