class AnimalModel {
  final int id;
  final String name;
  final String threatLevel;

  AnimalModel({
    required this.id,
    required this.name,
    required this.threatLevel,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      threatLevel: json['threatLevel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'threatLevel': threatLevel,
    };
  }
}
