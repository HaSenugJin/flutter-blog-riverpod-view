class User {
  final int id;
  final String username;
  final String email;
  final String imgUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
  });

// 응답 받은 데이터를 json 처럼 생긴 Map => Dart 오브젝트로 변환하는 함수
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        email = json["email"] ?? "", // ??  왜하는걸까
        imgUrl = json["imgUrl"],
        createdAt = json["createdAt"] ?? null,
        updatedAt = json["updatedAt"] ?? null;
}