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
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận hoàn thành'),
        content: Text('Bạn chắc chắn mình đã hoàn thành task này ? "${context.read<provider>().ds_todo[index].tieude}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<provider>().remove_todo(index);
              Navigator.pop(context);
            },
            child: Text('Hoàn thành', style: TextStyle(color: Colors.green)),
          ),
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
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 5,left: 5,bottom: 5),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: 150, // Độ cao tối thiểu
                  ),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
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
                              Icons.done,
                              size: 50,
                              color: Colors.green,
                            )),
                      ),
                    ],
                  ),
                ),
              )
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
            child: Padding(
              padding: EdgeInsetsGeometry.all(2),
              child:  Text(
                "Không tìm thấy công việc nào",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            )
          )
              : ListView.builder(
            itemCount: ds.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 150, // Độ cao tối thiểu
                ),
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
