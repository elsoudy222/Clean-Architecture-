
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class BasePostRepository {

  Future<Either<Failure,List<Post>>> getAllPosts();
  Future<Either<Failure,Unit>> deletePost(int id);
  Future<Either<Failure,Unit>> updatePost(Post post);
  Future<Either<Failure,Unit>> addPost(Post post);
}