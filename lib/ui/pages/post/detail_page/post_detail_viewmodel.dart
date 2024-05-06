import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/repositories/post_repository.dart';
import 'package:flutter_blog/data/store/session_store.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostDetailModel {
  Post post;

  PostDetailModel(this.post);
}

class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  PostDetailViewModel(super.state, this.ref);

  Future<void> notifyUpdate(int postId, PostUpdateReqDTO reqDTO) async {
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO = await PostRepository()
        .updatePost(postId, reqDTO, sessionStore.accessToken!);

    if (responseDTO.success) {
      // 상태 두군데 변경
      state = PostDetailModel(responseDTO.response);
      await ref
          .read(postListProvider.notifier)
          .updatePost(responseDTO.response);
      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 수정 실패 : ${responseDTO.errorMessage}")),
      );
    }
  }

  Future<void> notifyInit(int postId) async {
    // 통신하기
    SessionStore sessionStore = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(postId, sessionStore.accessToken!);

    Logger().d(responseDTO.response);
    // 상태값 갱신 (새로 new해서 넣어줘야 한다)
    state = PostDetailModel(responseDTO.response);
  }

  Future<void> notifyDelete(int postId) async {
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().deletePost(postId, sessionStore.accessToken!);

    if (responseDTO.success) {
      // 두가지 상태 변경 1. PostDetail, 2. PostList(ref)

      // PostListVM 상태 변경 (통신, 직접변경)
      //ref.read(postListProvider.notifier).notifyInit(postId);
      ref.read(postListProvider.notifier).deletePost(postId);

      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시물 삭제 실패 : ${responseDTO.errorMessage}")),
      );
    }
  }
}

// 화면이 stack 에서 제거될때, 창고도 함께 제거되게 하기 (autoDispose)
final postDetailProvider = StateNotifierProvider.family
    .autoDispose<PostDetailViewModel, PostDetailModel?, int>((ref, postId) {
  return PostDetailViewModel(null, ref)..notifyInit(postId);
});
