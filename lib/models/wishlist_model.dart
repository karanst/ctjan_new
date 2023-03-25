/// response_code : "1"
/// message : "get data succesfully"
/// status : "success"
/// data : [{"id":"4","user_id":"2","post_id":"4","name":"2","description":"2","date":"0000-00-00","img":"","group_id":"5","like_status":"0","end_date":"2","start_date":"2","post_type":"1"},{"id":"4","user_id":"2","post_id":"4","name":"2","description":"2","date":"0000-00-00","img":"","group_id":"5","like_status":"0","end_date":"2","start_date":"2","post_type":"1"},{"id":"4","user_id":"2","post_id":"4","name":"2","description":"2","date":"0000-00-00","img":"","group_id":"5","like_status":"0","end_date":"2","start_date":"2","post_type":"1"}]

class WishlistModel {
  WishlistModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<WishList>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  WishlistModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(WishList.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<WishList>? _data;
WishlistModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<WishList>? data,
}) => WishlistModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<WishList>? get data => _data;

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

/// id : "4"
/// user_id : "2"
/// post_id : "4"
/// name : "2"
/// description : "2"
/// date : "0000-00-00"
/// img : ""
/// group_id : "5"
/// like_status : "0"
/// end_date : "2"
/// start_date : "2"
/// post_type : "1"

class WishList {
  WishList({
      String? id, 
      String? userId, 
      String? postId, 
      String? name, 
      String? description, 
      String? date, 
      String? img, 
      String? groupId, 
      String? likeStatus, 
      String? endDate, 
      String? startDate, 
      String? postType,}){
    _id = id;
    _userId = userId;
    _postId = postId;
    _name = name;
    _description = description;
    _date = date;
    _img = img;
    _groupId = groupId;
    _likeStatus = likeStatus;
    _endDate = endDate;
    _startDate = startDate;
    _postType = postType;
}

  WishList.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _postId = json['post_id'];
    _name = json['name'];
    _description = json['description'];
    _date = json['date'];
    _img = json['img'];
    _groupId = json['group_id'];
    _likeStatus = json['like_status'];
    _endDate = json['end_date'];
    _startDate = json['start_date'];
    _postType = json['post_type'];
  }
  String? _id;
  String? _userId;
  String? _postId;
  String? _name;
  String? _description;
  String? _date;
  String? _img;
  String? _groupId;
  String? _likeStatus;
  String? _endDate;
  String? _startDate;
  String? _postType;
WishList copyWith({  String? id,
  String? userId,
  String? postId,
  String? name,
  String? description,
  String? date,
  String? img,
  String? groupId,
  String? likeStatus,
  String? endDate,
  String? startDate,
  String? postType,
}) => WishList(  id: id ?? _id,
  userId: userId ?? _userId,
  postId: postId ?? _postId,
  name: name ?? _name,
  description: description ?? _description,
  date: date ?? _date,
  img: img ?? _img,
  groupId: groupId ?? _groupId,
  likeStatus: likeStatus ?? _likeStatus,
  endDate: endDate ?? _endDate,
  startDate: startDate ?? _startDate,
  postType: postType ?? _postType,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get postId => _postId;
  String? get name => _name;
  String? get description => _description;
  String? get date => _date;
  String? get img => _img;
  String? get groupId => _groupId;
  String? get likeStatus => _likeStatus;
  String? get endDate => _endDate;
  String? get startDate => _startDate;
  String? get postType => _postType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['post_id'] = _postId;
    map['name'] = _name;
    map['description'] = _description;
    map['date'] = _date;
    map['img'] = _img;
    map['group_id'] = _groupId;
    map['like_status'] = _likeStatus;
    map['end_date'] = _endDate;
    map['start_date'] = _startDate;
    map['post_type'] = _postType;
    return map;
  }

}