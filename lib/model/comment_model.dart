class CommentModel {
  String? postId;
  String? image;
  String? text;
  
  
   CommentModel(
      {
        this.postId,
 
        this.image,
        this.text,
      });

  CommentModel.fromJson(Map<String, dynamic>? json) {
    postId = json!['postId'];

    image = json['image'];
    text = json['text'];
   
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': postId,

      'image': image,
      'text': text,
     
    };
  }
}