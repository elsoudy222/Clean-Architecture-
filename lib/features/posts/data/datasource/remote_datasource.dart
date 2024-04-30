import 'dart:convert';

import 'package:clean_architecture_demo/core/error/exception.dart';
import 'package:clean_architecture_demo/features/posts/data/models/post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class BasePostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();

  Future<Unit> deletePost(int id);

  Future<Unit> addPost(PostModel postModel);

  Future<Unit> updatePost(PostModel postModel);
}

const BASE_URL = "https://jsonplaceholder.typicode.com";

class PostsRemoteDataSourceImpl implements BasePostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse(BASE_URL + "/posts/"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body);
      List<PostModel> data = responseBody
          .map<PostModel>((json) => PostModel.fromJson(json))
          .toList();
      return data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = {
      "title": postModel.title,
      "body": postModel.body,
    };
    final response =
        await client.post(Uri.parse(BASE_URL + "/posts/"), body: body);
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int id) async {
    final response = await client.delete(
      Uri.parse(BASE_URL + "/posts/${id.toString()}"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async{
    final postId = postModel.id.toString();
    final body = {
      "title": postModel.title,
      "body": postModel.body,
    };
    final response = await client.patch(
      Uri.parse(BASE_URL + "/posts/${postId}"),
      body: body,);
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }

  }
}
