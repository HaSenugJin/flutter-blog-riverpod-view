import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dtos/paging_dto.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_viewmodel.dart';
import 'package:logger/logger.dart';

class PostRepository {
  Future<ResponseDTO> updatePost(
      int postId, PostUpdateReqDTO reqDTO, String accessToken) async {
    var response = await dio.put("/api/post/${postId}",
        data: reqDTO.toJson(),
        options: Options(headers: {"Authorization": "${accessToken}"}));

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
    }

    return responseDTO;
  }

  Future<ResponseDTO> deletePost(int postId, String accessToken) async {
    var response = await dio.delete("/api/post/${postId}",
    options: Options(headers: {"Authorization": "${accessToken}"}));

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    return responseDTO;
  }

  Future<ResponseDTO> savePost(
      PostSaveReqDTO reqDTO, String accessToken) async {
    Response response = await dio.post("/api/post",
        options: Options(headers: {"Authorization": "${accessToken}"}),
        data: reqDTO.toJson());

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    Logger().d(responseDTO.response);
    Logger().d(responseDTO.response.runtimeType);

    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
      Logger().d(responseDTO.response.runtimeType);
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchPostList(String accessToken, {int page = 0}) async {
    final response = await dio.get(
      "/api/post",
      queryParameters: {"page": page},
      options: Options(headers: {"Authorization": "${accessToken}"}),
    );

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      List<dynamic> temp = responseDTO.response["posts"];
      List<Post> posts = temp.map((e) => Post.fromJson(e)).toList();
      PageDTO pageDTO = PageDTO.fromJson(responseDTO.response);

      PostListModel postListModel = PostListModel(page: pageDTO, posts: posts);
      responseDTO.response = postListModel;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchPost(int postId, String accessToken) async {
    // 통신
    Response response = await dio.get("/api/post/${postId}",
        options: Options(headers: {"Authorization": "${accessToken}"}));

    print(response.data);

    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    print(responseDTO.response);

    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
    }

    return responseDTO;
  }
}
