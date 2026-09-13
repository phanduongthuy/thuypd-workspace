# ==============================================================================
# THUYPD.SITE Workspace — Unified Makefile
# ==============================================================================

SHELL := /bin/bash
COMPOSE := docker compose --env-file .env.docker

# Colors for terminal styling
CYAN   := \033[36m
GREEN  := \033[32m
YELLOW := \033[33m
MAGENTA:= \033[35m
RED    := \033[31m
BOLD   := \033[1m
RESET  := \033[0m

.DEFAULT_GOAL := help

.PHONY: help dev dev-api dev-client dev-admin up down restart build logs ps install clean status submodules

## 📋 Hiển thị bảng trợ giúp lệnh Makefile
help:
	@echo ""
	@echo -e "$(BOLD)======================================================================$(RESET)"
	@echo -e "$(BOLD)🚀 THUYPD.SITE Workspace — Quản trị hệ thống (CLI Targets)$(RESET)"
	@echo -e "$(BOLD)======================================================================$(RESET)"
	@echo ""
	@echo -e "$(CYAN)🐳 Quản Trị Docker Stack:$(RESET)"
	@echo -e "  $(GREEN)make up$(RESET)           Khởi chạy toàn bộ 4 containers ở chế độ background"
	@echo -e "  $(GREEN)make down$(RESET)         Dừng toàn bộ containers"
	@echo -e "  $(GREEN)make restart$(RESET)      Khởi động lại toàn bộ containers"
	@echo -e "  $(GREEN)make build$(RESET)        Rebuild lại Docker images khi có code mới"
	@echo -e "  $(GREEN)make logs$(RESET)         Xem live stream logs của tất cả containers"
	@echo -e "  $(GREEN)make ps$(RESET)           Kiểm tra trạng thái containers và cổng ánh xạ"
	@echo ""
	@echo -e "$(CYAN)💻 Chạy Trực Tiếp Local Dev (Node.js Host):$(RESET)"
	@echo -e "  $(GREEN)make dev$(RESET)          Khởi chạy đồng thời cả 3 phân hệ bằng Runner script"
	@echo -e "  $(GREEN)make dev-api$(RESET)      Chạy riêng Backend API (Port 5001)"
	@echo -e "  $(GREEN)make dev-client$(RESET)   Chạy riêng Client Landing (Port 3000)"
	@echo -e "  $(GREEN)make dev-admin$(RESET)    Chạy riêng Admin CMS Portal (Port 3002)"
	@echo ""
	@echo -e "$(CYAN)🔧 Cài Đặt & Bảo Trì:$(RESET)"
	@echo -e "  $(GREEN)make install$(RESET)      Cài đặt dependencies (npm install) cho cả 3 phân hệ"
	@echo -e "  $(GREEN)make submodules$(RESET)   Cập nhật và sync lại tất cả git submodules"
	@echo -e "  $(GREEN)make status$(RESET)       Kiểm tra trạng thái ports và git submodules"
	@echo -e "  $(GREEN)make clean$(RESET)        Dọn dẹp logs, cache tạm và containers"
	@echo ""
	@echo -e "$(BOLD)======================================================================$(RESET)"
	@echo ""

# ------------------------------------------------------------------------------
# DOCKER TARGETS
# ------------------------------------------------------------------------------

## Khởi động toàn bộ container Docker
up:
	@echo -e "$(GREEN)🚀 Đang khởi động Docker stack...$(RESET)"
	$(COMPOSE) up -d
	@echo ""
	@$(COMPOSE) ps
	@echo ""
	@echo -e "$(CYAN)Client Landing :$(RESET) http://localhost:3010"
	@echo -e "$(CYAN)Admin Portal   :$(RESET) http://localhost:3002"
	@echo -e "$(CYAN)Backend API    :$(RESET) http://localhost:5001/api/health"
	@echo -e "$(CYAN)MongoDB        :$(RESET) mongodb://localhost:27017"

## Dừng toàn bộ containers
down:
	@echo -e "$(YELLOW)🛑 Đang dừng toàn bộ Docker containers...$(RESET)"
	$(COMPOSE) down

## Khởi động lại containers
restart:
	@echo -e "$(YELLOW)🔄 Đang khởi động lại Docker containers...$(RESET)"
	$(COMPOSE) restart

## Rebuild Docker images
build:
	@echo -e "$(CYAN)🔨 Đang build lại Docker images...$(RESET)"
	$(COMPOSE) build

## Xem logs real-time
logs:
	$(COMPOSE) logs -f

## Xem trạng thái containers
ps:
	$(COMPOSE) ps

# ------------------------------------------------------------------------------
# LOCAL DEV TARGETS
# ------------------------------------------------------------------------------

## Chạy đồng thời cả 3 phân hệ trên máy local
dev:
	npm run dev

## Chạy riêng Backend API
dev-api:
	npm run dev:api

## Chạy riêng Client Landing
dev-client:
	npm run dev:client

## Chạy riêng Admin CMS
dev-admin:
	npm run dev:admin

# ------------------------------------------------------------------------------
# SETUP & MAINTENANCE TARGETS
# ------------------------------------------------------------------------------

## Cài đặt dependencies cho 3 phân hệ
install:
	@echo -e "$(CYAN)📦 Đang cài đặt dependencies cho toàn bộ workspace...$(RESET)"
	npm run install:all

## Sync và update git submodules
submodules:
	@echo -e "$(CYAN)🔄 Đang đồng bộ submodules...$(RESET)"
	git submodule sync
	git submodule update --init --recursive

## Kiểm tra trạng thái ports và containers
status:
	@echo -e "$(BOLD)=== Trạng thái Docker Containers ===$(RESET)"
	@$(COMPOSE) ps 2>/dev/null || echo "Docker stack is stopped"
	@echo ""
	@echo -e "$(BOLD)=== Kiểm tra cổng đang mở trên Host ===$(RESET)"
	@lsof -i :3000 -i :3002 -i :3010 -i :5001 -i :27017 2>/dev/null || echo "Tất cả các cổng kiểm tra đều đang rảnh"
	@echo ""
	@echo -e "$(BOLD)=== Trạng thái Git Submodules ===$(RESET)"
	@git submodule status

## Dọn dẹp containers và cache
clean:
	@echo -e "$(YELLOW)🧹 Đang dọn dẹp Docker containers và volumes...$(RESET)"
	$(COMPOSE) down -v --remove-orphans 2>/dev/null || true
	@echo -e "$(GREEN)Đã dọn dẹp xong.$(RESET)"
