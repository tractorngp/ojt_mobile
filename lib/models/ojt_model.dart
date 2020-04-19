class OJTsCardModel {
  final String id;
  final String title;
  final String status;
  final List images;
  final dynamic questions;
  
  
  OJTsCardModel(this.id, this.title, this.status, this.images, this.questions);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["status"] = status;
    map["images"] = images;
    map["questions"] = questions;
    return map;
  }
}
