import 'dart:async';
import 'dart:convert';

import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/comments_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/resources/firestore_methods.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/token_strings.dart';
import '../models/User.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final String? postId, groupId;
  // final Comments? data;
  const CommentsScreen({Key? key, this.postId, this.groupId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
    Future.delayed(const Duration(milliseconds: 200), (){
      getComments();
      loadComments();
    });



  }
  // @override
  // void dispose() {
  //   _commentController.dispose();
  //   super.dispose();
  // }
  String? userName;
  String? userid;
  String? userProfile;
  List<Comments>? comments = [];
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
          userProfile = jsonResponse.userId!.profilePic.toString();
          userName = jsonResponse.userId!.username.toString();
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
  StreamController<List<Comments>> _streamController = StreamController<List<Comments>>();

  Future<List<Comments>?> getComments()async{

    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getComments));
    request.fields.addAll({
      'post_id': widget.postId.toString()
    });

    print("this is comments request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = CommentsModel.fromJson(json.decode(finalResponse));
    if (response.statusCode == 200) {
      if(jsonResponse.responseCode == "1") {
        comments = jsonResponse.data!;
        print("this is posts list ${comments.toString()}");
      }else{

      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
    return CommentsModel.fromJson(json.decode(finalResponse)).data;
  }

  sendComment()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiPath.sendComment));

    request.fields.addAll({
      'comment': _commentController.text.toString(),
      'user_id': userid.toString(),
      'post_id':widget.postId!.toString(),
      'group_id': widget.groupId!.toString()
    });

    print("this is send comment request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['response_code'] == '1'){
        setState(() {
          _commentController.clear();
        });
        loadComments();
        // showSnackbar("${jsonResponse['message']}", context);

      }
      else{

      }
    }
    else {
      print(response.reasonPhrase);
    }
  }


  loadComments() async {
    getComments().then((res) async {
      _streamController.add(res!);
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryClr,
        title: const Text('Comments', style: TextStyle(fontSize: 18),),
        centerTitle: false,
      ),
      body: StreamBuilder<List<Comments>>(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<List<Comments>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => CommentCard(
              data: snapshot.data![index]
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: Colors.black54)
          ),
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userProfile.toString(),
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                    child: TextField(
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                      controller: _commentController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Comment as ${userName.toString()}',
                        hintStyle: const TextStyle(
                          color: primaryColor
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap:  () {
                  if(_commentController.text.isNotEmpty) {
                    sendComment();
                  }else{
                    showSnackbar("Please add any comment!", context);
                  }

                  // await FirestoreMethods().postComments(
                  //   widget.snap['postId'],
                  //   _commentController.text,
                  //   user.uid,
                  //   user.username,
                  //   user.photoUrl,
                  // );
                  // setState(() {
                  //   _commentController.text = "";
                  // });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child:  Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
