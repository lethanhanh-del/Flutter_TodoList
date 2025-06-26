import 'dart:convert';
import 'dart:io' show File;

import 'package:bai_ktr_lethanhanh/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import '../Notification_soucre/NotificationServiceManager.dart';

class provider extends ChangeNotifier {
  List<todo_list> _ds_todo = [];

  int get sl_doto => _ds_todo.length;
  List<todo_list> get ds_todo => _ds_todo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print("Đường dẫn hiện tại: ${directory.path}"); // Log đường dẫn
      return directory.path;
    } catch (e) {
      print('Error getting local path: $e');
      _errorMessage = 'Lỗi khi truy cập thư mục: $e';
      notifyListeners();
      throw Exception('Unable to get documents directory');
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("Đường dẫn tệp: $path/ToDoList.json"); // Log đường dẫn tệp
    return File('$path/ToDoList.json');
  }

  Future<List<todo_list>> _readToDoList() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        print("Nội dung tệp JSON: $contents"); // Log nội dung tệp
        final List<dynamic> decoded = jsonDecode(contents);
        print("Danh sách decoded: $decoded"); // Log dữ liệu decoded
        return decoded.map((json) => todo_list.fromJson(json)).toList();
      }
      print("Tệp rỗng hoặc không tồn tại"); // Log khi tệp rỗng
      return [];
    } catch (e) {
      print('Error reading ToDoList: $e');
      _errorMessage = 'Lỗi khi đọc danh sách: $e';
      notifyListeners();
      return [];
    }
  }

  Future<void> _writeToDoList(List<todo_list> todoList) async {
    try {
      final file = await _localFile;
      final encodableList = todoList.map((todo) => todo.toJson()).toList();
      print("Dữ liệu ghi vào JSON: $encodableList"); // Log dữ liệu trước khi ghi
      await file.writeAsString(jsonEncode(encodableList));
      print("Ghi tệp thành công"); // Log khi ghi thành công
    } catch (e) {
      print('Error writing ToDoList: $e');
      _errorMessage = 'Lỗi khi lưu danh sách: $e';
      notifyListeners();
    }
  }

  Future<void> loadToDoList() async {
    print("Bắt đầu tải danh sách..."); // Log bắt đầu tải
    _isLoading = true;
    notifyListeners();

    try {
      final loadedList = await _readToDoList();
      if (loadedList.isNotEmpty) {
        _ds_todo = loadedList;
        print("Danh sách todo sau khi tải: $_ds_todo"); // Log danh sách sau khi tải
      } else {
        print("Không có dữ liệu để tải");
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải danh sách: $e';
      print("Lỗi khi tải: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add_todo(String tieude, String mieuta) async {
    final newTodo = todo_list(tieude: tieude, mieu_ta: mieuta);
    _ds_todo.add(newTodo);
    await _writeToDoList(_ds_todo);

    try {
      NotificationDetails details = NotificationServiceManager().getNotificationDetail(
        channelId: 'add task',
        channelName: 'add task ${tieude}',
      );

      await NotificationServiceManager().show(
        title: 'Thông Báo thêm',
        body: 'Bạn vừa thêm task: ${tieude}',
        notificationDetails: details,
      );
    } catch (e) {
      print('Lỗi gửi thông báo: $e');
      _errorMessage = 'Lỗi khi gửi thông báo: $e';
    }

    notifyListeners();
  }

  Future<void> update_todo(int index, String title, String description) async {
    if (index >= 0 && index < _ds_todo.length) {
      _ds_todo[index].tieude = title;
      _ds_todo[index].mieu_ta = description;
      await _writeToDoList(_ds_todo);

      try {
        NotificationDetails details = NotificationServiceManager().getNotificationDetail(
          channelId: 'update task ',
          channelName: 'update task ${index}',
        );

        await NotificationServiceManager().show(
          title: 'Thông Báo cập nhật',
          body: 'Bạn vừa sửa thông tin task: ${_ds_todo[index].tieude}',
          notificationDetails: details,
        );
      } catch (e) {
        print('Lỗi gửi thông báo: $e');
        _errorMessage = 'Lỗi khi gửi thông báo: $e';
      }

      notifyListeners();
    }
  }

  Future<void> remove_todo(int index) async {
    if (index >= 0 && index < _ds_todo.length) {
      final removedTodo = _ds_todo[index]; // Lưu task bị xóa để sử dụng trong thông báo
      _ds_todo.removeAt(index);
      await _writeToDoList(_ds_todo);

      // Gửi thông báo khi xóa task
      try {
        NotificationDetails details = NotificationServiceManager().getNotificationDetail(
          channelId: 'task',
          channelName: 'task_${index}',
        );

        await NotificationServiceManager().show(
          title: 'Thông Báo hoàn thành',
          body: 'Bạn vừa đánh dấu hoàn thành task: ${removedTodo.tieude}',
          notificationDetails: details,
        );
      } catch (e) {
        print('Lỗi gửi thông báo: $e');
        _errorMessage = 'Lỗi khi gửi thông báo: $e';
      }

      notifyListeners();
    }
  }
}