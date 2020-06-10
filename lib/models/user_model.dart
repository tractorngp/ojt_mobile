class UserModel {
   bool active;
   String deviceToken;
   String email;
   String name;
   String role;
   String tokenId; 
   bool resetPassword;
  
  UserModel(this.active, this.deviceToken, this.email, this.name, this.role, this.tokenId, this.resetPassword);

  UserModel.map(dynamic obj){
    this.active = obj['active'];
    this.deviceToken = obj['deviceToken'];
    this.email = obj['email'];
    this.name = obj['name'];
    this.role = obj['role'];
    this.tokenId = obj['tokenId'];
    this.resetPassword = obj['resetPassword'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["active"] = active;
    map["deviceToken"] = deviceToken;
    map["email"] = email;
    map["name"] = name;
    map["role"] = role;
    map['tokenId'] = tokenId;
    map['resetPassword'] = resetPassword;
    return map;
  }
}
