
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/base_post_repository.dart';

class DeletePostUsecase {
  final BasePostRepository basePostRepository;

  DeletePostUsecase(this.basePostRepository);
  Future<Either<Failure,Unit>> call(int id) async {
    return await basePostRepository.deletePost(id);
  }

}