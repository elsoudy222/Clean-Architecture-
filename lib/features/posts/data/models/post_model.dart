import 'package:clean_architecture_demo/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    int? id,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
  };
}
