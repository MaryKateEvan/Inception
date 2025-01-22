# Variables
# DCOMPOSE		:= docker compose
SRC_DIR			:= srcs
# DCOMPOSE_FILE	:= $(SRC_DIR)/docker-compose.yml
DOCKER_COMPOSE	:= docker compose -f $(SRC_DIR)/docker-compose.yml
# ENV				:=	--env-file $(SRC_DIR)/.env
WP_VOLUME		:= $(SRC_DIR)/volumes/wordpress-volume
DB_VOLUME		:= $(SRC_DIR)/volumes/database-volume

# Color codes
GREEN   := \033[32m
YELLOW  := \033[33m
RED     := \033[31m
BLUE    := \033[34m
CYAN    := \033[36m
RESET   := \033[0m

# Default target
all: up

# Creates the volumes on the local drive
create_volumes:
	@echo "📂 ${CYAN}Creating volumes on the local drive...${RESET}"
	@mkdir -p $(WP_VOLUME)
	@mkdir -p $(DB_VOLUME)

# Builds the services
build: create_volumes
	@echo "🔨 ${GREEN}Building Docker images...${RESET}"
	$(DOCKER_COMPOSE) build

# Starts the services
up: create_volumes
	@echo "🚀 ${YELLOW}Starting services...${RESET}"
	$(DOCKER_COMPOSE) up --build -d

# Stops the services
down:
	@echo "🛑 ${RED}Stopping services...${RESET}"
	$(DOCKER_COMPOSE) down

# Resumes the services
start:
	@echo "⏯️ ${CYAN}Resuming services...${RESET}"
	$(DOCKER_COMPOSE) start

# Deletes the volumes
delete_local_volumes:
	@echo "🗑️  ${RED}Deleting volumes...${RESET}"
	@rm -rf $(WP_VOLUME)
	@rm -rf $(DB_VOLUME)

# Clean up docker resources (without removing volumes)
clean: down
	@echo "🧹 ${YELLOW}Cleaning up Docker resources...${RESET}"
	docker container prune -f
	docker network prune -f
	docker image prune -f

# Complete clean-up, including volumes
fclean: clean
	@echo "🧹🧹 ${RED}Total clean-up, including volumes...${RESET}"
	docker system prune -a -f --volumes

# Rebuild and rerun
re: fclean all
	@echo "🔁 ${BLUE}Relaunching everything again...${RESET}"

# Print the status of the containers
status:
	@echo "📊 ${CYAN}Displaying container status...${RESET}"
	docker ps

.PHONY: all create_volumes build up down start delete_volumes clean fclean re status