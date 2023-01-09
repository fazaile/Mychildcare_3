class Classroom {
  int? menu_id;
  int? classroom_id;
  String? menu_name;
  String? menu_date;
  String? menu_start_time;
  String? menu_end_time;

  Classroom(
      {this.menu_id,
      this.classroom_id,
      this.menu_name,
      this.menu_date,
      this.menu_start_time,
      this.menu_end_time});

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        menu_id: int.parse(json['menu_id']),
        classroom_id: int.parse(json['classroom_id']),
        menu_name: json['menu_name'],
        menu_date: json['menu_date'],
        menu_start_time: json['menu_start_time'],
        menu_end_time: json['menu_end_time'],
      );
}
