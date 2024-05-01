
import 'package:clean_architecture_demo/features/posts/data/datasource/remote_datasource.dart';
import 'package:clean_architecture_demo/features/posts/domain/repositories/base_post_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/posts/data/datasource/local_datasource.dart';
import '../../features/posts/data/repositories/post_repository_implementation.dart';
import '../../features/posts/domain/usecase/add_post_usecase.dart';
import '../../features/posts/domain/usecase/delete_post_usecase.dart';
import '../../features/posts/domain/usecase/get_all_posts_usecase.dart';
import '../../features/posts/domain/usecase/update_post_usecase.dart';
import '../../features/posts/presentation/controller/add_delete_update_post_bloc/add_delete_update_post_bloc.dart';
import '../../features/posts/presentation/controller/posts_bloc/posts_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  sl.registerFactory(() => PostsBloc(getAllPostsUseCase: sl()));
  sl.registerFactory(() => AddDeleteUpdatePostBloc(
      addPostUsecase: sl(), updatePostUsecase: sl(), deletePostUsecase: sl()));

// Usecases

  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
  sl.registerLazySingleton(() => AddPostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));

// Repository

  sl.registerLazySingleton<BasePostRepository>(() => PostsRepositoryImplementation(
      basePostsRemoteDataSource: sl(), basePostsLocalDataSource: sl(), networkInfo: sl()));

// Datasources

  sl.registerLazySingleton<BasePostsRemoteDataSource>(
          () => PostsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<BasePostsLocalDataSource>(
          () => PostsLocalDataSourceImpl(sharedPreferences: sl()));

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External


  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
