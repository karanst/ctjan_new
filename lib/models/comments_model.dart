/// response_code : "1"
/// message : "get data succesfully"
/// status : "success"
/// data : [{"id":"12","user_id":"88","comment":"","group_id":"5","post_id":"7","like_status":"1","date":"2023-03-24 11:01:49","user_comment":"","username":" karan Tomar","profile_pic":"https://developmentalphawizz.com/social_media/uploads/profile_pics/"}]

class CommentsModel {
  CommentsModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<Comments>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  CommentsModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Comments.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<Comments>? _data;
CommentsModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<Comments>? data,
}) => CommentsModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<Comments>? get data => _data;

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

/// id : "12"
/// user_id : "88"
/// comment : ""
/// group_id : "5"
/// post_id : "7"
/// like_status : "1"
/// date : "2023-03-24 11:01:49"
/// user_comment : ""
/// username : " karan Tomar"
/// profile_pic : "https://developmentalphawizz.com/social_media/uploads/profile_pics/"

class Comments {
  Comments({
      String? id, 
      String? userId, 
      String? comment, 
      String? groupId, 
      String? postId, 
      String? likeStatus, 
      String? date, 
      String? userComment, 
      String? username, 
      String? profilePic,}){
    _id = id;
    _userId = userId;
    _comment = comment;
    _groupId = groupId;
    _postId = postId;
    _likeStatus = likeStatus;
    _date = date;
    _userComment = userComment;
    _username = username;
    _profilePic = profilePic;
}

  Comments.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _comment = json['comment'];
    _groupId = json['group_id'];
    _postId = json['post_id'];
    _likeStatus = json['like_status'];
    _date = json['date'];
    _userComment = json['user_comment'];
    _username = json['username'];
    _profilePic = json['profile_pic'];
  }
  String? _id;
  String? _userId;
  String? _comment;
  String? _groupId;
  String? _postId;
  String? _likeStatus;
  String? _date;
  String? _userComment;
  String? _username;
  String? _profilePic;
Comments copyWith({  String? id,
  String? userId,
  String? comment,
  String? groupId,
  String? postId,
  String? likeStatus,
  String? date,
  String? userComment,
  String? username,
  String? profilePic,
}) => Comments(  id: id ?? _id,
  userId: userId ?? _userId,
  comment: comment ?? _comment,
  groupId: groupId ?? _groupId,
  postId: postId ?? _postId,
  likeStatus: likeStatus ?? _likeStatus,
  date: date ?? _date,
  userComment: userComment ?? _userComment,
  username: username ?? _username,
  profilePic: profilePic ?? _profilePic,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get comment => _comment;
  String? get groupId => _groupId;
  String? get postId => _postId;
  String? get likeStatus => _likeStatus;
  String? get date => _date;
  String? get userComment => _userComment;
  String? get username => _username;
  String? get profilePic => _profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['comment'] = _comment;
    map['group_id'] = _groupId;
    map['post_id'] = _postId;
    map['like_status'] = _likeStatus;
    map['date'] = _date;
    map['user_comment'] = _userComment;
    map['username'] = _username;
    map['profile_pic'] = _profilePic;
    return map;
  }

}