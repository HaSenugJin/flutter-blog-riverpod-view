import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dtos/paging_dto.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/repositories/post_repository.dart';
import 'package:flutter_blog/data/store/session_store.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListModel {
  PageDTO page;
  List<Post> posts;

  PostListModel({required this.page, required this.posts});
}

class PostListViewModel extends StateNotifier<PostListModel?> {
  // StateNotifier 이게머임
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  PostListViewModel(super.state, this.ref);

  Future<void> notifyInit(int page) async {
    SessionStore sessionStore = ref.read(sessionProvider);
    String jwt = sessionStore.accessToken!;

    ResponseDTO responseDTO = await PostRepository().fetchPostList(jwt);

    if (responseDTO.success) {
      state = responseDTO.response;
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 보기 실패 : ${responseDTO.errorMessage}")));
    }
  }

  Future<void> notifyAdd(PostSaveReqDTO reqDTO) async {
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().savePost(reqDTO, sessionUser.accessToken!);

    if (responseDTO.success) {
      Post newPost = responseDTO.response;

      List<Post> prevPosts = state!.posts;
      PageDTO pageDTO = state!.page;

      // DESC 넣기
      List<Post> newPosts = [newPost, ...prevPosts];

      state = PostListModel(page: pageDTO, posts: newPosts);

      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.errorMessage}")),
      );
    }
  }

  Future<void> updatePost(Post post) async {
    // 1. 기존 값 가지고 오기
    PostListModel model = state!;

    // 2. 부분 업데이트
    PageDTO prevPage = model.page;
    List<Post> prevPosts = model.posts;

    // 자바 ()->{}, 자바스크립트 ()=>{}, 다트 (){}
    List<Post> newPosts = prevPosts.map((p) {
      if (p.id == post.id) {
        return post;
      } else {
        return p;
      }
    }).toList();

    await Future.delayed(
        Duration(
          seconds: 5,
        ),
        () => {});
    state = PostListModel(page: prevPage, posts: newPosts);
  }

  // 통신없이 상태 변경
  void deletePost(int postId) {
    PostListModel model = state!;
    List<Post> prevPosts = model.posts;
    PageDTO prevPage = model.page;

    List<Post> newPosts = prevPosts.where((p) => p.id != postId).toList();
    state = PostListModel(page: prevPage, posts: newPosts);
  }
}

final postListProvider =
    StateNotifierProvider<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit(0);
});
