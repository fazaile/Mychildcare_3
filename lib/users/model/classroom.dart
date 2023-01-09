class Classroom {
  int? classroom_id;
  String? classroom_image;
  String? classroom_name;
  int? classroom_capacity;

  Classroom(
      {this.classroom_id,
      this.classroom_name,
      this.classroom_capacity,
      this.classroom_image});

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        classroom_id: int.parse(json['classroom_id']),
        classroom_name: json['classroom_name'],
        classroom_capacity: int.parse(json['classroom_capacity']),
        classroom_image: json['classroom_image'],
      );
}
