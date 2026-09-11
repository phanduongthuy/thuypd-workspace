---
name: deploy
description: >-
  Hướng dẫn deploy từng phân hệ trong hệ sinh thái THUYPD.SITE.
  Sử dụng khi user yêu cầu deploy, build production, hoặc chuẩn bị môi trường staging/production.
---

# Deploy Workflow — THUYPD.SITE

> [!IMPORTANT]
> Toàn bộ URL dịch vụ, domain production, chuỗi kết nối database và secret keys phải được cấu hình qua biến môi trường (`.env`), không hardcode bất kỳ link thật hay thông tin nhạy cảm nào vào mã nguồn, tài liệu hoặc ghi chú.

---

## 1. thuypd.site (Landing Page)

### Local Development
```bash
cd thuypd.site
npm install
npm run dev
# Next.js dev server chạy tại http://localhost:3000
```

### Production Build (Docker)
```bash
cd thuypd.site
docker build -t thuypd-site .
docker run -p 3000:3000 thuypd-site
```

### Production Build (Manual)
```bash
cd thuypd.site
npm run build
npm start
# Chạy Next.js production server tại port 3000
```

### Deploy lên Vercel
1. Push code lên Git remote repository
2. Tạo project trên Vercel:
   - **Framework Preset**: `Next.js`
   - **Root Directory**: `./` (hoặc `thuypd.site` nếu build từ monorepo)
   - **Build Command**: `npm run build`
   - **Output Directory**: Mặc định Next.js
3. Biến môi trường trên Vercel (khai báo theo `.env.example`):
   - `BACKEND_API_URL`
   - `NEXT_PUBLIC_SITE_URL`
   - `GEMINI_API_KEY` (optional)
*Lưu ý: Không cần `vercel.json` vì Next.js App Router tự xử lý Serverless Route Handlers.*

### Biến môi trường cần thiết:
- Xem `.env.example` trong thư mục `thuypd.site`

---

## 2. api.thuypd.site (Backend API)

### Local Development
```bash
cd api.thuypd.site
npm install
npm run dev
# Server chạy với tsx watch (hot reload)
```

### Deploy lên Render.com
1. Push code lên Git remote repository
2. Render.com tự động build theo `render.yaml`
3. Build command: `npm install && npm run build`
4. Start command: `npm start`

### Biến môi trường cần thiết:
- `DATABASE_URI` hoặc `MONGODB_URI` — Chuỗi kết nối MongoDB (khai báo trong `.env`)
- `DATABASE_NAME` — Tên database
- `JWT_SECRET` — Secret key cho JWT token
- `CLIENT_ORIGINS` — Danh sách origins được phép CORS
- `PORT` — Server port

---

## 3. admin.thuypd.site (Admin CMS)

### Local Development
```bash
cd admin.thuypd.site
bun install # hoặc npm install
bun run dev
# Next.js dev server tại http://localhost:3000
```

### Production Build
```bash
cd admin.thuypd.site
bun run build
bun run start
```

### Deploy lên Vercel
1. Push code lên Git remote repository
2. Tạo project trên Vercel:
   - **Framework Preset**: `Next.js`
   - **Root Directory**: `./` (hoặc `admin.thuypd.site` nếu build từ monorepo)
3. Biến môi trường trên Vercel:
   - `NEXT_PUBLIC_API_URL`: Cấu hình theo `.env.example`
   - `BACKEND_API_URL`: Cấu hình theo `.env.example`

### Biến môi trường cần thiết:
- Xem `.env.example` trong thư mục `admin.thuypd.site`

---

## Thứ tự deploy khuyến nghị
1. **api.thuypd.site** trước (backend phải sẵn sàng)
2. **thuypd.site** tiếp theo (landing page cần API)
3. **admin.thuypd.site** cuối cùng (admin cần API)
