import 'package:bai_ktr_lethanhanh/Model/model.dart';
import 'package:flutter/cupertino.dart';

class provider extends ChangeNotifier{
  List<todo_list> _ds_todo =
  [
    todo_list(tieude: "Buy groceries", mieu_ta: "Milk, eggs, bread"),
    todo_list(tieude: "Call Alice", mieu_ta: "Ask about the weekend"),
    todo_list(tieude: "Walk the dog", mieu_ta: "30-minute walk"),
  ];
  // List<todo_list> _ds_todo = [];
  List<todo_list> get ds_todo =>_ds_todo;

  int get sl_doto => _ds_todo.length;
  void add_todo(String tieude , String mieuta){
    _ds_todo.add(todo_list(tieude: tieude, mieu_ta: mieuta));
    notifyListeners();
  }
  void update_todo(int index, String title, String description) {
    ds_todo[index].tieude = title;
    ds_todo[index].mieu_ta = description;
    notifyListeners();
  }
  void remove_todo(int index){
    ds_todo.removeAt(index);
    notifyListeners();
  }
}