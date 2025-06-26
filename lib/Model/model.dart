class todo_list {
  String tieude;
  String mieu_ta;

  todo_list({required this.tieude, required this.mieu_ta});

  // Chuyển từ JSON sang đối tượng
  factory todo_list.fromJson(Map<String, dynamic> json) {
    return todo_list(
      tieude: json['tieude'] as String,
      mieu_ta: json['mieu_ta'] as String,
    );
  }

  // Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'tieude': tieude,
      'mieu_ta': mieu_ta,
    };
  }
}