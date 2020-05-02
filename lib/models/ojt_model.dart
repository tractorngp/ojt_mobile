class OJTsCardModel {
  bool active;
  dynamic assigned_to;
  dynamic group_id;
  List images;
  int no_of_attempts;
  String ojt_name;
  dynamic questions;
  int record_id;
  String status;
  
  OJTsCardModel(this.active, this.assigned_to, this.group_id, this.images, this.no_of_attempts, this.ojt_name, this.questions, this.record_id, this.status);

  OJTsCardModel.map(dynamic obj){
    this.active = obj['active'];
    this.assigned_to = obj['assigned_to'];
    this.group_id = obj['group_id'];
    this.images = obj['images'];
    this.no_of_attempts = obj['no_of_attempts'];
    this.ojt_name = obj['ojt_name'];
    this.questions = obj['questions'];
    this.record_id = obj['record_id'];
    this.status = obj['status'];
  }
  
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["active"] = active;
    map["assigned_to"] = assigned_to;
    map["group_id"] = group_id;
    map["images"] = images;
    map['no_of_attempts'] = no_of_attempts;
    map['ojt_name'] = ojt_name;
    map["questions"] = questions;
    map['record_id'] = record_id;
    map['status'] = status;
    return map;
  }

  
}
