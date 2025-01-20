# Variables
DCOMPOSE		:= docker-compose
SRC_DIR			:= srcs
DCOMPOSE_FILE	:= $(SRC_DIR)/docker-compose.yml
ENV				:=	--env-file $(SRC_DIR)/.env
WP_VOLUME		:= /home/mevangel/data/wp_files
DB_VOLUME		:= /home/mevangel/data/database

# Targets
.PHONY: all build up down clean re

# Default target
all: build up

create_volumes:
	@mkdir -p $(WP_VOLUME)
	@mkdir -p $(DB_VOLUME)

# Build the services
build: create_volumes
	@echo "Building Docker images..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) build

# Start the services
up:
	@echo "Starting services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) up -d

# Stop the services
down:
	@echo "Stopping services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) down

# Resume the services
start:
	@echo "Resume services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) start

# Delete volumes created by the services
delete_volumes:
	@echo "Deleting volumes..."
	@rm -rf $(WP_VOLUME)
	@rm -rf $(DB_VOLUME)

# Clean up docker resources (without removing volumes)
clean: down
	@echo "Cleaning up docker resources..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) down --volumes --remove-orphans
	docker container prune -f
	docker network prune -f
	docker image prune -f

# Complete clean-up, including volumes
fclean: clean delete_volumes
	@echo "Total clean-up, including volumes..."
	docker system prune -a -f

# Rebuild everything from scratch
re: fclean all
	@echo "Rebuilding the project from scratch..."

status:
	docker ps

.PHONY: all up down clean fclean re delete_volumes create_volumes start stop