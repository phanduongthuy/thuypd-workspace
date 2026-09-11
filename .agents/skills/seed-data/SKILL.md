---
name: seed-data
description: >-
  Hướng dẫn tạo dữ liệu mẫu (seed data) cho môi trường development và staging.
  Sử dụng khi user cần khởi tạo database với dữ liệu test, hoặc reset dữ liệu về trạng thái ban đầu.
---

# Seed Data — THUYPD.SITE

## API Backend Seed

### Chạy seed script
```bash
cd api.thuypd.site
npm run seed
# Sử dụng tsx chạy src/utils/seed-data.ts
```

### Yêu cầu trước khi seed:
1. MongoDB đang chạy và kết nối được (local hoặc Atlas)
2. File `.env` đã cấu hình `DATABASE_URI` hoặc `MONGODB_URI`
3. `DATABASE_NAME` đã được set (default: `thuypd_site`)

### Dữ liệu được seed:
- **RBAC (Dynamic Roles & Permissions)** — Danh mục nhóm chức năng và chi tiết actions (`npm run seed:rbac`)
- **User** — Tài khoản admin mặc định
- **Themes** — Mẫu giao diện website (ecommerce, corporate, realestate, spa...)
- **Services** — Danh sách dịch vụ thiết kế web
- **Pricing** — Bảng giá các gói dịch vụ
- **Settings** — Cài đặt hệ thống mặc định
- **LandingConfig** — Cấu hình landing page mặc định

### Seed Phân Quyền Động (RBAC):
Mỗi khi bổ sung Module (Chức năng) hoặc Action mới vào file `api.thuypd.site/src/config/rbac.config.ts`:
```bash
cd api.thuypd.site
npm run seed:rbac
```
Hoặc đăng nhập với vai trò `super_admin` trên Admin CMS Portal và bấm nút **"Đồng Bộ Quyền (Config)"** trực tiếp tại trang Quản lý Người Dùng.

### Lưu ý:
- Script seed sẽ **KHÔNG** xóa dữ liệu hiện có (upsert pattern)
- Nếu cần reset hoàn toàn, drop database trước rồi chạy seed lại
- Landing config mặc định cũng có sẵn trong `thuypd.site/src/data/defaultLandingConfig.ts`

## Landing Page Fallback Data

Nếu API không khả dụng, landing page sử dụng fallback data tại:
- `thuypd.site/src/data/` — Mock data cho themes, services, pricing
- `thuypd.site/landing-config.json` — Config file local (persisted bởi server.ts)
