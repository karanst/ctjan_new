/// response_code : "1"
/// message : "Join Group Successfully"
/// status : "success"
/// data : [{"id":"1","name":"camera test 2","description":"camera test description ","img":["https://developmentalphawizz.com/social_media/uploads/1680001245scaled_18382ed0-b595-4b14-b1b4-9a973b7ad4cb3994190884655133755.jpg"],"group_id":"1","user_id":"1","like_status":"0","end_date":"","start_date":"","post_type":"Normal Post","date":"28/03/2023","username":"","email":" karanstomar@icloud.com","f_name":" Karan Tomar","l_name":"","countrycode":"","mobile":" 8770496665","dob":"1998-01-02","gender":"Male","profession":"","exp_job_title":"","exp_employer":"","exp_country":"","exp_start_date":"","exp_end_date":"","exp_current_work":"","exp_description":"","edu_school_name":"","edu_degree":"","edu_field":"","edu_start_date":"","edu_end_date":"","edu_percentage":"","edu_current_study":"","skills_des":"","summary_des":"","accomplishments_des":"","finalize_des":"","password":"","profile_pic":"https://developmentalphawizz.com/social_media/uploads/1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg","facebook_id":"","type":"","isGold":"0","address":"","city":"","country":"","device_token":"","agreecheck":"0","otp":"4390","status":"1","wallet":"0.00","oauth_provider":null,"oauth_uid":null,"last_login":null,"created_at":"2023-03-27 12:36:02","updated_at":"2023-03-28 10:44:24","refferal_code":"","friend_code":"","about_us":" this is my intro"},{"id":"1","name":"My event post ","description":"free for everyone..","img":["https://developmentalphawizz.com/social_media/uploads/1680000357scaled_870dd4b6-3ba8-4d0c-b9c0-f5d4703bc8095540719945971247948.jpg"],"group_id":"1","user_id":"1","like_status":"0","end_date":"2023-03-31","start_date":"2023-03-29","post_type":"Event Post","date":"28/03/2023","username":"","email":" karanstomar@icloud.com","f_name":" Karan Tomar","l_name":"","countrycode":"","mobile":" 8770496665","dob":"1998-01-02","gender":"Male","profession":"","exp_job_title":"","exp_employer":"","exp_country":"","exp_start_date":"","exp_end_date":"","exp_current_work":"","exp_description":"","edu_school_name":"","edu_degree":"","edu_field":"","edu_start_date":"","edu_end_date":"","edu_percentage":"","edu_current_study":"","skills_des":"","summary_des":"","accomplishments_des":"","finalize_des":"","password":"","profile_pic":"https://developmentalphawizz.com/social_media/uploads/1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg","facebook_id":"","type":"","isGold":"0","address":"","city":"","country":"","device_token":"","agreecheck":"0","otp":"4390","status":"1","wallet":"0.00","oauth_provider":null,"oauth_uid":null,"last_login":null,"created_at":"2023-03-27 12:36:02","updated_at":"2023-03-28 10:44:24","refferal_code":"","friend_code":"","about_us":" this is my intro"},{"id":"1","name":"new post","description":"hello everyone ","img":["https://developmentalphawizz.com/social_media/uploads/"],"group_id":"1","user_id":"1","like_status":"0","end_date":"","start_date":"","post_type":"Normal Post","date":"28/03/2023","username":"","email":" karanstomar@icloud.com","f_name":" Karan Tomar","l_name":"","countrycode":"","mobile":" 8770496665","dob":"1998-01-02","gender":"Male","profession":"","exp_job_title":"","exp_employer":"","exp_country":"","exp_start_date":"","exp_end_date":"","exp_current_work":"","exp_description":"","edu_school_name":"","edu_degree":"","edu_field":"","edu_start_date":"","edu_end_date":"","edu_percentage":"","edu_current_study":"","skills_des":"","summary_des":"","accomplishments_des":"","finalize_des":"","password":"","profile_pic":"https://developmentalphawizz.com/social_media/uploads/1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg","facebook_id":"","type":"","isGold":"0","address":"","city":"","country":"","device_token":"","agreecheck":"0","otp":"4390","status":"1","wallet":"0.00","oauth_provider":null,"oauth_uid":null,"last_login":null,"created_at":"2023-03-27 12:36:02","updated_at":"2023-03-28 10:44:24","refferal_code":"","friend_code":"","about_us":" this is my intro"}]

class MypostsModel {
  MypostsModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<MyPosts>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  MypostsModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MyPosts.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<MyPosts>? _data;
MypostsModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<MyPosts>? data,
}) => MypostsModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<MyPosts>? get data => _data;

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
/// name : "camera test 2"
/// description : "camera test description "
/// img : ["https://developmentalphawizz.com/social_media/uploads/1680001245scaled_18382ed0-b595-4b14-b1b4-9a973b7ad4cb3994190884655133755.jpg"]
/// group_id : "1"
/// user_id : "1"
/// like_status : "0"
/// end_date : ""
/// start_date : ""
/// post_type : "Normal Post"
/// date : "28/03/2023"
/// username : ""
/// email : " karanstomar@icloud.com"
/// f_name : " Karan Tomar"
/// l_name : ""
/// countrycode : ""
/// mobile : " 8770496665"
/// dob : "1998-01-02"
/// gender : "Male"
/// profession : ""
/// exp_job_title : ""
/// exp_employer : ""
/// exp_country : ""
/// exp_start_date : ""
/// exp_end_date : ""
/// exp_current_work : ""
/// exp_description : ""
/// edu_school_name : ""
/// edu_degree : ""
/// edu_field : ""
/// edu_start_date : ""
/// edu_end_date : ""
/// edu_percentage : ""
/// edu_current_study : ""
/// skills_des : ""
/// summary_des : ""
/// accomplishments_des : ""
/// finalize_des : ""
/// password : ""
/// profile_pic : "https://developmentalphawizz.com/social_media/uploads/1680000264scaled_ee5311fc-f9c7-48fc-92cf-eb48e5fb3c3f8713016494170766358.jpg"
/// facebook_id : ""
/// type : ""
/// isGold : "0"
/// address : ""
/// city : ""
/// country : ""
/// device_token : ""
/// agreecheck : "0"
/// otp : "4390"
/// status : "1"
/// wallet : "0.00"
/// oauth_provider : null
/// oauth_uid : null
/// last_login : null
/// created_at : "2023-03-27 12:36:02"
/// updated_at : "2023-03-28 10:44:24"
/// refferal_code : ""
/// friend_code : ""
/// about_us : " this is my intro"

class MyPosts {
  MyPosts({
      String? id, 
      String? name, 
      String? description, 
      List<String>? img, 
      String? groupId, 
      String? userId, 
      String? likeStatus, 
      String? endDate, 
      String? startDate, 
      String? postType, 
      String? date, 
      String? username, 
      String? email, 
      String? fName, 
      String? lName, 
      String? countrycode, 
      String? mobile, 
      String? dob, 
      String? gender, 
      String? profession, 
      String? expJobTitle, 
      String? expEmployer, 
      String? expCountry, 
      String? expStartDate, 
      String? expEndDate, 
      String? expCurrentWork, 
      String? expDescription, 
      String? eduSchoolName, 
      String? eduDegree, 
      String? eduField, 
      String? eduStartDate, 
      String? eduEndDate, 
      String? eduPercentage, 
      String? eduCurrentStudy, 
      String? skillsDes, 
      String? summaryDes, 
      String? accomplishmentsDes, 
      String? finalizeDes, 
      String? password, 
      String? profilePic, 
      String? facebookId, 
      String? type, 
      String? isGold, 
      String? address, 
      String? city, 
      String? country, 
      String? deviceToken, 
      String? agreecheck, 
      String? otp, 
      String? status, 
      String? wallet, 
      dynamic oauthProvider, 
      dynamic oauthUid, 
      dynamic lastLogin, 
      String? createdAt, 
      String? updatedAt, 
      String? refferalCode, 
      String? friendCode, 
      String? aboutUs,}){
    _id = id;
    _name = name;
    _description = description;
    _img = img;
    _groupId = groupId;
    _userId = userId;
    _likeStatus = likeStatus;
    _endDate = endDate;
    _startDate = startDate;
    _postType = postType;
    _date = date;
    _username = username;
    _email = email;
    _fName = fName;
    _lName = lName;
    _countrycode = countrycode;
    _mobile = mobile;
    _dob = dob;
    _gender = gender;
    _profession = profession;
    _expJobTitle = expJobTitle;
    _expEmployer = expEmployer;
    _expCountry = expCountry;
    _expStartDate = expStartDate;
    _expEndDate = expEndDate;
    _expCurrentWork = expCurrentWork;
    _expDescription = expDescription;
    _eduSchoolName = eduSchoolName;
    _eduDegree = eduDegree;
    _eduField = eduField;
    _eduStartDate = eduStartDate;
    _eduEndDate = eduEndDate;
    _eduPercentage = eduPercentage;
    _eduCurrentStudy = eduCurrentStudy;
    _skillsDes = skillsDes;
    _summaryDes = summaryDes;
    _accomplishmentsDes = accomplishmentsDes;
    _finalizeDes = finalizeDes;
    _password = password;
    _profilePic = profilePic;
    _facebookId = facebookId;
    _type = type;
    _isGold = isGold;
    _address = address;
    _city = city;
    _country = country;
    _deviceToken = deviceToken;
    _agreecheck = agreecheck;
    _otp = otp;
    _status = status;
    _wallet = wallet;
    _oauthProvider = oauthProvider;
    _oauthUid = oauthUid;
    _lastLogin = lastLogin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _refferalCode = refferalCode;
    _friendCode = friendCode;
    _aboutUs = aboutUs;
}

  MyPosts.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _img = json['img'] != null ? json['img'].cast<String>() : [];
    _groupId = json['group_id'];
    _userId = json['user_id'];
    _likeStatus = json['like_status'];
    _endDate = json['end_date'];
    _startDate = json['start_date'];
    _postType = json['post_type'];
    _date = json['date'];
    _username = json['username'];
    _email = json['email'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _countrycode = json['countrycode'];
    _mobile = json['mobile'];
    _dob = json['dob'];
    _gender = json['gender'];
    _profession = json['profession'];
    _expJobTitle = json['exp_job_title'];
    _expEmployer = json['exp_employer'];
    _expCountry = json['exp_country'];
    _expStartDate = json['exp_start_date'];
    _expEndDate = json['exp_end_date'];
    _expCurrentWork = json['exp_current_work'];
    _expDescription = json['exp_description'];
    _eduSchoolName = json['edu_school_name'];
    _eduDegree = json['edu_degree'];
    _eduField = json['edu_field'];
    _eduStartDate = json['edu_start_date'];
    _eduEndDate = json['edu_end_date'];
    _eduPercentage = json['edu_percentage'];
    _eduCurrentStudy = json['edu_current_study'];
    _skillsDes = json['skills_des'];
    _summaryDes = json['summary_des'];
    _accomplishmentsDes = json['accomplishments_des'];
    _finalizeDes = json['finalize_des'];
    _password = json['password'];
    _profilePic = json['profile_pic'];
    _facebookId = json['facebook_id'];
    _type = json['type'];
    _isGold = json['isGold'];
    _address = json['address'];
    _city = json['city'];
    _country = json['country'];
    _deviceToken = json['device_token'];
    _agreecheck = json['agreecheck'];
    _otp = json['otp'];
    _status = json['status'];
    _wallet = json['wallet'];
    _oauthProvider = json['oauth_provider'];
    _oauthUid = json['oauth_uid'];
    _lastLogin = json['last_login'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _refferalCode = json['refferal_code'];
    _friendCode = json['friend_code'];
    _aboutUs = json['about_us'];
  }
  String? _id;
  String? _name;
  String? _description;
  List<String>? _img;
  String? _groupId;
  String? _userId;
  String? _likeStatus;
  String? _endDate;
  String? _startDate;
  String? _postType;
  String? _date;
  String? _username;
  String? _email;
  String? _fName;
  String? _lName;
  String? _countrycode;
  String? _mobile;
  String? _dob;
  String? _gender;
  String? _profession;
  String? _expJobTitle;
  String? _expEmployer;
  String? _expCountry;
  String? _expStartDate;
  String? _expEndDate;
  String? _expCurrentWork;
  String? _expDescription;
  String? _eduSchoolName;
  String? _eduDegree;
  String? _eduField;
  String? _eduStartDate;
  String? _eduEndDate;
  String? _eduPercentage;
  String? _eduCurrentStudy;
  String? _skillsDes;
  String? _summaryDes;
  String? _accomplishmentsDes;
  String? _finalizeDes;
  String? _password;
  String? _profilePic;
  String? _facebookId;
  String? _type;
  String? _isGold;
  String? _address;
  String? _city;
  String? _country;
  String? _deviceToken;
  String? _agreecheck;
  String? _otp;
  String? _status;
  String? _wallet;
  dynamic _oauthProvider;
  dynamic _oauthUid;
  dynamic _lastLogin;
  String? _createdAt;
  String? _updatedAt;
  String? _refferalCode;
  String? _friendCode;
  String? _aboutUs;
MyPosts copyWith({  String? id,
  String? name,
  String? description,
  List<String>? img,
  String? groupId,
  String? userId,
  String? likeStatus,
  String? endDate,
  String? startDate,
  String? postType,
  String? date,
  String? username,
  String? email,
  String? fName,
  String? lName,
  String? countrycode,
  String? mobile,
  String? dob,
  String? gender,
  String? profession,
  String? expJobTitle,
  String? expEmployer,
  String? expCountry,
  String? expStartDate,
  String? expEndDate,
  String? expCurrentWork,
  String? expDescription,
  String? eduSchoolName,
  String? eduDegree,
  String? eduField,
  String? eduStartDate,
  String? eduEndDate,
  String? eduPercentage,
  String? eduCurrentStudy,
  String? skillsDes,
  String? summaryDes,
  String? accomplishmentsDes,
  String? finalizeDes,
  String? password,
  String? profilePic,
  String? facebookId,
  String? type,
  String? isGold,
  String? address,
  String? city,
  String? country,
  String? deviceToken,
  String? agreecheck,
  String? otp,
  String? status,
  String? wallet,
  dynamic oauthProvider,
  dynamic oauthUid,
  dynamic lastLogin,
  String? createdAt,
  String? updatedAt,
  String? refferalCode,
  String? friendCode,
  String? aboutUs,
}) => MyPosts(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  img: img ?? _img,
  groupId: groupId ?? _groupId,
  userId: userId ?? _userId,
  likeStatus: likeStatus ?? _likeStatus,
  endDate: endDate ?? _endDate,
  startDate: startDate ?? _startDate,
  postType: postType ?? _postType,
  date: date ?? _date,
  username: username ?? _username,
  email: email ?? _email,
  fName: fName ?? _fName,
  lName: lName ?? _lName,
  countrycode: countrycode ?? _countrycode,
  mobile: mobile ?? _mobile,
  dob: dob ?? _dob,
  gender: gender ?? _gender,
  profession: profession ?? _profession,
  expJobTitle: expJobTitle ?? _expJobTitle,
  expEmployer: expEmployer ?? _expEmployer,
  expCountry: expCountry ?? _expCountry,
  expStartDate: expStartDate ?? _expStartDate,
  expEndDate: expEndDate ?? _expEndDate,
  expCurrentWork: expCurrentWork ?? _expCurrentWork,
  expDescription: expDescription ?? _expDescription,
  eduSchoolName: eduSchoolName ?? _eduSchoolName,
  eduDegree: eduDegree ?? _eduDegree,
  eduField: eduField ?? _eduField,
  eduStartDate: eduStartDate ?? _eduStartDate,
  eduEndDate: eduEndDate ?? _eduEndDate,
  eduPercentage: eduPercentage ?? _eduPercentage,
  eduCurrentStudy: eduCurrentStudy ?? _eduCurrentStudy,
  skillsDes: skillsDes ?? _skillsDes,
  summaryDes: summaryDes ?? _summaryDes,
  accomplishmentsDes: accomplishmentsDes ?? _accomplishmentsDes,
  finalizeDes: finalizeDes ?? _finalizeDes,
  password: password ?? _password,
  profilePic: profilePic ?? _profilePic,
  facebookId: facebookId ?? _facebookId,
  type: type ?? _type,
  isGold: isGold ?? _isGold,
  address: address ?? _address,
  city: city ?? _city,
  country: country ?? _country,
  deviceToken: deviceToken ?? _deviceToken,
  agreecheck: agreecheck ?? _agreecheck,
  otp: otp ?? _otp,
  status: status ?? _status,
  wallet: wallet ?? _wallet,
  oauthProvider: oauthProvider ?? _oauthProvider,
  oauthUid: oauthUid ?? _oauthUid,
  lastLogin: lastLogin ?? _lastLogin,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  refferalCode: refferalCode ?? _refferalCode,
  friendCode: friendCode ?? _friendCode,
  aboutUs: aboutUs ?? _aboutUs,
);
  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  List<String>? get img => _img;
  String? get groupId => _groupId;
  String? get userId => _userId;
  String? get likeStatus => _likeStatus;
  String? get endDate => _endDate;
  String? get startDate => _startDate;
  String? get postType => _postType;
  String? get date => _date;
  String? get username => _username;
  String? get email => _email;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get countrycode => _countrycode;
  String? get mobile => _mobile;
  String? get dob => _dob;
  String? get gender => _gender;
  String? get profession => _profession;
  String? get expJobTitle => _expJobTitle;
  String? get expEmployer => _expEmployer;
  String? get expCountry => _expCountry;
  String? get expStartDate => _expStartDate;
  String? get expEndDate => _expEndDate;
  String? get expCurrentWork => _expCurrentWork;
  String? get expDescription => _expDescription;
  String? get eduSchoolName => _eduSchoolName;
  String? get eduDegree => _eduDegree;
  String? get eduField => _eduField;
  String? get eduStartDate => _eduStartDate;
  String? get eduEndDate => _eduEndDate;
  String? get eduPercentage => _eduPercentage;
  String? get eduCurrentStudy => _eduCurrentStudy;
  String? get skillsDes => _skillsDes;
  String? get summaryDes => _summaryDes;
  String? get accomplishmentsDes => _accomplishmentsDes;
  String? get finalizeDes => _finalizeDes;
  String? get password => _password;
  String? get profilePic => _profilePic;
  String? get facebookId => _facebookId;
  String? get type => _type;
  String? get isGold => _isGold;
  String? get address => _address;
  String? get city => _city;
  String? get country => _country;
  String? get deviceToken => _deviceToken;
  String? get agreecheck => _agreecheck;
  String? get otp => _otp;
  String? get status => _status;
  String? get wallet => _wallet;
  dynamic get oauthProvider => _oauthProvider;
  dynamic get oauthUid => _oauthUid;
  dynamic get lastLogin => _lastLogin;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get refferalCode => _refferalCode;
  String? get friendCode => _friendCode;
  String? get aboutUs => _aboutUs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['img'] = _img;
    map['group_id'] = _groupId;
    map['user_id'] = _userId;
    map['like_status'] = _likeStatus;
    map['end_date'] = _endDate;
    map['start_date'] = _startDate;
    map['post_type'] = _postType;
    map['date'] = _date;
    map['username'] = _username;
    map['email'] = _email;
    map['f_name'] = _fName;
    map['l_name'] = _lName;
    map['countrycode'] = _countrycode;
    map['mobile'] = _mobile;
    map['dob'] = _dob;
    map['gender'] = _gender;
    map['profession'] = _profession;
    map['exp_job_title'] = _expJobTitle;
    map['exp_employer'] = _expEmployer;
    map['exp_country'] = _expCountry;
    map['exp_start_date'] = _expStartDate;
    map['exp_end_date'] = _expEndDate;
    map['exp_current_work'] = _expCurrentWork;
    map['exp_description'] = _expDescription;
    map['edu_school_name'] = _eduSchoolName;
    map['edu_degree'] = _eduDegree;
    map['edu_field'] = _eduField;
    map['edu_start_date'] = _eduStartDate;
    map['edu_end_date'] = _eduEndDate;
    map['edu_percentage'] = _eduPercentage;
    map['edu_current_study'] = _eduCurrentStudy;
    map['skills_des'] = _skillsDes;
    map['summary_des'] = _summaryDes;
    map['accomplishments_des'] = _accomplishmentsDes;
    map['finalize_des'] = _finalizeDes;
    map['password'] = _password;
    map['profile_pic'] = _profilePic;
    map['facebook_id'] = _facebookId;
    map['type'] = _type;
    map['isGold'] = _isGold;
    map['address'] = _address;
    map['city'] = _city;
    map['country'] = _country;
    map['device_token'] = _deviceToken;
    map['agreecheck'] = _agreecheck;
    map['otp'] = _otp;
    map['status'] = _status;
    map['wallet'] = _wallet;
    map['oauth_provider'] = _oauthProvider;
    map['oauth_uid'] = _oauthUid;
    map['last_login'] = _lastLogin;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['refferal_code'] = _refferalCode;
    map['friend_code'] = _friendCode;
    map['about_us'] = _aboutUs;
    return map;
  }

}