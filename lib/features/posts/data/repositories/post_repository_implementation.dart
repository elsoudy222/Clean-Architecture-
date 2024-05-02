import 'package:clean_architecture_demo/core/error/exception.dart';
import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/features/posts/data/datasource/remote_datasource.dart';
import 'package:clean_architecture_demo/features/posts/data/models/post_model.dart';

import 'package:clean_architecture_demo/features/posts/domain/entities/post.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../../domain/repositories/base_post_repository.dart';
import '../datasource/local_datasource.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostsRepositoryImplementation implements BasePostRepository {
  final BasePostsRemoteDataSource basePostsRemoteDataSource;
  final BasePostsLocalDataSource basePostsLocalDataSource;
  final NetworkInfo networkInfo;



  PostsRepositoryImplementation({
    required this.basePostsRemoteDataSource,
    required this.basePostsLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await basePostsRemoteDataSource.getAllPosts();
        basePostsLocalDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await basePostsLocalDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async{
    final PostModel postModel = PostModel(title: post.title, body: post.body);
    return await _getMessage(() {
      return basePostsRemoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async{
    return await _getMessage(() {
      return basePostsRemoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async{
    final PostModel postModel = PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessage(() {
      return basePostsRemoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost
      ) async{
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit );
      } on ServerException {
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }

}
