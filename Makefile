.PHONY: help up down restart logs logs-follow status clean clean-all pull ps exec-sonarqube exec-db backup restore config validate

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)SonarQube Docker Management$(NC)"
	@echo ""
	@echo "$(GREEN)Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  $(BLUE)%-15s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

up: ## Start all services in detached mode
	@echo "$(GREEN)Starting SonarQube services...$(NC)"
	docker compose up -d
	@echo "$(GREEN)Services started!$(NC)"
	@echo "$(YELLOW)Access SonarQube at: http://localhost:9000$(NC)"
	@echo "$(YELLOW)Default credentials: admin/admin$(NC)"

down: ## Stop all services
	@echo "$(YELLOW)Stopping SonarQube services...$(NC)"
	docker compose down
	@echo "$(GREEN)Services stopped!$(NC)"

restart: ## Restart all services
	@echo "$(YELLOW)Restarting SonarQube services...$(NC)"
	docker compose restart
	@echo "$(GREEN)Services restarted!$(NC)"

logs: ## View logs (all services)
	docker compose logs

logs-follow: ## Follow logs in real-time (all services)
	docker compose logs -f

logs-sonarqube: ## View SonarQube logs only
	docker compose logs sonarqube

logs-db: ## View database logs only
	docker compose logs db

status: ## Show status of all services
	@docker compose ps

ps: status ## Alias for status

exec-sonarqube: ## Open shell in SonarQube container
	docker compose exec sonarqube bash

exec-db: ## Open shell in database container
	docker compose exec db bash

db-psql: ## Connect to PostgreSQL with psql client
	docker compose exec db psql -U sonar -d sonar

clean: ## Stop services and remove containers (keeps volumes)
	@echo "$(RED)Stopping and removing containers...$(NC)"
	docker compose down
	@echo "$(GREEN)Containers removed! (Volumes preserved)$(NC)"

clean-all: ## Stop services and remove everything including volumes (⚠️ DESTRUCTIVE)
	@echo "$(RED)⚠️  WARNING: This will delete all data!$(NC)"
	@echo "$(RED)Press Ctrl+C to cancel, or wait 5 seconds to continue...$(NC)"
	@sleep 5
	docker compose down -v
	@echo "$(GREEN)Everything removed including data volumes!$(NC)"

pull: ## Pull latest images
	@echo "$(BLUE)Pulling latest Docker images...$(NC)"
	docker compose pull
	@echo "$(GREEN)Images updated!$(NC)"

update: pull down up ## Update images and restart services

config: ## Validate and view docker-compose configuration
	docker compose config

validate: config ## Alias for config

health: ## Check health of services
	@echo "$(BLUE)Service Health Status:$(NC)"
	@docker compose ps
	@echo ""
	@echo "$(BLUE)Database Health Check:$(NC)"
	@docker compose exec db pg_isready -U sonar || echo "$(RED)Database not ready$(NC)"

stats: ## Show resource usage statistics
	docker stats --no-stream

install: ## Initial setup (copy .env.example to .env)
	@if [ -f .env ]; then \
		echo "$(YELLOW).env file already exists!$(NC)"; \
	else \
		cp .env.example .env; \
		echo "$(GREEN).env file created from .env.example$(NC)"; \
		echo "$(YELLOW)Please edit .env file with your configuration$(NC)"; \
	fi

backup-volumes: ## Backup all volumes to ./backups directory
	@mkdir -p backups
	@echo "$(BLUE)Backing up volumes...$(NC)"
	@docker run --rm -v sonarqube_pg_data:/data -v $(PWD)/backups:/backup alpine tar czf /backup/pg_data_$$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
	@docker run --rm -v sonarqube_sq_data:/data -v $(PWD)/backups:/backup alpine tar czf /backup/sq_data_$$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
	@echo "$(GREEN)Backup complete! Files saved in ./backups/$(NC)"

volume-list: ## List all volumes
	@docker volume ls | grep sonarqube

check-env: ## Check if .env file exists
	@if [ -f .env ]; then \
		echo "$(GREEN)✓ .env file exists$(NC)"; \
	else \
		echo "$(RED)✗ .env file not found!$(NC)"; \
		echo "$(YELLOW)Run 'make install' to create it$(NC)"; \
		exit 1; \
	fi

quick-start: install up ## Quick start for new users (install + up)
	@echo ""
	@echo "$(GREEN)═══════════════════════════════════════════$(NC)"
	@echo "$(GREEN)SonarQube is starting up!$(NC)"
	@echo "$(GREEN)═══════════════════════════════════════════$(NC)"
	@echo "$(YELLOW)Access at: http://localhost:9000$(NC)"
	@echo "$(YELLOW)Default credentials: admin/admin$(NC)"
	@echo "$(RED)⚠️  Remember to change the password!$(NC)"
	@echo ""
	@echo "$(BLUE)Useful commands:$(NC)"
	@echo "  make logs-follow  - Watch logs"
	@echo "  make status       - Check service status"
	@echo "  make help         - Show all commands"
