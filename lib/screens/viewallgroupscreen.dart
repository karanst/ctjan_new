
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:ctjan/Helper/token_strings.dart';
// import 'package:ctjan/models/get_profile_model.dart';
// import 'package:ctjan/models/posts_model.dart';
// import 'package:ctjan/screens/group_screen.dart';
// import 'package:ctjan/screens/search_screen.dart';
// import 'package:ctjan/screens/wishlist.dart';
// import 'package:ctjan/utils/global_variables.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:ctjan/Helper/api_path.dart';
// import 'package:ctjan/models/group_list_model.dart';
// import 'package:ctjan/utils/colors.dart';
// import 'package:ctjan/widgets/group_card.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewAllgroup extends StatefulWidget {
//   final String? groupJoined;
//   const ViewAllgroup({Key? key, this.groupJoined}) : super(key: key);
//
//   @override
//   State<ChangeGroupScreen> createState() => _ChangeGroupScreenState();
// }
//
// class _ChangeGroupScreenState extends State<ChangeGroupScreen> {
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//   GlobalKey<RefreshIndicatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     callApi();
//
//     // if(widget.groupJoined == "1"){
//     //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
//     // }
//   }
//
//   callApi() async {
//     getProfileData();
//     Future.delayed(Duration(seconds: 1), () {
//       getGroupList();
//     });
//     // Future.delayed(Duration(seconds: 1), (){
//     //   loadPosts();
//     // });
//   }
//
//   String? grpId;
//   String? userid;
//   getProfileData() async {
//     // setState(() {
//     //   loadingData = true;
//     // });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString(TokenString.userid);
//     var headers = {
//       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
//     };
//     var request =
//     http.MultipartRequest('POST', Uri.parse(ApiPath.getUserProfile));
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
//       if (jsonResponse.responseCode == "1") {
//         setState(() {
//           grpId = jsonResponse.userId!.groupId.toString();
//           // userName = jsonResponse.userId!.username.toString();
//           // email = jsonResponse.userId!.email.toString();
//           // seekerProfileModel = jsonResponse;
//           // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
//           // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
//           // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
//           // profileImage = '${seekerProfileModel!.data![0].image}';
//         });
//       } else {
//         // setState(() {
//         //   loadingData = false;
//         // });
//       }
//       // print("select qualification here ${selectedQualification}");
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   List<PostList> postList = [];
//   StreamController<List<PostList>> _streamController =
//   StreamController<List<PostList>>();
//
//   Future<List<PostList>?> getFeedData() async {
//     var headers = {
//       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
//     };
//     var request =
//     http.MultipartRequest('POST', Uri.parse(ApiPath.getGroupPosts));
//     request.fields.addAll({'group_id': grpId.toString()});
//
//     print("this is feed request ${request.fields.toString()}");
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     var finalResponse = await response.stream.bytesToString();
//     final jsonResponse = PostsModel.fromJson(json.decode(finalResponse));
//     if (response.statusCode == 200) {
//       if (jsonResponse.responseCode == "1") {
//         postList = jsonResponse.data!;
//         print("this is posts list ${postList.toString()}");
//       } else {}
//       // print("select qualification here ${selectedQualification}");
//     } else {
//       print(response.reasonPhrase);
//     }
//     return PostsModel.fromJson(json.decode(finalResponse)).data;
//   }
//
//   // loadPosts() async {
//   //   getFeedData().then((res) async {
//   //     _streamController.add(res!);
//   //     return res;
//   //   });
//   // }
//
//   List<GroupList> list = [];
//
//   getGroupList() async {
//     var headers = {
//       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
//     };
//     var request = http.MultipartRequest('GET', Uri.parse(ApiPath.groupList));
//     request.fields.addAll({
//       // 'user_id': userid.toString()
//       // 'seeker_email': '$userid'
//     });
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResponse = await response.stream.bytesToString();
//       final jsonResponse = GroupListModel.fromJson(json.decode(finalResponse));
//       if (jsonResponse.responseCode == "1") {
//         setState(() {
//           list = jsonResponse.data!;
//         });
//         print("this is group list length ${list.length}");
//       } else {}
//       // print("select qualification here ${selectedQualification}");
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   Future _refresh() async {
//     return callApi();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return RefreshIndicator(
//         color: primaryClr,
//         key: _refreshIndicatorKey,
//         onRefresh: _refresh,
//         child: Scaffold(
//             appBar: AppBar(
//                 leading: Icon(
//                   Icons.arrow_back_ios,
//                   color: primaryClr,
//                 ),
//                 backgroundColor: primaryClr,
//                 centerTitle: true,
//                 title: Text(
//                   "Places",
//                   style: TextStyle(color: mobileBackgroundColor),
//                 ),
//                 actions: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SearchScreen()));
//                       },
//                       icon: Icon(
//                         Icons.search_outlined,
//                         color: whiteColor,
//                       )),
//                 ]
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // StreamBuilder<List<PostList>>(
//                   //   stream: _streamController.stream,
//                   //   builder: (context, AsyncSnapshot<List<PostList>> snapshot) {
//                   //     if (snapshot.connectionState == ConnectionState.waiting) {
//                   //       return Container(
//                   //         height: MediaQuery.of(context).size.height * 0.5,
//                   //         child: const Center(
//                   //             child: Text("No Posts found!", style: TextStyle(color: primaryColor),)
//                   //           // CircularProgressIndicator(
//                   //           //   color: primaryColor,
//                   //           // ),
//                   //         ),
//                   //       );
//                   //     }
//                   //     return snapshot.data!.isNotEmpty ?
//                   //     ListView.builder(
//                   //       physics: const NeverScrollableScrollPhysics(),
//                   //       shrinkWrap: true,
//                   //       itemCount: snapshot.data!.length,
//                   //       itemBuilder: (context, index) =>
//                   //       snapshot.connectionState == ConnectionState.active &&
//                   //           snapshot.hasData
//                   //           ? Container(
//                   //         margin: EdgeInsets.symmetric(
//                   //           horizontal: width >= webScreenSize ? width * 0.3 : 0,
//                   //           vertical: width >= webScreenSize ? 15 : 0,
//                   //         ),
//                   //         child: PostCard(
//                   //           data: snapshot.data![index],
//                   //         ),
//                   //       )
//                   //           : Container(),
//                   //     )
//                   //         : const Center(
//                   //       child: Text('No Posts found!', style: TextStyle(
//                   //           color: primaryColor
//                   //       ),),
//                   //     );
//                   //   },
//                   // ),
//                   //
//                   // const Padding(
//                   //   padding:  EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
//                   //   child:  Text("Groups", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
//                   // ),
//                   list.isNotEmpty
//                       ? Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     elevation: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         children: [
//                           ListView.builder(
//                               physics:
//                               const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: list.length,
//                               itemBuilder: (context, index) {
//                                 return
//                                   // grpId == list[index].id ?
//                                   GroupCard(
//                                     isButtonVisible: true,
//                                     data: list[index],
//                                   )
//                                       // : SizedBox.shrink()
//                                 ;
//                               }),
//
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: ElevatedButton(
//                               onPressed: (){
//                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
//                               }, child:   Text("Change Group", style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14
//                             ),),
//                               style: ElevatedButton.styleFrom(
//                                   primary: primaryClr,
//                                   shape:  RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15)
//                                   ),
//                                   fixedSize: Size(MediaQuery.of(context).size.width , 50)
//                               ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                       : Center(
//                       child: CircularProgressIndicator(
//                         color: primaryClr,
//                       )),
//                 ],
//               ),
//             )
//
//           // : const Center(
//           //   child: Text("No Groups found!", style: TextStyle(
//           //     color: primaryColor
//           //   ),),
//           // ),
//         ));
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:ctjan/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/api_path.dart';
import '../Helper/token_strings.dart';
import '../models/get_profile_model.dart';
import '../models/group_list_model.dart';
import '../models/posts_model.dart';
import '../utils/colors.dart';
import 'package:http/http.dart'as http;

import '../widgets/group_card.dart';
class ViewallGroup extends StatefulWidget {
  final String? groupJoined;
  const ViewallGroup({Key? key, this.groupJoined}) : super(key: key);

  @override
  State<ViewallGroup> createState() => _ViewallGroupState();
}

class _ViewallGroupState extends State<ViewallGroup> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    callApi();
    // if(widget.groupJoined == "1"){
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
    // }
  }
  callApi() async {
    getProfileData();
    Future.delayed(Duration(seconds: 1), () {
      getGroupList();
    });
    // Future.delayed(Duration(seconds: 1), (){
    //   loadPosts();
    // });
  }

  String? grpId;
  String? userid;
  getProfileData() async {
    // setState(() {
    //   loadingData = true;
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiPath.getUserProfile));
    request.fields.addAll({
      'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    print("this is profile request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      if (jsonResponse.responseCode == "1") {
        setState(() {
          grpId = jsonResponse.userId!.groupId.toString();
          // userName = jsonResponse.userId!.username.toString();
          // email = jsonResponse.userId!.email.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
      } else {
        // setState(() {
        //   loadingData = false;
        // });
      }
      // print("select qualification here ${selectedQualification}");
    } else {
      print(response.reasonPhrase);
    }
  }
  List<PostList> postList = [];
  StreamController<List<PostList>> _streamController =
  StreamController<List<PostList>>();

  Future<List<PostList>?> getFeedData() async {
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiPath.getGroupPosts));
    request.fields.addAll({'group_id': grpId.toString()});

    print("this is feed request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = PostsModel.fromJson(json.decode(finalResponse));
    if (response.statusCode == 200) {
      if (jsonResponse.responseCode == "1") {
        postList = jsonResponse.data!;
        print("this is posts list ${postList.toString()}");
      } else {}
      // print("select qualification here ${selectedQualification}");
    } else {
      print(response.reasonPhrase);
    }
    return PostsModel.fromJson(json.decode(finalResponse)).data;
  }

  // loadPosts() async {
  //   getFeedData().then((res) async {
  //     _streamController.add(res!);
  //     return res;
  //   });
  // }

  List<GroupList> list = [];

  getGroupList() async {
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
      if (jsonResponse.responseCode == "1") {
        setState(() {
          list = jsonResponse.data!;
        });
        print("this is group list length ${list.length}");
      } else {}
      // print("select qualification here ${selectedQualification}");
    } else {
      print(response.reasonPhrase);
    }
  }

  Future _refresh() async {
    return callApi();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: primaryClr,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scaffold(
            appBar: AppBar(
                leading: Icon(
                  Icons.arrow_back_ios,
                  color: primaryClr,
                ),
                backgroundColor: primaryClr,
                centerTitle: true,
                title: Text(
                  "All Group",
                  style: TextStyle(color: mobileBackgroundColor),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                      icon: Icon(
                        Icons.search_outlined,
                        color: whiteColor,
                      )),
                ]
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // StreamBuilder<List<PostList>>(
                  //   stream: _streamController.stream,
                  //   builder: (context, AsyncSnapshot<List<PostList>> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Container(
                  //         height: MediaQuery.of(context).size.height * 0.5,
                  //         child: const Center(
                  //             child: Text("No Posts found!", style: TextStyle(color: primaryColor),)
                  //           // CircularProgressIndicator(
                  //           //   color: primaryColor,
                  //           // ),
                  //         ),
                  //       );
                  //     }
                  //     return snapshot.data!.isNotEmpty ?
                  //     ListView.builder(
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemCount: snapshot.data!.length,
                  //       itemBuilder: (context, index) =>
                  //       snapshot.connectionState == ConnectionState.active &&
                  //           snapshot.hasData
                  //           ? Container(
                  //         margin: EdgeInsets.symmetric(
                  //           horizontal: width >= webScreenSize ? width * 0.3 : 0,
                  //           vertical: width >= webScreenSize ? 15 : 0,
                  //         ),
                  //         child: PostCard(
                  //           data: snapshot.data![index],
                  //         ),
                  //       )
                  //           : Container(),
                  //     )
                  //         : const Center(
                  //       child: Text('No Posts found!', style: TextStyle(
                  //           color: primaryColor
                  //       ),),
                  //     );
                  //   },
                  // ),
                  //
                  // const Padding(
                  //   padding:  EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
                  //   child:  Text("Groups", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                  // ),
                  list.isNotEmpty
                      ? Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ListView.builder(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return
                                  // grpId == list[index].id ?
                                  GroupCard(
                                    isButtonVisible: false,
                                    data: list[index],
                                  )
                                      // : SizedBox.shrink()
                                ;
                              }),

                          // Padding(
                          //   padding: const EdgeInsets.all(20.0),
                          //   child: ElevatedButton(
                          //     onPressed: (){
                          //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                          //     }, child:   Text("Change Group", style: TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       fontSize: 14
                          //   ),),
                          //     style: ElevatedButton.styleFrom(
                          //         primary: primaryClr,
                          //         shape:  RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(15)
                          //         ),
                          //         fixedSize: Size(MediaQuery.of(context).size.width , 50)
                          //     ),),
                          // )
                        ],
                      ),
                    ),
                  )
                      : Center(
                      child: CircularProgressIndicator(
                        color: primaryClr,
                      )),
                ],
              ),
            )

          // : const Center(
          //   child: Text("No Groups found!", style: TextStyle(
          //     color: primaryColor
          //   ),),
          // ),
        ));
  }

}
