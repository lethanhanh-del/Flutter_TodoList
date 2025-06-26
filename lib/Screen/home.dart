import 'package:bai_ktr_lethanhanh/Provider/provider.dart';
import 'package:bai_ktr_lethanhanh/Screen/add.dart';
import 'package:bai_ktr_lethanhanh/Screen/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Biến lưu trữ chuỗi tìm kiếm

  void initState() {
    super.initState();
    // Đảm bảo tải danh sách khi khởi động
    final provd = Provider.of<provider>(context, listen: false);
    provd.loadToDoList().then((_) {
      setState(() {}); // Cập nhật UI sau khi tải
    });
  }
  tb_XacNhan_remove_to_do (BuildContext context ,int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context)=>AlertDialog(
        title: Align(alignment: Alignment.center,child: Text("Delete Task"),),
        content: Text("Are you sure you want delete this task?"),
        actions: [
          Container(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Cancel
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },

                    child: Container(
                      width: 145,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Viền mỏng cho Cancel
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white, // Màu nền cho Cancel
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Màu chữ cho Cancel
                        ),
                      ),
                    ),

                ),
                // Nút Delete
                InkWell(
                  onTap: () {
                    context.read<provider>().remove_todo(index);
                    Navigator.of(context).pop();
                  },

                    child: Container(
                      width: 145,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red, // Màu đỏ cho Delete
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Màu chữ trắng cho Delete
                        ),
                      ),
                    ),

                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider>(
      builder: (context, pro, _) {

        List<Widget> ds = List.generate(pro.sl_doto, (index) {
          String title = pro.ds_todo.elementAt(index).tieude;
          String description = pro.ds_todo.elementAt(index).mieu_ta;


          if (title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              description.toLowerCase().contains(_searchQuery.toLowerCase())) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => edit_todo(index: index)));
              },
              child: Container(
                width: double.infinity,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () {
                            tb_XacNhan_remove_to_do(context, index);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.red,
                          )),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        }).where((element) => element is InkWell).toList();

        return Scaffold(
          appBar: AppBar(
            title: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.black),
                onChanged: (text) {
                  setState(() {
                    _searchQuery = text; // Cập nhật chuỗi tìm kiếm
                  });
                },
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.black12,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          body: (pro.sl_doto == 0 || ds.isEmpty)
              ? Center(
            child: Text(
              "Không tìm thấy công việc nào",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          )
              : ListView.builder(
            itemCount: ds.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ds[index],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => add_todo()));
            },
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
