import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/features/posts/domain/repositories/base_post_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/post.dart';

class UpdatePostUsecase {
  final BasePostRepository basePostRepository;
  UpdatePostUsecase(this.basePostRepository);

  Future<Either<Failure,Unit>> call(Post post) async {
   return await basePostRepository.updatePost(post);
  }
}