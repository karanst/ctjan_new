/// response_code : "1"
/// message : "Get Group Data"
/// status : "success"
/// data : [{"f_name":" Karan Tomar","profile_pic":"1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg","l_name":""},{"f_name":"d","profile_pic":"16799982636418189b28e8c.png","l_name":"asdfsd"},{"f_name":"bhopa  ","profile_pic":"","l_name":"singh"},{"f_name":"Karan Singh","profile_pic":"1680162266scaled_41355dda-be61-4588-b4da-0bf2c51102f1257701411622086963.jpg","l_name":""},{"f_name":"vijay ","profile_pic":"","l_name":"jhaa"},{"f_name":"Karan","profile_pic":"","l_name":"Tomar"},{"f_name":"MRkhan","profile_pic":"1680175829image_picker2680611789517735869.jpg","l_name":""}]

class PeopleModel {
  PeopleModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<Data>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  PeopleModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<Data>? _data;
PeopleModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<Data>? data,
}) => PeopleModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<Data>? get data => _data;

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

/// f_name : " Karan Tomar"
/// profile_pic : "1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg"
/// l_name : ""

class Data {
  Data({
      String? fName, 
      String? profilePic, 
      String? lName,}){
    _fName = fName;
    _profilePic = profilePic;
    _lName = lName;
}

  Data.fromJson(dynamic json) {
    _fName = json['f_name'];
    _profilePic = json['profile_pic'];
    _lName = json['l_name'];
  }
  String? _fName;
  String? _profilePic;
  String? _lName;
Data copyWith({  String? fName,
  String? profilePic,
  String? lName,
}) => Data(  fName: fName ?? _fName,
  profilePic: profilePic ?? _profilePic,
  lName: lName ?? _lName,
);
  String? get fName => _fName;
  String? get profilePic => _profilePic;
  String? get lName => _lName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['f_name'] = _fName;
    map['profile_pic'] = _profilePic;
    map['l_name'] = _lName;
    return map;
  }

}