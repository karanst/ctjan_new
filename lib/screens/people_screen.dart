import 'dart:async';
import 'dart:convert';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/models/people_model.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/screens/people_profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {
  final String? groupJoined;
  const PeopleScreen({Key? key, this.groupJoined}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {

  bool _customTileExpanded = false;


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

  callApi()async{
    getProfileData();
    getFeedData();
    Future.delayed(Duration(seconds: 1), (){
      getGroupList();
    });
    // Future.delayed(Duration(seconds: 1), (){
    //   loadPosts();
    // });
  }

  String? grpId;
  String? userid;
  GetProfileModel? getpeopledata;
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
    print("this is profile request ${request.fields.toString()}");
    print("this is profile request ${getpeopledata?.userId?.aboutUs}");
    print("this is profile request ${getpeopledata?.userId?.username}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      setState(() {
        getpeopledata = jsonResponse;
      });
      if(jsonResponse.responseCode == "1") {
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
  StreamController<List<PostList>> _streamController = StreamController<List<PostList>>();



  PostsModel? getpeoplepost;
  Future<List<PostList>?> getFeedData()async{
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getGroupPosts));
    request.fields.addAll({
      'group_id': grpId.toString()
    });
    print("this is feed request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = PostsModel.fromJson(json.decode(finalResponse));
    setState(() {
      getpeoplepost = jsonResponse;
    });
    print("_____________________${getpeoplepost?.data?.first.aboutUs}");
    if (response.statusCode == 200) {
      if(jsonResponse.responseCode == "1") {
        postList = jsonResponse.data! ;
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


  List<Data> list = [];

  getGroupList()async{
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getJoinedMembers));
    request.fields.addAll({
      'group_id': grpId.toString()
      // 'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = PeopleModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          list = jsonResponse.data!;
        });
        print("this is group list length ${list.length}");
        print("this is group list length ${jsonResponse}");
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: primaryClr,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.arrow_back_ios, color:  primaryClr,),
              backgroundColor: primaryClr,
              centerTitle: true,
              title: Text("People", style: TextStyle(
                  color: mobileBackgroundColor
              ),),
              // actions: [
              //   IconButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const WishlistScreen()));
              // }, icon:
              // Icon(Icons.favorite_outline, color: mobileBackgroundColor,))],
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.add_box_outlined,
              //     ),
              //   ),
              //   IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.send_outlined,
              //     ),
              //   )
              // ],
            ),
            body:
            SingleChildScrollView(
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
                  list.isNotEmpty ?
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index){
                              return InkWell(
                                onTap: (){
                                  // Navigator.push(context, MaterialPageRoute(builder: (c)=>MyStatefulWidget()
                                  //     // PeopleprofileScreen(data: list[index])
                                  // ));
                                },
                                child: ExpansionTile(
                                  title: Card(
                                    color: whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: primaryClr),
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage('$imageUrl${list[index].profilePic.toString()}'),
                                          ),
                                         const SizedBox(width: 12,),
                                         Text('${list[index].fName.toString()}',
                                           style: const TextStyle(
                                           color: primaryColor,
                                           fontWeight: FontWeight.w600
                                         ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(
                                    _customTileExpanded
                                        ? Icons.arrow_drop_down_circle
                                        : Icons.arrow_drop_down,color: primaryClr,
                                  ),
                                  children:  <Widget>[
                                    ListTile(title:
                                    Container(
                                      height :200,
                                      child: Card(
                                        color: whiteColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: Container(
                                          padding:  EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: primaryClr),
                                          //     borderRadius: BorderRadius.circular(15)
                                          // ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage('$imageUrl${list[index].profilePic.toString()}'),
                                              ),
                                              const SizedBox(width: 12,),
                                              Padding(
                                                padding: const EdgeInsets.only(top:15.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('${list[index].fName.toString()}',
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontWeight: FontWeight.w600
                                                      ),),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.1,
                                                      child: Text('${list[index].aboutUs.toString()}',maxLines: 5,
                                                        style: const TextStyle(
                                                            color: primaryColor,
                                                            fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,
                                                        ),),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                  // onExpansionChanged: (bool expanded) {
                                  //   setState(() => _customTileExpanded = expanded);
                                  // },

                                ),
                              );
                            }),
                      ],
                    ),
                  )
                      : Center(child: CircularProgressIndicator(
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
        )
    );
  }

}

