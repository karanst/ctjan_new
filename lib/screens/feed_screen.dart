import 'dart:async';
import 'dart:convert';

import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctjan/models/wishlist_model.dart';
import 'package:ctjan/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/group_list_model.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/global_variables.dart';
import 'package:ctjan/widgets/post_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {


  String? userId;
  String? isGroupJoined;

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString(TokenString.userid);
      isGroupJoined = preferences.getString(TokenString.groupJoined);
    });
    print("this is group join status home ===>>>> ${isGroupJoined.toString()}");
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), (){
      getUserDataFromPrefs();
    });

    getFeedData();
    loadPosts();
    getGroupList();
    // fetchData();
  }


  String? userid;

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

        // setState(() {
        list = jsonResponse.data!;

        print("this is group list length ${list.length}");
        // });

      }else{

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
      'group_id': '5'
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


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width >= webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width >= webScreenSize
          ? null
          : AppBar(
        leading: Icon(Icons.arrow_back_ios, color:  primaryClr,),
              backgroundColor: primaryClr,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/applogo.png' ,height: 50, width: 50,),
                    Text("CTjan", style: TextStyle(
                      color: mobileBackgroundColor
                    ),)
                  ],
                ),
              ),
              actions: [IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> WishlistScreen()));
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
      body:  StreamBuilder<List<PostList>>(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<List<PostList>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return snapshot.data!.isNotEmpty ?
          ListView.builder(
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
    );
  }
}


// class MyList extends StatefulWidget {
//   @override
//   _MyListState createState() => _MyListState();
// }
//
// class _MyListState extends State<MyList> {
//   StreamController<List<String>> _streamController = StreamController<List<String>>();
//
//   Future<List<String>> _getData() async {
//     final response = await http.get(Uri.parse('https://myapi.com/data'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final List<String> dataList = List<String>.from(jsonData['data']);
//       _streamController.add(dataList);
//       return dataList;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My List'),
//       ),
//       body: StreamBuilder<List<String>>(
//         stream: _streamController.stream,
//         builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text(snapshot.data![index]),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _streamController.close();
//     super.dispose();
//   }
// }
