import 'package:bai_ktr_lethanhanh/Provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class add_todo extends StatefulWidget {
  const add_todo({super.key});

  @override
  State<add_todo> createState() => _add_todoState();
}

class _add_todoState extends State<add_todo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<provider>(
        builder: (context,pro,_){

          TextEditingController titleController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();

          return Scaffold(
            appBar: AppBar(
            ),
            body:Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(padding: EdgeInsets.only(left: 20),
                    child: Text("Add Task",style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(padding: EdgeInsets.only(left: 20,top: 20),
                    child: Text("Title",style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Read a book",
                      hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.transparent ,
                      filled: true,
                      // border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(padding: EdgeInsets.only(left: 20,top: 20),
                    child: Text("Description",style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Finish the novel",
                      hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.transparent ,
                      filled: true,
                      // border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // borderSide: BorderSide.none,
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
                        // Lấy giá trị từ các trường nhập liệu
                        String tieude = titleController.text;
                        String mieuta = descriptionController.text;

                        // Kiểm tra nếu trường title và description không rỗng
                        if (tieude.isNotEmpty && mieuta.isNotEmpty) {
                          pro.add_todo(tieude, mieuta);
                          print("thêm thành công");
                          Navigator.pop(context);
                        // Xóa dữ liệu trong các trường nhập liệu sau khi thêm
                          titleController.clear();
                          descriptionController.clear();

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        minimumSize: Size(400, 50), // Màu xám
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bo góc nút
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );

  }
}
