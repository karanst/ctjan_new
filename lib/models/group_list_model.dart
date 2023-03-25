/// response_code : "1"
/// message : "Get Group Data"
/// status : "success"
/// data : [{"id":"1","name":"Facebook","title":"","pincode":"452001,452005,452009,452010","image":"https://developmentalphawizz.com/social_media/uploads/","status":"1","description":"Facebook","created_date":"2023-03-25 10:06:51","video":"1679738811big_buck_bunny_720p_1mb.mp4","total_user":null},{"id":"2","name":"Instagram","title":"","pincode":"452001,452004,452008,452009","image":"https://developmentalphawizz.com/social_media/uploads/","status":"1","description":"Instagram","created_date":"2023-03-25 10:11:16","video":"1679739076big_buck_bunny_720p_1mb.mp4","total_user":null}]

class GroupListModel {
  GroupListModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<GroupList>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  GroupListModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GroupList.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<GroupList>? _data;
GroupListModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<GroupList>? data,
}) => GroupListModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<GroupList>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// name : "Facebook"
/// title : ""
/// pincode : "452001,452005,452009,452010"
/// image : "https://developmentalphawizz.com/social_media/uploads/"
/// status : "1"
/// description : "Facebook"
/// created_date : "2023-03-25 10:06:51"
/// video : "1679738811big_buck_bunny_720p_1mb.mp4"
/// total_user : null

class GroupList {
  GroupList({
      String? id, 
      String? name, 
      String? title, 
      String? pincode, 
      String? image, 
      String? status, 
      String? description, 
      String? createdDate, 
      String? video, 
      dynamic totalUser,}){
    _id = id;
    _name = name;
    _title = title;
    _pincode = pincode;
    _image = image;
    _status = status;
    _description = description;
    _createdDate = createdDate;
    _video = video;
    _totalUser = totalUser;
}

  GroupList.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _title = json['title'];
    _pincode = json['pincode'];
    _image = json['image'];
    _status = json['status'];
    _description = json['description'];
    _createdDate = json['created_date'];
    _video = json['video'];
    _totalUser = json['total_user'];
  }
  String? _id;
  String? _name;
  String? _title;
  String? _pincode;
  String? _image;
  String? _status;
  String? _description;
  String? _createdDate;
  String? _video;
  dynamic _totalUser;
GroupList copyWith({  String? id,
  String? name,
  String? title,
  String? pincode,
  String? image,
  String? status,
  String? description,
  String? createdDate,
  String? video,
  dynamic totalUser,
}) => GroupList(  id: id ?? _id,
  name: name ?? _name,
  title: title ?? _title,
  pincode: pincode ?? _pincode,
  image: image ?? _image,
  status: status ?? _status,
  description: description ?? _description,
  createdDate: createdDate ?? _createdDate,
  video: video ?? _video,
  totalUser: totalUser ?? _totalUser,
);
  String? get id => _id;
  String? get name => _name;
  String? get title => _title;
  String? get pincode => _pincode;
  String? get image => _image;
  String? get status => _status;
  String? get description => _description;
  String? get createdDate => _createdDate;
  String? get video => _video;
  dynamic get totalUser => _totalUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['title'] = _title;
    map['pincode'] = _pincode;
    map['image'] = _image;
    map['status'] = _status;
    map['description'] = _description;
    map['created_date'] = _createdDate;
    map['video'] = _video;
    map['total_user'] = _totalUser;
    return map;
  }

}