class Children {
  int? children_id;
  int? user_id;
  int? classroom_id;
  String? name;
  int? age;
  String? image;

  Children({
    this.children_id,
    this.user_id,
    this.classroom_id,
    this.name,
    this.age,
    this.image,
  });

  factory Children.fromJson(Map<String, dynamic> json) => Children(
        children_id: int.parse(json['children_id']),
        user_id: int.parse(json['user_id']),
        classroom_id: int.parse(json['classroom_id']),
        name: json['name'],
        age: int.parse(json['age']),
        image: json['image'],
      );
}
