class PostModel {
  String? name;
 String? image;
  String? uId;
  String? dateTime;
  String? postImage;
  String? text;

  PostModel({
    this.name,
    this.dateTime,
    this.text,
    this.postImage,
    this.uId,
   this.image,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    dateTime = json['dateTime'];
    uId = json['uId'];
   image = json['image'];
    postImage = json['postImage'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'postImage': postImage,
      'text':text
    };
  }
}
