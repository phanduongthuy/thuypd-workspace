# THUYPD.SITE Workspace

Monorepo workspace chứa toàn bộ hệ sinh thái **THUYPD.SITE** — Dịch vụ thiết kế website chuyên nghiệp theo yêu cầu.

## Phân hệ

| Thư mục | Vai trò | Môi trường (.env) |
|---|---|---|
| `thuypd.site/` | Landing page giới thiệu dịch vụ + thu lead | Cấu hình qua `.env` (`NEXT_PUBLIC_SITE_URL`) |
| `api.thuypd.site/` | Backend RESTful API trung tâm | Cấu hình qua `.env` (`PORT`, `DATABASE_URI`,...) |
| `admin.thuypd.site/` | Admin CMS Portal quản trị nội dung | Cấu hình qua `.env` (`NEXT_PUBLIC_API_URL`,...) |

## Quy tắc chung

- Ngôn ngữ nội dung: **Tiếng Việt**
- Mỗi phân hệ là Git Submodule riêng biệt
- **Bảo mật**: Tuyệt đối không hardcode link thật hay thông tin nhạy cảm vào code, note, comment; toàn bộ cấu hình qua file `.env`
- Shared rules và skills nằm trong `.agents/` tại root
- Xem chi tiết architecture tại `.agents/rules/architecture.md`
