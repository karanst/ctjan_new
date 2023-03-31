import 'dart:async';
import 'dart:convert';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/screens/add_post_screen.dart';
import 'package:ctjan/screens/bottom_bar.dart';
import 'package:ctjan/screens/faq.dart';
import 'package:ctjan/screens/group_screen.dart';
import 'package:ctjan/screens/privacy_policy.dart';
import 'package:ctjan/screens/search_screen.dart';
import 'package:ctjan/screens/send_otp.dart';
import 'package:ctjan/screens/terms_conditions.dart';
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
    Future.delayed(Duration(seconds: 1), (){
      getGroupList();
    });
    Future.delayed(Duration(seconds: 1), (){
      loadPosts();
    });
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
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getGroupPosts));
    request.fields.addAll({
      'group_id': grpId.toString(),
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
  getDrawer() {
    // print("checking user pic ${userPic}");
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primaryColor,
            ), //BoxDecoration
            child: Row(
              children: [
                const SizedBox(
                  height: 20,
                ),
                userPic == null || userPic == "" ?
                const CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 44,
                    )
                  //Image.network(userPic.toString()),
                )
                    :
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:Image.network("$userPic",fit: BoxFit.fill, height: 80, width: 80,),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const  Text(
                          "Hello!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userName == null || userName == ""?
                          "Guest"
                              :  "${userName.toString()}"
                          ,
                          style: TextStyle(
                              color: whiteColor, fontSize: 17),
                        ),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.account_balance_wallet_outlined,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //
                        //     Text(
                        //       " ₹ 500",
                        //       /*textScaleFactor: 1.3,*/
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w500,
                        //           color: Colors.white
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30),
                //   child: Column(
                //     children: [
                //       Text(onOff ? "Online":"Offline", style: TextStyle(fontSize: 15, color: onOff ? Colors.green: Colors.red, fontWeight: FontWeight.w600,),
                //       ),
                //       const SizedBox(
                //         height: 5,
                //       ),
                //       InkWell(
                //         onTap: () async{
                //           setState((){
                //             onOff = !onOff;
                //           });
                //           onOffStatus();
                //
                //
                //           // if(!statusOn){
                //           //   print("okkk");
                //           //   setState(() {
                //           //     // Status = index!;
                //           //   });
                //           //   OnOffModel? model = await onOffStatus();
                //           //   if (model! == false) {
                //           //     final snackBar = SnackBar(
                //           //       content: Text(
                //           //         model.message.toString(),
                //           //         style: TextStyle(
                //           //           color: Colors.white,
                //           //         ),
                //           //       ),
                //           //     );
                //           //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //           //   }
                //           // }else{
                //           //   setState((){
                //           //     changeOnTap = false;
                //           //   });
                //           // setSnackbar("Status Update");
                //           // }
                //         },
                //         child: Stack(
                //           children: [
                //             Container(
                //               height: 25,
                //               width: 50,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(40)
                //               ),
                //             ),
                //             onOff ?  Padding(
                //               padding: const EdgeInsets.only(left: 27.0, top: 2),
                //               child: Container(
                //                 width: 20,
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                     color: Colors.green,
                //                     shape: BoxShape.circle
                //                 ),
                //               ),
                //             )
                //                 : Padding(
                //               padding: const EdgeInsets.only(left: 3.0, top: 3),
                //               child: Container(
                //                 width: 20,
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                     color: Colors.red,
                //                     shape: BoxShape.circle
                //                 ),
                //
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       // ToggleSwitch(
                //       //   customWidths: [35.0, 35.0],
                //       //   cornerRadius: 20.0,
                //       //   activeBgColors: [[Colors.green], [Colors.red]],
                //       //   activeFgColor: Colors.white,
                //       //   inactiveBgColor: Colors.grey,
                //       //   inactiveFgColor: Colors.white,
                //       //   totalSwitches: 2,
                //       //   // labels: ['YES', ''],
                //       //   // icons: [null, FontAwesomeIcons.times],
                //       //   onToggle: (index) async {
                //       //     if(!statusOn){
                //       //       print("okkk");
                //       //       setState(() {
                //       //         // Status = index!;
                //       //       });
                //       //       OnOffModel? model = await onOffStatus();
                //       //       if (model! == false) {
                //       //         final snackBar = SnackBar(
                //       //           content: Text(
                //       //             model.message.toString(),
                //       //             style: TextStyle(
                //       //               color: Colors.white,
                //       //             ),
                //       //           ),
                //       //         );
                //       //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //       //       }
                //       //     }else{
                //       //       setState((){
                //       //         changeOnTap = false;
                //       //       });
                //       //       // setSnackbar("Status Update");
                //       //     }
                //       //     // onOffStatus();
                //       //     print('switched to: $index');
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ), //DrawerHeader
          ListTile(
            // leading: Icon(Icons.home),
            // leading: Image.asset("assets),
            leading:  Icon(Icons.home_outlined, size: 25,
              color: primaryClr,),
            // Image.asset("images/icons/home_fill.png", color: Colors.white, height: 25, width: 25,),
            // leading: const ImageIcon(AssetImage("images/icons/Home.png", )),
            title: const Text('Home', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomBar()),
              );
            },
          ),
          ListTile(
            // leading: Icon(Icons.list),
            leading:  Icon(Icons.upload_file_outlined, size: 25,
              color: primaryClr,),
            // leading: const ImageIcon(AssetImage("images/icons/booking.png")),
            title:  const Text('Add Posts',style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            // selected: index == _selectedIndex,
            onTap: () {
              // setState(() {
              //   _selectedIndex = index;
              // });
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> AddPostScreen()
                ),
              );
            },
          ),

          ListTile(
            // leading: Icon(Icons.list),
            leading:  Icon(Icons.star_border_purple500_outlined, size: 25,
              color: primaryClr,),
            // leading: const ImageIcon(AssetImage("images/icons/booking.png")),
            title: const Text('Shortlist',style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            // selected: index == _selectedIndex,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistScreen()));

            },
          ),

          // ListTile(
          //   // leading: Icon(Icons.home),
          //   // leading: Image.asset("assets),
          //   leading:  Icon(Icons.safety_divider_outlined, size: 25,
          //     color: primaryColor,),
          //   // Image.asset("images/icons/home_fill.png", color: Colors.white, height: 25, width: 25,),
          //   // leading: const ImageIcon(AssetImage("images/icons/Home.png", )),
          //   title:  Text('Refer and Earn', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),),
          //   onTap: () {
          //     Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const ReferEarnScreen()),
          //     );
          //   },
          // ),
          ListTile(
            // leading: Icon(Icons.report),
            leading: Icon(Icons.group_add, color: primaryClr, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Emergancy contect.png")),
            title:  const Text('Change Group', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> ChangeGroupScreen()),
              );
            },
          ),

          ListTile(
            // leading: Icon(Icons.security),
            leading: Icon(Icons.privacy_tip_outlined, color: primaryClr, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Refferal.png")),
            title:  Text('Privacy Policy', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> PrivacyPolicyScreen()),
              );
            },
          ),



          ListTile(
            // leading: Icon(Icons.report),
            leading: Icon(Icons.people, color: primaryClr, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Emergancy contect.png")),
            title:  Text('Terms and Conditions', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> TermsConditions()),
              );
            },
          ),

          ListTile(
            // leading: Icon(Icons.support),
            leading: Icon(Icons.support_agent, size: 25, color: primaryClr,),
            // leading: const ImageIcon(AssetImage("assets/Icons/FAQ.png")),
            title:  Text('FAQs', style: TextStyle(color: primaryColor,fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqScreen()),
              );
            },
          ),

          ListTile(
            onTap: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                prefs.setString(TokenString.userid, '');
              });
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            // leading: Icon(Icons.logout_outlined),
            leading: Icon(Icons.logout, size: 25, color: primaryClr,),
            title: Text('Log Out', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: Divider(color: Colors.black,),
          // ),
          //
          // Padding(
          //   padding: const EdgeInsets.only(left:20,top:10),
          //   child: Text('Sod @ Service on demand'),
          // ),
          const SizedBox(
            height: 35,
          ),

          const Padding(
            padding:  EdgeInsets.only(left: 15),
            child: Text("Follow Us", style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 25, left: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/youtube.png",
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/facebook.png",
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/insta.png",
          //           height: 30,
          //         ),
          //       ),
          //       Image.asset(
          //         "images/icons/twitter.png",
          //         height: 30,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 10),
          //         child: Image.asset(
          //           'images/icons/linkedin.png',
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 10),
          //         child: Image.asset(
          //           'images/icons/google.png',
          //           height: 30,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: primaryClr,
    key: _refreshIndicatorKey,
    onRefresh: _refresh,
    child: Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        // leading: Image.asset('assets/applogo.png' ,height: 50, width: 50,),
        //Icon(Icons.arrow_back_ios, color:  primaryClr,),
        backgroundColor: primaryClr,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/applogo.png' ,height: 50, width: 50,),
            Text("CTjan", style: TextStyle(
               color: mobileBackgroundColor
                ),),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
          }, icon: Icon(Icons.search_outlined, color: whiteColor,)),
          IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const WishlistScreen()));
        }, icon:
        Icon(Icons.star,
          size: 24,
          color: mobileBackgroundColor,))],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryClr,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostScreen()));
        },
        child: Center(
          child: Icon(Icons.add, color: whiteColor, size: 30,),
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
                                "Public Issue",
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
                                "Event",
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
                      // CircularProgressIndicator(
                      //   color: primaryColor,
                      // ),
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
