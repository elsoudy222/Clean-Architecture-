import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failure.dart';
import '../../../../../core/strings/messages.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/usecase/add_post_usecase.dart';
import '../../../domain/usecase/delete_post_usecase.dart';
import '../../../domain/usecase/update_post_usecase.dart';

part 'add_delete_update_post_event.dart';

part 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUsecase addPostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final DeletePostUsecase deletePostUsecase;

  AddDeleteUpdatePostBloc({
    required this.addPostUsecase,
    required this.updatePostUsecase,
    required this.deletePostUsecase,
  }) : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final addPost = await addPostUsecase(event.post);
        addPost.fold(
          (failure) => emit(
            ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure),
            ),
          ),
          (_) => const SuccessAddDeleteUpdatePostState(
            message: ADD_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final updatePost = await updatePostUsecase(event.post);
        updatePost.fold(
          (failure) => emit(
            ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure),
            ),
          ),
          (_) => const SuccessAddDeleteUpdatePostState(
            message: UPDATE_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final deletePost = await deletePostUsecase(event.postId);
        deletePost.fold(
          (failure) => emit(
            ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure),
            ),
          ),
          (_) => const SuccessAddDeleteUpdatePostState(
            message: DELETE_SUCCESS_MESSAGE,
          ),
        );
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return SERVER_FAILURE_MESSAGE;

      case const (OfflineFailure):
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
