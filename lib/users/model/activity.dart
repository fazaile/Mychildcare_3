class Children {
  int? activity_id;
  int? classroom_id;
  String? activity_description;
  int? activity_date;
  String? activity_start;
  String? activity_end;
  String? activity_image;

  Children({
    this.activity_id,
    this.classroom_id,
    this.activity_description,
    this.activity_date,
    this.activity_start,
    this.activity_end,
    this.activity_image,
  });

  factory Children.fromJson(Map<String, dynamic> json) => Children(
        activity_id: int.parse(json['activity_id']),
        classroom_id: int.parse(json['classroom_id']),
        activity_description: json['activity_description'],
        activity_date: json['activity_date'],
        activity_start: json['activity_start'],
        activity_end: json['activity_start'],
        activity_image: json['activity_image'],
      );
}
