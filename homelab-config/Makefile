-include .env
export

REMOTE := $(SERVER_USER)@$(SERVER_IP)
REMOTE_DIR := ~/homelab-config

.PHONY: all init push ssh apply-ip apply-lid status

all: push apply-ip apply-lid

init:
	@echo "Initializing remote configuration directory..."
	ssh $(REMOTE) "mkdir -p $(REMOTE_DIR)/netplan $(REMOTE_DIR)/systemd"

push: init
	@echo "Syncing configuration files to server..."
	rsync -avz --exclude '.git' --exclude '.env' ./ $(REMOTE):$(REMOTE_DIR)/

ssh:
	ssh $(REMOTE)

apply-ip: push
	@echo "Applying static IP configuration via Netplan..."
	ssh $(REMOTE) "sudo cp $(REMOTE_DIR)/netplan/01-static-ip.yaml /etc/netplan/01-static-ip.yaml && sudo netplan apply"
	@echo "Static IP applied successfully. Reconnect using 'make ssh' once the IP updates."

apply-lid: push
	@echo "Configuring systemd to ignore lid close..."
	ssh $(REMOTE) "sudo cp $(REMOTE_DIR)/systemd/logind.conf /etc/systemd/logind.conf && sudo systemctl restart systemd-logind"
	@echo "Lid-close behavior updated successfully."

status:
	ssh $(REMOTE) "hostnamectl && ip -4 addr show $(SERVER_INTERFACE)"

connect-test:
	@echo "Testing SSH connectivity..."
	ssh -o ConnectTimeout=5 $(REMOTE) "echo 'Connected successfully'" || echo "Connection failed"
