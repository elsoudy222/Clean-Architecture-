

import 'package:clean_architecture_demo/features/posts/domain/repositories/base_post_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';

class AddPostUsecase{
  final BasePostRepository basePostRepository;
  AddPostUsecase(this.basePostRepository);

  Future<Either<Failure,Unit>> call(Post post) async {
     return await basePostRepository.addPost(post);
    }
}