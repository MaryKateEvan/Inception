# Variables
DCOMPOSE		:= docker-compose
SRC_DIR			:= srcs
DCOMPOSE_FILE	:= $(SRC_DIR)/docker-compose.yml
ENV				:=	--env-file $(SRC_DIR)/.env
WP_VOLUME		:= /Users/mevangel/data/wp_files
DB_VOLUME		:= /Users/mevangel/data/database

# Default target
all: build up

# Creates the volumes on the local drive
create_volumes:
	@mkdir -p $(WP_VOLUME)
	@mkdir -p $(DB_VOLUME)

# Builds the services
build: create_volumes
	@echo "Building Docker images..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) build

# Starts the services
up:
	@echo "Starting services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) up -d

# Stops the services
down:
	@echo "Stopping services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) down

# Resumes the services
start:
	@echo "Resume services..."
	$(DCOMPOSE) -f $(DCOMPOSE_FILE) start

# Deletes the volumes
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

# Print the status of the containers
status:
	docker ps

.PHONY: all create_volumes build up down start delete_volumes clean fclean re status