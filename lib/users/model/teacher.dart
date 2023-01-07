class Teacher {
  int? teacher_id;
  String? teacher_name;
  String? teacher_email;
  String? teacher_password;

  Teacher(
    this.teacher_id,
    this.teacher_name,
    this.teacher_email,
    this.teacher_password,
  );
  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        int.parse(json['teacher_id']),
        json['teacher_name'],
        json['teacher_email'],
        json['teacher_password'],
      );

  Map<String, dynamic> toJson() => {
        'teacher_id': teacher_id.toString(),
        'teacher_name': teacher_name,
        'teacher_email': teacher_email,
        'teacher_password': teacher_password,
      };
}
