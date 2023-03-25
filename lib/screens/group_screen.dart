import 'dart:async';
import 'dart:convert';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/screens/feed_screen.dart';
import 'package:ctjan/screens/wishlist.dart';
import 'package:ctjan/utils/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/group_list_model.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/widgets/group_card.dart';
import 'package:ctjan/widgets/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupScreen extends StatefulWidget {
  final String? groupJoined;
  const GroupScreen({Key? key, this.groupJoined}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {


  @override
  void initState() {
    super.initState();
    getProfileData();
    Future.delayed(Duration(milliseconds: 200), (){
      getGroupList();
    });
    Future.delayed(Duration(milliseconds: 200), (){
      loadPosts();
    });


    // if(widget.groupJoined == "1"){
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
    // }
  }

  String? grpId;
  String? userid;
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
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
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

  Future<List<PostList>?> getFeedData()async{
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.allPostsUrl));
    request.fields.addAll({
      'group_id': grpId.toString()
    });

    print("this is feed request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = PostsModel.fromJson(json.decode(finalResponse));
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


  List<GroupList> list = [];

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
        print("this is group list length ${list!.length}");
      }else{

      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/applogo.png' ,height: 50, width: 50,),
        //Icon(Icons.arrow_back_ios, color:  primaryClr,),
        backgroundColor: primaryClr,
        centerTitle: false,
        title: Text("CTjan", style: TextStyle(
           color: mobileBackgroundColor
            ),),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const WishlistScreen()));
        }, icon:
        Icon(Icons.favorite_outline, color: mobileBackgroundColor,))],
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
            StreamBuilder<List<PostList>>(
              stream: _streamController.stream,
              builder: (context, AsyncSnapshot<List<PostList>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Text("No Posts found!", style: TextStyle(color: primaryColor),)
                    // CircularProgressIndicator(
                    //   color: primaryColor,
                    // ),
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
            const Padding(
              padding:  EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
              child:  Text("Groups", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
            ),
            list.isNotEmpty ?
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                        itemBuilder: (context, index){
                      return GroupCard(
                        data: list[index],
                      );
                    }),
                  ],
                ),
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
    );
  }
}
