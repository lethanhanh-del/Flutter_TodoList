# ToDoList Application / Ứng dụng ToDoList

## Overview / Tổng quan
- **English**: The ToDoList application is a mobile app built with Flutter, designed to help users manage their daily tasks efficiently. Users can add, edit, delete, and search for tasks, with the ability to mark tasks as completed by click button done. The app stores task data locally in a JSON file and provides notifications when tasks are removed.
- **Tiếng Việt**: Ứng dụng ToDoList là một ứng dụng di động được xây dựng bằng Flutter, giúp người dùng quản lý công việc hàng ngày một cách hiệu quả. Người dùng có thể thêm, chỉnh sửa, xóa và tìm kiếm công việc, đồng thời đánh dấu công việc đã hoàn thành bằng cách nhấn nút done. Dữ liệu công việc được lưu trữ cục bộ dưới dạng tệp JSON và gửi thông báo khi công việc bị xóa.

## Features / Các tính năng
- **English**:
  - **Add Task**: Add new tasks with a title and description.
  - **Edit Task**: Modify existing tasks' titles and descriptions.
  - **Delete Task**: Remove tasks with a confirmation dialog.
  - **Search Task**: Search tasks by title or description using a search bar.
  - **Mark as Completed**: click button done on a task to mark it as completed (currently completion the task, with potential for future enhancement to track removes status).
  - **Local Storage**: Persist tasks in a local JSON file.
  - **Notifications**: Receive notifications when a task is added, deleted, edited.
- **Tiếng Việt**:
  - **Thêm công việc**: Thêm mới công việc với tiêu đề và mô tả.
  - **Chỉnh sửa công việc**: Sửa đổi tiêu đề và mô tả của công việc hiện có.
  - **Xóa công việc**: Xóa công việc với hộp thoại xác nhận.
  - **Tìm kiếm công việc**: Tìm kiếm công việc theo tiêu đề hoặc mô tả bằng thanh tìm kiếm.
  - **Đánh dấu hoàn thành**: Nhấn nút Done trên một công việc để đánh dấu hoàn thành (hiện tại hoàn thành công việc, có thể mở rộng để theo dõi trạng thái xóa).
  - **Lưu trữ cục bộ**: Lưu trữ công việc trong tệp JSON cục bộ.
  - **Thông báo**: Nhận thông báo khi thêm, xóa, sửa một công việc.

## Technologies and Libraries / Công nghệ và thư viện
- **English**:
  - **Flutter**: The core framework for building the cross-platform mobile application (Android/iOS).
  - **Dart**: The programming language used for app logic and UI development.
  - **Provider**: State management library to manage the app's state and notify UI updates.
  - **path_provider**: Library to access the app's documents directory for local storage.
  - **flutter_slidable** (or `Dismissible`): Library (or built-in widget) to implement the swipe-to-complete feature (Note: Version compatibility issues may require using `Dismissible` as a fallback).
  - **flutter_local_notifications** (optional): Library for sending local notifications (assumed based on `NotificationServiceManager` usage; ensure proper integration).
- **Tiếng Việt**:
  - **Flutter**: Framework cốt lõi để xây dựng ứng dụng đa nền tảng (Android/iOS).
  - **Dart**: Ngôn ngữ lập trình dùng để phát triển logic và giao diện.
  - **Provider**: Thư viện quản lý trạng thái để quản lý danh sách công việc và cập nhật giao diện.
  - **path_provider**: Thư viện để truy cập thư mục tài liệu của ứng dụng cho lưu trữ cục bộ.
  - **flutter_slidable** (hoặc `Dismissible`): Thư viện (hoặc widget tích hợp) để thực hiện tính năng kéo để hoàn thành (Lưu ý: Có thể gặp vấn đề tương thích phiên bản, dùng `Dismissible` làm giải pháp thay thế).
  - **flutter_local_notifications** (tùy chọn): Thư viện để gửi thông báo cục bộ (giả định dựa trên `NotificationServiceManager`, cần tích hợp đúng).

## Installation / Hướng dẫn cài đặt
- **English**:
  1. **Clone the Repository**:
     ```bash
     git clone https://github.com/your-username/todolist.git
     cd todolist