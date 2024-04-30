


import 'package:clean_architecture_demo/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../entities/post.dart';
import '../repositories/base_post_repository.dart';

class GetAllPostsUsecase {

  final BasePostRepository basePostRepository;
  GetAllPostsUsecase(this.basePostRepository);

  Future<Either<Failure, List<Post>>> call() async {
    return await basePostRepository.getAllPosts();
  }
}