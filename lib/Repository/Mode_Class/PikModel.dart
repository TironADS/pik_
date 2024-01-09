class PikModel {
  PikModel({
      this.imageUrl, 
      this.message,});

  PikModel.fromJson(dynamic json) {
    imageUrl = json['imageUrl'];
    message = json['message'];
  }
  String? imageUrl;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageUrl'] = imageUrl;
    map['message'] = message;
    return map;
  }

}