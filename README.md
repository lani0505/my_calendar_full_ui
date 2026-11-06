# MY CALENDAR - FLUTTER WEB

## 1. Mở project

Giải nén file ZIP và mở đúng thư mục:

my_calendar_full

bằng VS Code.

## 2. Cài thư viện

Mở Terminal tại thư mục project:

```bash
flutter pub get
```

## 3. Chạy web

```bash
flutter run -d chrome
```

## 4. Nếu Flutter báo thiếu thư mục web/platform

Chạy:

```bash
flutter create .
```

Lệnh này sẽ tạo các file platform còn thiếu và giữ nguyên code trong thư mục `lib`.

## 5. Build thành website

```bash
flutter build web
```

Sau đó bản website nằm trong:

build/web

## Chức năng

- Lịch tuần
- Tuần trước
- Tuần sau
- Hôm nay
- Thêm task
- Sửa task
- Xóa task
- Chọn ngày
- Chọn giờ bắt đầu
- Chọn giờ kết thúc
- Ghi chú
- Chọn màu
- Đánh dấu hoàn thành
- Danh sách tất cả task
- Danh sách task hôm nay
- Lưu dữ liệu local
- Xóa toàn bộ dữ liệu

## Cấu trúc

lib/
  main.dart
  models/task.dart
  services/storage_service.dart
  screens/calendar_screen.dart
  widgets/sidebar.dart
  widgets/week_calendar.dart
  widgets/task_card.dart
  widgets/task_dialog.dart
