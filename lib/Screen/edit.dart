import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';

class edit_todo extends StatefulWidget {
  final int index; // Chỉ số của mục cần chỉnh sửa

  const edit_todo({super.key, required this.index});

  @override
  State<edit_todo> createState() => _edit_todoState();
}

class _edit_todoState extends State<edit_todo> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin title và description từ provider
    final pro = context.read<provider>();
    titleController = TextEditingController(text: pro.ds_todo[widget.index].tieude);
    descriptionController = TextEditingController(text: pro.ds_todo[widget.index].mieu_ta);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider>(
      builder: (context, pro, _) {
        return Scaffold(
          appBar: AppBar(
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Edit Task",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "Title",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: titleController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Read a book",
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.transparent,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Finish the novel",
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.transparent,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String tieude = titleController.text;
                      String mieuta = descriptionController.text;

                      if (tieude.isNotEmpty && mieuta.isNotEmpty) {
                        // Cập nhật lại dữ liệu trong danh sách
                        pro.update_todo(widget.index, tieude, mieuta);
                        print("Cập nhật thành công");
                        Navigator.pop(context); // Quay lại màn hình trước đó
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      minimumSize: Size(400, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
