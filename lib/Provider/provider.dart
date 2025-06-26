import 'dart:convert';
import 'dart:io' show File;

import 'package:bai_ktr_lethanhanh/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class provider extends ChangeNotifier {
  // Danh sách công việc
  List<todo_list> _ds_todo = [];

  // Getter cho số lượng công việc
  int get sl_doto => _ds_todo.length;

  // Getter cho danh sách công việc
  List<todo_list> get ds_todo => _ds_todo;

  // Trạng thái tải
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Thông báo lỗi
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Lấy đường dẫn lưu trữ cục bộ
  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print("Đường dẫn hiện tại: ${directory.path}");
      return directory.path;
    } catch (e) {
      print('Error getting local path: $e');
      _errorMessage = 'Lỗi khi truy cập thư mục lưu trữ: $e';
      notifyListeners();
      throw Exception('Unable to get documents directory');
    }
  }

  // Lấy tệp JSON
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ToDoList.json');
  }

  // Đọc dữ liệu từ tệp JSON
  Future<List<todo_list>> _readToDoList() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(contents);
        print("ds todo is : ${ds_todo}");
        return decoded.map((json) => todo_list.fromJson(json)).toList();
      }
      print("ds toto rỗng ");
      return [];
    } catch (e) {
      print('Error reading ToDoList: $e');
      _errorMessage = 'Lỗi khi đọc danh sách: $e';
      notifyListeners();
      return [];
    }
  }

  // Ghi dữ liệu vào tệp JSON
  Future<void> _writeToDoList(List<todo_list> todoList) async {
    try {
      final file = await _localFile;
      final encodableList = todoList.map((todo) => todo.toJson()).toList();
      await file.writeAsString(jsonEncode(encodableList));
    } catch (e) {
      print('Error writing ToDoList: $e');
      _errorMessage = 'Lỗi khi lưu danh sách: $e';
      notifyListeners();
    }
  }

  // Tải danh sách từ tệp JSON khi khởi tạo
  Future<void> loadToDoList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedList = await _readToDoList();
      if (loadedList.isNotEmpty) {
        _ds_todo = loadedList;
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải danh sách: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm công việc mới
  Future<void> add_todo(String tieude, String mieuta) async {
    final newTodo = todo_list(tieude: tieude, mieu_ta: mieuta);
    _ds_todo.add(newTodo);
    await _writeToDoList(_ds_todo); // Lưu sau khi thêm
    notifyListeners();
  }

  // Cập nhật công việc
  Future<void> update_todo(int index, String title, String description) async {
    if (index >= 0 && index < _ds_todo.length) {
      _ds_todo[index].tieude = title;
      _ds_todo[index].mieu_ta = description;
      await _writeToDoList(_ds_todo); // Lưu sau khi cập nhật
      notifyListeners();
    }
  }

  // Xóa công việc
  Future<void> remove_todo(int index) async {
    if (index >= 0 && index < _ds_todo.length) {
      _ds_todo.removeAt(index);
      await _writeToDoList(_ds_todo); // Lưu sau khi xóa
      notifyListeners();
    }
  }
}
