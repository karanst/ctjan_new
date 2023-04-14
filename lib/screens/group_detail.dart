import 'dart:async';
import 'dart:convert';

import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/models/group_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:ctjan/screens/bottom_bar.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/posts_model.dart';
import '../utils/global_variables.dart';
import '../widgets/post_card.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupList? data;
  const GroupDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    callApi();
    getProfileData();
  }
  bool loadingData = false;
  String? userid;
  String? groupData;
  bool loading = false;

  joinGroup(String groupId)async{
    setState(() {
      loadingData = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.joinGroup));
    request.fields.addAll({
      'user_id': userid.toString(),
      'group_id': groupId.toString()
      // 'seeker_email': '$userid'
    });
    print("this is group join request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['response_code'] == "1") {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const BottomBar()));
        showSnackbar("${jsonResponse['message']}", context);
      }else{
        showSnackbar("${jsonResponse['message']}", context);
        setState(() {
          loadingData = false;
        });
      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  callApi()async{
    getProfileData();
    Future.delayed(Duration(seconds: 1), (){
      getGroupList();
    });
    Future.delayed(Duration(seconds: 1), (){
      loadPosts();
    });
  }
  String? grpId;
  String? grpName;
  // String? userid;
  GetProfileModel? getuserdata;

  getProfileData()async{
    // setState(() {
    //   loadingData = true;
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getUserProfile));
    request.fields.addAll({
      'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    print("This is user name...................${userName}");
    print("This is user myname...................${getuserdata?.userId?.username}");
    print("This is user name...................${userName}");
    print("this is profile request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          getuserdata = jsonResponse;
          grpId = jsonResponse.userId!.groupId.toString();
          // userName = jsonResponse.userId!.username.toString();
          // email = jsonResponse.userId!.email.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
      }else{
        // setState(() {
        //   loadingData = false;
        // });
      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  List<PostList> postList = [];
  final StreamController<List<PostList>> _streamController = StreamController<List<PostList>>();

  Future<List<PostList>?> getFeedData()async{
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getGroupPosts));
    request.fields.addAll({
      'group_id': widget.data!.id.toString(),
      'post_type': selectIndex.toString()
    });
    print("this is feed request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = PostsModel.fromJson(json.decode(finalResponse));
    if (response.statusCode == 200) {
      if(jsonResponse.responseCode == "1") {
        postList = jsonResponse.data! ;
        grpName = jsonResponse.data![0].groupName.toString();
        print("this is posts list ${postList.toString()}");
      }else{
      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
    return PostsModel.fromJson(json.decode(finalResponse)).data;
  }
  loadPosts() async {
    getFeedData().then((res) async {
      _streamController.add(res!);
      return res;
    });
  }

  List<GroupList> list = [];
  int selectIndex = 1;

  getGroupList()async{
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('GET', Uri.parse(ApiPath.groupList));
    request.fields.addAll({
      // 'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GroupListModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          list = jsonResponse.data!;
        });
        print("this is group list length ${list.length}");
      }else{

      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future _refresh() async {
    return callApi();
  }
  String? userPic;
  String? userName;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: primaryClr,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: primaryClr,
              title: Text(widget.data!.name.toString()),
            ),
            bottomSheet:  GestureDetector(
              onTap: (){
                setState(() {
                  loading = false;
                });
                String groupId = widget.data!.id.toString();
                print("this is group ids ${groupData.toString()} aand ${groupId}");
                if(groupData != groupId) {
                  joinGroup(groupId);
                }else{
                  showSnackbar("Already joined an group!", context);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                alignment: Alignment.center,
                //padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(color: groupData != widget.data!.id.toString() ? Colors.transparent : primaryClr),
                    color: groupData != widget.data!.id.toString() ? primaryClr : whiteColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: loading ? Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: whiteColor,
                    ),
                  ),
                ):  Text(
                  groupData != widget.data!.id.toString() ?
                  "Join Group"
                      : "Joined", style:  TextStyle(
                    color: groupData != widget.data!.id.toString() ? Colors.white : primaryClr,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),),

              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 1;
                              });
                              loadPosts();
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryClr),
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectIndex == 1 ? primaryClr : Colors.white),
                              child:  Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                      "Post",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selectIndex == 1 ? whiteColor : primaryClr,
                                        fontWeight: selectIndex == 1 ?  FontWeight.w600 : FontWeight.w500,),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 2;
                              });
                              loadPosts();
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryClr),
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectIndex == 2 ? primaryClr : Colors.white),
                              child:  Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                      "Event",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selectIndex == 2 ? whiteColor : primaryClr,
                                        fontWeight: selectIndex == 2 ?  FontWeight.w600 : FontWeight.w500,),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 3;
                              });
                              loadPosts();
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryClr),
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectIndex == 3 ? primaryClr : Colors.white),
                              child:  Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                      "Public Issue",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: selectIndex == 3 ?  FontWeight.w600 : FontWeight.w500,
                                          color: selectIndex == 3 ? whiteColor : primaryClr),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<List<PostList>>(
                    stream: _streamController.stream,
                    builder: (context, AsyncSnapshot<List<PostList>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                              child: Text("No Posts found!", style: TextStyle(color: primaryColor),)

                          ),
                        );
                      }
                      return snapshot.data!.isNotEmpty ?
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) =>
                        snapshot.connectionState == ConnectionState.active &&
                            snapshot.hasData
                            ? Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width >= webScreenSize ? width * 0.3 : 0,
                            vertical: width >= webScreenSize ? 15 : 0,
                          ),
                          child: PostCard(
                            data: snapshot.data![index],
                          ),
                        )
                            : Container(),
                      )
                          : const Center(
                        child: Text('No Posts found!', style: TextStyle(
                            color: primaryColor
                        ),),
                      );
                    },
                  ),
                  // const Padding(
                  //   padding:  EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
                  //   child:  Text("Groups", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                  // ),
                  // list.isNotEmpty ?
                  // Card(
                  //   color: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20)
                  //   ),
                  //   elevation: 5,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: Column(
                  //       children: [
                  //         ListView.builder(
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           itemCount: list.length,
                  //             itemBuilder: (context, index){
                  //           return GroupCard(
                  //             data: list[index],
                  //           );
                  //         }),
                  //       ],
                  //     ),
                  //   ),
                  // )
                  //  : Center(child: CircularProgressIndicator(
                  //   color: primaryClr,
                  // )),
                ],
              ),
            )

          // : const Center(
          //   child: Text("No Groups found!", style: TextStyle(
          //     color: primaryColor
          //   ),),
          // ),
        )
    );
  }
}


//
//   bool loadingData = false;
//   String? userid;
//   String? groupData;
//   bool loading = false;
//
//   joinGroup(String groupId)async{
//     setState(() {
//       loadingData = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString(TokenString.userid);
//     var headers = {
//       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse(ApiPath.joinGroup));
//     request.fields.addAll({
//       'user_id': userid.toString(),
//       'group_id': groupId.toString()
//       // 'seeker_email': '$userid'
//     });
//     print("this is group join request ${request.fields.toString()}");
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResponse = await response.stream.bytesToString();
//       final jsonResponse = json.decode(finalResponse);
//       if(jsonResponse['response_code'] == "1") {
//         Navigator.push(context, MaterialPageRoute(builder: (context)=> const BottomBar()));
//         showSnackbar("${jsonResponse['message']}", context);
//       }else{
//         showSnackbar("${jsonResponse['message']}", context);
//         setState(() {
//           loadingData = false;
//         });
//       }
//       // print("select qualification here ${selectedQualification}");
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   getProfileData()async{
//     setState(() {
//       loadingData = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString(TokenString.userid);
//     var headers = {
//       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getUserProfile));
//     request.fields.addAll({
//       'user_id': userid.toString()
//       // 'seeker_email': '$userid'
//     });
//     print("this is profile request ${request.fields.toString()}");
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResponse = await response.stream.bytesToString();
//       final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
//       if(jsonResponse.responseCode == "1") {
//
//         setState(() {
//           groupData = jsonResponse.userId!.groupId.toString();
//           // loadingData = false;
//           // profileImage = jsonResponse.userId!.profilePic.toString();
//           // userName = jsonResponse.userId!.username.toString();
//           // email = jsonResponse.userId!.email.toString();
//           // seekerProfileModel = jsonResponse;
//           // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
//           // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
//           // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
//           // profileImage = '${seekerProfileModel!.data![0].image}';
//         });
//         print("this is group status $groupData");
//       }else{
//         setState(() {
//           loadingData = false;
//         });
//       }
//       // print("select qualification here ${selectedQualification}");
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getProfileData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: primaryClr,
//         title: Text(widget.data!.name.toString()),
//       ),
//       bottomSheet:  GestureDetector(
//         onTap: (){
//           setState(() {
//             loading = false;
//           });
//           String groupId = widget.data!.id.toString();
//           print("this is group ids ${groupData.toString()} aand ${groupId}");
//           if(groupData != groupId) {
//             joinGroup(groupId);
//           }else{
//             showSnackbar("Already joined an group!", context);
//           }
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: 55,
//           alignment: Alignment.center,
//           //padding: EdgeInsets.all(6),
//           decoration: BoxDecoration(
//               border: Border.all(color: groupData != widget.data!.id.toString() ? Colors.transparent : primaryClr),
//               color: groupData != widget.data!.id.toString() ? primaryClr : whiteColor,
//               borderRadius: BorderRadius.circular(10)
//           ),
//           child: loading ? Center(
//             child: Container(
//               height: 30,
//               width: 30,
//               child: CircularProgressIndicator(
//                 color: whiteColor,
//               ),
//             ),
//           ):  Text(
//             groupData != widget.data!.id.toString() ?
//             "Join Group"
//                 : "Joined", style:  TextStyle(
//               color: groupData != widget.data!.id.toString() ? Colors.white : primaryClr,
//               fontSize: 16,
//               fontWeight: FontWeight.w600
//           ),),
//
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // SizedBox(
//           //   height: MediaQuery.of(context).size.height * 0.35,
//           //   width: double.infinity,
//           //   child: widget.data!.image!.isEmpty || widget.data!.image!.toString() == imageUrl
//           //       ? Image.asset(
//           //     'assets/placeholder.png',
//           //     // widget.snap['postUrl'],
//           //     fit: BoxFit.cover,
//           //   )
//           //       : Image.network(
//           //     widget.data!.image!.toString(),
//           //     // widget.snap['postUrl'],
//           //     fit: BoxFit.cover,
//           //   ),
//           // ),
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15.0, right: 15),
//           //   child: Text(widget.data!.title.toString(), style: const TextStyle(
//           //     color: primaryColor,
//           //     fontSize: 18,
//           //     fontWeight: FontWeight.w600
//           //   ),),
//           // ),
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15.0, right: 15),
//           //   child: Text(widget.data!.description.toString(), style: const TextStyle(
//           //       color: primaryColor,
//           //       fontSize: 14,
//           //       fontWeight: FontWeight.w500
//           //   ),),
//           // ),
//           // Container(
//           //   padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 10),
//           //   child: Row(
//           //     children: [
//           //       Text("Joined users : ",
//           //         style:  TextStyle(
//           //           fontSize: 14,
//           //           fontWeight: FontWeight.w600,
//           //           color: secondaryClr,
//           //         ),
//           //       ),
//           //       Text( widget.data!.totalUser.toString(), style: TextStyle(
//           //           color: secondaryClr,
//           //           fontSize: 14
//           //       ),)
//           //
//           //     ],
//           //   ),
//           // ),
//           // Container(
//           //   padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
//           //   child: Row(
//           //     children: [
//           //       Text("Zipcodes : ",
//           //         style:  TextStyle(
//           //           fontSize: 14,
//           //           color: secondaryClr,
//           //           fontWeight: FontWeight.w600,
//           //         ),
//           //       ),
//           //       Text( widget.data!.pincode.toString(), style: TextStyle(
//           //           color: secondaryClr,
//           //           fontSize: 14
//           //       ),),
//           //     ],
//           //   ),
//           // ),
//
//         ],
//       ),
//     );
//   }
// }

