# Coding Conventions & Development Rules — THUYPD.SITE

Tài liệu quy định chi tiết về chuẩn mực lập trình (Coding Standards) và nguyên tắc cấu trúc code áp dụng trên toàn bộ workspace.

---

## 1. Ngôn Ngữ & Đặt Tên
- **Nội dung người dùng cuối (UI Text):** 100% **Tiếng Việt** (Labels, Placeholders, Buttons, Error toasts, Alerts).
- **Mã nguồn (Code Symbols):** 100% **Tiếng Anh**:
  - Biến & hàm: `camelCase` (ví dụ: `fetchLandingConfig`, `isLoading`)
  - React Components & Types/Interfaces: `PascalCase` (ví dụ: `LandingConfigView`, `ISetting`)
  - Hằng số toàn cục: `UPPER_SNAKE_CASE` (ví dụ: `BACKEND_URL`, `STORAGE_KEY`)
  - File components: `kebab-case.tsx` hoặc `PascalCase.tsx` nhất quán theo từng phân hệ.

---

## 2. TypeScript & Type Safety
- `strict: true` luôn bật trong `tsconfig.json`.
- Tuyệt đối hạn chế `any` trừ trường hợp thư viện bên thứ ba không có type; ưu tiên `unknown` kèm type guards hoặc generic types.
- Dùng `interface` cho object shapes có tính kế thừa; dùng `type` cho union, intersection, hoặc utility types.
- Sử dụng Path Aliases:
  - Admin: `@/features/...`, `@/components/...`, `@/lib/...`
  - Landing: `src/features/...`, `src/components/...`, `src/core/...`

---

## 3. Cấu Trúc Module & Feature-Driven (Frontend)
- Mỗi domain tính năng nằm trong `features/<domain>/` gồm:
  - `api/`: Các hàm fetch/mutation và parser dữ liệu.
  - `components/`: UI components độc quyền của feature.
  - `hooks/`: Business logic, custom hooks.
  - `index.ts`: Barrel export.
- Các trang trong `app/` (Next.js) hoặc `App.tsx` (Vite) phải giữ cực kỳ ngắn gọn (~10 dòng), chỉ làm nhiệm vụ compose và render feature view.
- Không import chéo private files giữa các feature; chỉ import qua `features/<domain>/index.ts` nếu thực sự cần thiết.

---

## 4. Clean Architecture (Backend REST API)
- **Controller:** Chỉ phân tích HTTP request và gọi Service, không chứa câu truy vấn Database.
- **Service:** Nơi thực thi logic nghiệp vụ, tính toán, và gọi Repository.
- **Repository:** Nơi duy nhất làm việc với Mongoose Models và In-Memory Fallback.
- **Response Format Thống Nhất:**
  ```json
  {
    "success": true,
    "statusCode": 200,
    "message": "Mô tả kết quả...",
    "data": { ... },
    "timestamp": "2026-09-11T..."
  }
  ```

---

## 5. Xử Lý Ngoại Lệ & Fallback (Resilience)
- Mọi hàm gọi mạng từ Client/Admin tới Backend đều phải bọc trong `try / catch` và cấu hình `AbortController` timeout (3.5s - 8s).
- Không để xảy ra unhandled rejection làm crash ứng dụng.
- Khi Backend không khả dụng, kích hoạt dữ liệu dự phòng an toàn (Safe Fallback) và thông báo bằng toast thân thiện.
