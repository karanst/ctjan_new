import 'dart:convert';
import 'package:ctjan/screens/bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/models/group_list_model.dart';
import 'package:ctjan/screens/feed_screen.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Helper/token_strings.dart';
import '../models/User.dart';

class GroupCard extends StatefulWidget {
  final GroupList data;
  const GroupCard({Key? key, required this.data}) : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}


class _GroupCardState extends State<GroupCard> {
  bool isLikeAnimating = false;
  User? user;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getProfileData();
    // getComments();
  }
  bool loadingData = false;
  String? userid;
  String? groupJoined;
  bool loading = false;


  getProfileData()async{
    setState(() {
      loadingData = true;
    });
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
          groupJoined = jsonResponse.userId!.groupId.toString();
          // loadingData = false;
          // profileImage = jsonResponse.userId!.profilePic.toString();
          // userName = jsonResponse.userId!.username.toString();
          // email = jsonResponse.userId!.email.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
        print("this is group status $groupJoined");
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

  // void getComments() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(widget.snap['postId'])
  //         .collection('comments')
  //         .get();
  //     commentLen = snap.docs.length;
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err.toString());
  //     }
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
   return Card(
     color: Colors.white,
     elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15)
            ),

      padding: const EdgeInsets.symmetric(
          vertical: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // border: Border.all(color: primaryClr)
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ).copyWith(right: 0),
        child: Row(
          children: [
            widget.data.image.toString() != '' || widget.data.image.toString() != null ?
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.data.image.toString(),)
                )
              ),
              // child: NetworkImage(
              //   widget.data.image.toString(),
              //   fit: BoxFit.fill,
              // ),
            )
            : const CircleAvatar(
              radius: 60,
              child: Icon(Icons.groups, color: Colors.white,),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        widget.data.name.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      // width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children:  [
                           Text("Date added : ",
                            // DateFormat.yMMMd().format(
                            //   // widget.snap['datePublished'].toDate(),
                            // ),
                            style:  TextStyle(
                              fontSize: 14,
                              color: secondaryClr,
                            ),
                          ),
                          Container(width: 90,
                            child: Text( widget.data.createdDate.toString(),
                              maxLines: 1,
                              style: TextStyle(
                              color: secondaryClr,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14
                            ),),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                           Text("No. of users : ",
                            style:  TextStyle(
                              fontSize: 14,
                              color: secondaryClr,
                            ),
                          ),
                          Text( widget.data.totalUser.toString(), style: TextStyle(
                              color: secondaryClr,
                              fontSize: 14
                          ),)

                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          loading = false;
                        });
                        String groupId = widget.data.id.toString();
                        if(groupJoined == "0"){
                          joinGroup(groupId);
                        }else{
                          showSnackbar("Already joined an group!", context);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 35,
                        alignment: Alignment.center,
                        //padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: primaryClr,
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
                        ): const Text("Join Group", style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),),

                      ),
                    ),
                    // Container(
                    //   width: 130,
                    //   height: 65,
                    //   child: NeoPopTiltedButton(
                    //     isFloating: true,
                    //     onTapUp: () {
                    //
                    //     },
                    //     decoration:  NeoPopTiltedButtonDecoration(
                    //         color: primaryClr,
                    //         plunkColor: Colors.black,
                    //         shadowColor: Colors.grey,
                    //         showShimmer: true,
                    //         shimmerColor: Colors.white,
                    //         shimmerWidth: 10),
                    //     child:   Center(
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(
                    //           horizontal: 30.0,
                    //           vertical: 15,
                    //         ),
                    //         child: Text('Join Group',
                    //             style: TextStyle(
                    //               color: mobileBackgroundColor,
                    //               //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                    //               fontWeight: FontWeight.bold,
                    //
                    //             )),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // ElevatedButton(
                    //     onPressed: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
                    // },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: primaryClr
                    //     ),
                    //     child: Text("Join Group"))
                  ],
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) => Dialog(
            //         child: ListView(
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 16,
            //           ),
            //           shrinkWrap: true,
            //           children: ['Delete']
            //               .map(
            //                 (e) => InkWell(
            //               onTap: () async {
            //                 FirestoreMethods().deletePost(
            //                     widget.snap['postId']);
            //                 Navigator.of(context).pop();
            //               },
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(
            //                   vertical: 12,
            //                   horizontal: 16,
            //                 ),
            //                 child: Text(e),
            //               ),
            //             ),
            //           )
            //               .toList(),
            //         ),
            //       ),
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.more_vert,
            //     color: primaryColor,
            //   ),
            // )
          ],
        ),
      ),
    ),
        );
  }
}
