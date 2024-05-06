class PageDTO {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;

  PageDTO.fromJson(Map<String, dynamic> json)
      : isFirst = json["isFirst"],
        isLast = json["isLast"],
        pageNumber = json["pageNumber"],
        size = json["size"],
        totalPage = json["totalPage"];
}