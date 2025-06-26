import 'dart:convert';
import 'dart:io' show File;

import 'package:bai_ktr_lethanhanh/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

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
      print("Đường dẫn hiện tại: ${directory.path}"); // Kiểm tra đường dẫn
      return directory.path;
    } catch (e) {
      print('Error getting local path: $e');
      _errorMessage = 'Lỗi khi truy cập thư mục lưu trữ: $e';
      notifyListeners();
      throw Exception('Unable to get documents directory');
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("Đường dẫn tệp: $path/ToDoList.json"); // Kiểm tra đường dẫn tệp
    return File('$path/ToDoList.json');
  }

  Future<List<todo_list>> _readToDoList() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        print("Nội dung tệp JSON: $contents"); // In nội dung tệp
        final List<dynamic> decoded = jsonDecode(contents);
        print("Danh sách sau khi decode: $decoded"); // Kiểm tra decoded data
        return decoded.map((json) => todo_list.fromJson(json)).toList();
      }
      print("Tệp rỗng hoặc không tồn tại");
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
      print("Dữ liệu ghi vào JSON: $encodableList"); // Kiểm tra dữ liệu trước khi ghi
      await file.writeAsString(jsonEncode(encodableList));
      print("Ghi tệp thành công");
    } catch (e) {
      print('Error writing ToDoList: $e');
      _errorMessage = 'Lỗi khi lưu danh sách: $e';
      notifyListeners();
    }
  }

  Future<void> loadToDoList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedList = await _readToDoList();
      if (loadedList.isNotEmpty) {
        _ds_todo = loadedList;
        print("Danh sách todo sau khi tải: $_ds_todo"); // Kiểm tra danh sách
      } else {
        print("Không có dữ liệu để tải");
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải danh sách: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add_todo(String tieude, String mieuta) async {
    final newTodo = todo_list(tieude: tieude, mieu_ta: mieuta);
    _ds_todo.add(newTodo);
    await _writeToDoList(_ds_todo);
    notifyListeners();
  }

  Future<void> update_todo(int index, String title, String description) async {
    if (index >= 0 && index < _ds_todo.length) {
      _ds_todo[index].tieude = title;
      _ds_todo[index].mieu_ta = description;
      await _writeToDoList(_ds_todo);
      notifyListeners();
    }
  }

  Future<void> remove_todo(int index) async {
    if (index >= 0 && index < _ds_todo.length) {
      _ds_todo.removeAt(index);
      await _writeToDoList(_ds_todo);
      notifyListeners();
    }
  }
}