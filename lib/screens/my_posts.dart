import 'dart:async';
import 'dart:convert';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/widgets/myposts_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/myposts_model.dart';

class MyPostScreen extends StatefulWidget {
  final String? grpId;
  const MyPostScreen({Key? key, this.grpId}) : super(key: key);

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {

  List<PostList> postList = [];
  String? userid;
  bool loadingData = false;
  StreamController<List<MyPosts>> _streamController = StreamController<List<MyPosts>>();
  List<MyPosts> posts = [];

  myPosts()async{
    setState(() {
      loadingData = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getMyPost));
    request.fields.addAll({
      'user_id': userid.toString(),
      'group_id': '${widget.grpId}'
    });
    print("this is my posts request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = MypostsModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          posts = jsonResponse.data!.cast<MyPosts>();
        });

        // setState(() {
        //   loadingData = false;
        //   profileImage = jsonResponse.userId!.profilePic.toString();
        //   userName = jsonResponse.userId!.username.toString();
        //   email = jsonResponse.userId!.email.toString();
        // });
      }else{
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

  loadPosts() async {
    myPosts().then((res) async {
      _streamController.add(res!);
      return res;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPosts();
    Future.delayed(Duration(milliseconds: 1000), (){
      loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryClr ,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
          //Icon(Icons.arrow_back_ios, color: whiteColor, size: 22),
        ),
        title:  Text('My Posts', style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<List<MyPosts>>(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<List<MyPosts>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return snapshot.data!.isNotEmpty ?
          ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
            snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData
                ?
            Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: width >= webScreenSize ? width * 0.3 : 0,
              //   vertical: width >= webScreenSize ? 15 : 0,
              // ),
              child: MyPostCard(
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
    );
  }
}
