# Variables
DCOMPOSE		:= docker-compose
SRC_DIR			:= srcs
DCOMPOSE_FILE	:= $(SRC_DIR)/docker-compose.yml
ENV				:=	--env-file $(SRC_DIR)/.env
WP_VOLUME		:= volumes/wp_files
DB_VOLUME		:= volumes/database

# Color codes
GREEN   := \033[32m
YELLOW  := \033[33m
RED     := \033[31m
BLUE    := \033[34m
CYAN    := \033[36m
RESET   := \033[0m

# Default target
all: build up

# Creates the volumes on the local drive
create_volumes:
	@echo "📂 ${CYAN}Creating volumes on the local drive...${RESET}"
	@mkdir -p $(WP_VOLUME)
	@mkdir -p $(DB_VOLUME)

# Builds the services
build: create_volumes
	@echo "🔨 ${GREEN}Building Docker images...${RESET}"
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) build

# Starts the services
up:
	@echo "🚀 ${YELLOW}Starting services...${RESET}"
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) up

# Stops the services
down:
	@echo "🛑 ${RED}Stopping services...${RESET}"
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) down

# Resumes the services
start:
	@echo "⏯️ ${CYAN}Resuming services...${RESET}"
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) start

# Deletes the volumes
delete_volumes:
	@echo "🗑️  ${RED}Deleting volumes...${RESET}"
	@rm -rf $(WP_VOLUME)
	@rm -rf $(DB_VOLUME)

# Clean up docker resources (without removing volumes)
clean: down
	@echo "🧹 ${YELLOW}Cleaning up Docker resources...${RESET}"
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) down --volumes --remove-orphans
	docker container prune -f
	docker network prune -f
	docker image prune -f

# Complete clean-up, including volumes
fclean: clean delete_volumes
	@echo "🧹🧹 ${RED}Total clean-up, including volumes...${RESET}"
	docker system prune -a -f

# Rebuild everything from scratch
re: fclean all
	@echo "🔁 ${BLUE}Rebuilding the project from scratch...${RESET}"

# Print the status of the containers
status:
	@echo "📊 ${CYAN}Displaying container status...${RESET}"
	docker ps

.PHONY: all create_volumes build up down start delete_volumes clean fclean re status