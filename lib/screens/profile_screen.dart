import 'dart:convert';
import 'package:ctjan/models/myposts_model.dart';
import 'package:ctjan/screens/bottom_bar.dart';
import 'package:ctjan/screens/faq.dart';
import 'package:ctjan/screens/group_screen.dart';
import 'package:ctjan/screens/my_posts.dart';
import 'package:ctjan/screens/privacy_policy.dart';
import 'package:ctjan/screens/terms_conditions.dart';
import 'package:ctjan/screens/wishlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/screens/edit_profile_screen.dart';
import 'package:ctjan/screens/send_otp.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Helper/api_path.dart';

class ProfileScreen extends StatefulWidget {
  // final String? uid;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followerLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool loadingData = false;
  int selectIndex = 1;

  @override
  void initState() {
    super.initState();
    getProfileData();
    Future.delayed(Duration(seconds: 1), (){
      myPosts();
      getProfileData();
    });
    // Future.delayed(const Duration(seconds: 1), (){
    //   myPosts();
    // });
  }
  String? profileImage;
  String? userName;
  // String? fName;
  String? email;
  String? userid;
  String? userPic;
  String? grpId;

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
          loadingData = false;
          profileImage = jsonResponse.userId!.profilePic.toString();
          userName = jsonResponse.userId!.username.toString();
          email = jsonResponse.userId!.aboutUs.toString();
          grpId = jsonResponse.userId!.groupId.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
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
      'group_id': '$grpId',
      'post_type': selectIndex.toString()
    });
    print("this is my posts request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = MypostsModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          posts = jsonResponse.data!;
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
                MaterialPageRoute(builder: (context)=>BottomBar(index: 1,),
                ),
              );
            },
          ),

          ListTile(
            // leading: Icon(Icons.list),
            leading:  Icon(Icons.favorite_border_outlined, size: 25,
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
            leading: Icon(Icons.people_outline, color: primaryClr, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Emergancy contect.png")),
            title:  Text('Change Group', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
    return Scaffold(
      // endDrawer: getDrawer(),
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
        leading: Icon(Icons.arrow_back_ios, color: primaryClr,),
              backgroundColor: primaryClr,
        titleSpacing: 0.0,
        title:  Transform(
          // you can forcefully translate values left side using Transform
          transform:  Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: userName == null || userName == ""?
          const CircularProgressIndicator(
            color: Colors.white,
          )
              : const Text(
            "Profile"
          //     userName != null || userName != ""?
          // userName.toString()
          //     : 'Loading'
          ),
        ),
              centerTitle: false,
            ),
      body: ListView(
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? const EdgeInsets.all(15)
                : const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getProfileDetailsSection(
                    MediaQuery.of(context).size.width > webScreenSize),
                Padding(
                  padding: const  EdgeInsets.only(left: 15.0, right: 15),
                  child:  Divider(color: primaryClr, thickness: 2,),
                ),
                const Padding(
                  padding:  EdgeInsets.only(left: 15.0, top: 8, bottom: 8),
                  child: Text("My Posts", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 18),),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectIndex = 1;
                            });
                            myPosts();
                            getProfileData();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryClr),
                                borderRadius: BorderRadius.circular(10),
                                color: selectIndex == 1 ? primaryClr : Colors.white),
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    "Post",
                                    style: TextStyle(
                                      fontSize: 16,
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
                            myPosts();
                            getProfileData();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryClr),
                                borderRadius: BorderRadius.circular(10),
                                color: selectIndex == 2 ? primaryClr : Colors.white),
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    "Public Issues",
                                    style: TextStyle(
                                      fontSize: 16,
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
                            myPosts();
                            getProfileData();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryClr),
                                borderRadius: BorderRadius.circular(10),
                                color: selectIndex == 3 ? primaryClr : Colors.white),
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    "Event",
                                    style: TextStyle(
                                        fontSize: 16,
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
                // FutureBuilder(
                //   future: myPosts(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: Text("No posts found!", style: TextStyle(
                //           color: Colors.black
                //         ),)
                //       );
                //     }
                //     return
                posts.isNotEmpty ?
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: posts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          // DocumentSnapshot snap =
                          //     (snapshot.data! as dynamic).docs[index];
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPostScreen(
                                grpId: grpId.toString(),
                              )));
                            },
                            child:  posts[index].img![0].toString() == "" ||  posts[index].img![0].toString() == imageUrl ?
                                Image.asset('assets/placeholder.png'):
                            Image(
                              image: NetworkImage(
                                posts[index].img![0].toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        })
                    : const Center(
                      child: Text("No posts found!", style: TextStyle(color: Colors.black),),
                    ),
                //   },
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container getProfileDetailsSection(bool isWeb) {
    return
      // isWeb
      //   ? Container(
      //       margin: EdgeInsets.symmetric(
      //         horizontal: MediaQuery.of(context).size.width * 0.14,
      //         vertical: 10,
      //       ),
      //       child: Column(
      //         children: [
      //           Row(
      //             children: [
      //               CircleAvatar(
      //                 backgroundColor: Colors.grey,
      //                 backgroundImage: NetworkImage(
      //                   profileImage != '' || profileImage != null?
      //                       profileImage.toString()
      //                       : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
      //                       // :
      //                       // ? userData['photoUrl']
      //
      //                 ),
      //                 radius: MediaQuery.of(context).size.width * 0.08,
      //               ),
      //               // Expanded(
      //               //   flex: 1,
      //               //   child: Column(
      //               //     children: [
      //               //       Container(
      //               //         padding: const EdgeInsets.all(15),
      //               //         child: Row(
      //               //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               //           children: [
      //               //             Text(
      //               //               userData.containsKey('username')
      //               //                   ? userData['username']
      //               //                   : 'Loading',
      //               //               style: const TextStyle(
      //               //                 fontWeight: FontWeight.w200,
      //               //                 fontSize: 24,
      //               //               ),
      //               //             ),
      //               //             FirebaseAuth.instance.currentUser!.uid ==
      //               //                     widget.uid
      //               //                 ? FollowButton(
      //               //                     background: mobileBackgroundColor,
      //               //                     borderColor: Colors.grey,
      //               //                     text: "Sign Out",
      //               //                     textColor: primaryColor,
      //               //                     function: () async {
      //               //                       AuthMethods().signOut();
      //               //                       Navigator.of(context).pushReplacement(
      //               //                         MaterialPageRoute(
      //               //                           builder: (context) =>
      //               //                               const SignInScreen()
      //               //                               //LoginScreen(),
      //               //                         ),
      //               //                       );
      //               //                     },
      //               //                   )
      //               //                 : isFollowing
      //               //                     ? FollowButton(
      //               //                         background: Colors.white,
      //               //                         borderColor: Colors.grey,
      //               //                         text: "Unfollow",
      //               //                         textColor: Colors.black,
      //               //                         function: () async {
      //               //                           await FirestoreMethods()
      //               //                               .followUser(
      //               //                                   FirebaseAuth.instance
      //               //                                       .currentUser!.uid,
      //               //                                   userData['uid']);
      //               //                           setState(() {
      //               //                             setState(() {
      //               //                               isFollowing = false;
      //               //                               followerLen--;
      //               //                             });
      //               //                           });
      //               //                         },
      //               //                       )
      //               //                     : FollowButton(
      //               //                         background: Colors.blue,
      //               //                         borderColor: Colors.blue,
      //               //                         text: "Follow",
      //               //                         textColor: Colors.white,
      //               //                         function: () async {
      //               //                           await FirestoreMethods()
      //               //                               .followUser(
      //               //                                   FirebaseAuth.instance
      //               //                                       .currentUser!.uid,
      //               //                                   userData['uid']);
      //               //                           setState(() {
      //               //                             isFollowing = true;
      //               //                             followerLen++;
      //               //                           });
      //               //                         },
      //               //                       )
      //               //           ],
      //               //         ),
      //               //       ),
      //               //       Row(
      //               //         mainAxisSize: MainAxisSize.max,
      //               //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               //         children: [
      //               //           buildStatColumn(postLen, "Posts"),
      //               //           buildStatColumn(followerLen, "Followers"),
      //               //           buildStatColumn(followingLen, "Following"),
      //               //         ],
      //               //       ),
      //               //       Column(
      //               //         crossAxisAlignment: CrossAxisAlignment.end,
      //               //         mainAxisAlignment: MainAxisAlignment.end,
      //               //         children: [
      //               //           Container(
      //               //             width: double.infinity,
      //               //             padding:
      //               //                 const EdgeInsets.only(left: 15, top: 15),
      //               //             alignment: Alignment.centerLeft,
      //               //             child: Text(
      //               //               userData.containsKey('username')
      //               //                   ? userData['username']
      //               //                   : 'Loading',
      //               //               style: const TextStyle(
      //               //                 fontWeight: FontWeight.bold,
      //               //               ),
      //               //             ),
      //               //           ),
      //               //           Container(
      //               //             width: double.infinity,
      //               //             alignment: Alignment.centerLeft,
      //               //             padding:
      //               //                 const EdgeInsets.only(left: 15, top: 5),
      //               //             child: Text(
      //               //               userData.containsKey('bio')
      //               //                   ? userData['bio']
      //               //                   : 'loading',
      //               //             ),
      //               //           ),
      //               //         ],
      //               //       ),
      //               //     ],
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     )
      //   :
      Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 10,
            ),
            child: Column(
              children: [
                loadingData ?
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryClr,
                      ),
                    )
               :  Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        profileImage != '' || profileImage != null?
                             profileImage.toString()
                            : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
                      ),
                      radius: 48,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              userName != '' || userName != null ?
                              userName.toString()
                                  : 'Guest',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              email != '' || email != null ?
                              email.toString()
                                  : '',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     FirebaseAuth.instance.currentUser!.uid ==
                          //             widget.uid
                          //         ? FollowButton(
                          //             background: mobileBackgroundColor,
                          //             borderColor: Colors.grey,
                          //             text: "Sign Out",
                          //             textColor: primaryColor,
                          //             function: () async {
                          //               AuthMethods().signOut();
                          //               Navigator.of(context).pushReplacement(
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const SignInScreen()
                          //                       //LoginScreen(),
                          //                 ),
                          //               );
                          //             },
                          //           )
                          //         : isFollowing
                          //             ? FollowButton(
                          //                 background: Colors.white,
                          //                 borderColor: Colors.grey,
                          //                 text: "Unfollow",
                          //                 textColor: Colors.black,
                          //                 function: () async {
                          //                   await FirestoreMethods().followUser(
                          //                       FirebaseAuth
                          //                           .instance.currentUser!.uid,
                          //                       userData['uid']);
                          //                   setState(() {
                          //                     setState(() {
                          //                       isFollowing = false;
                          //                       followerLen--;
                          //                     });
                          //                   });
                          //                 },
                          //               )
                          //             : FollowButton(
                          //                 background: Colors.blue,
                          //                 borderColor: Colors.blue,
                          //                 text: "Follow",
                          //                 textColor: Colors.white,
                          //                 function: () async {
                          //                   await FirestoreMethods().followUser(
                          //                       FirebaseAuth
                          //                           .instance.currentUser!.uid,
                          //                       userData['uid']);
                          //                   setState(() {
                          //                     isFollowing = true;
                          //                     followerLen++;
                          //                   });
                          //                 },
                          //               )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryClr
                      ),
                        child: IconButton(onPressed: (){
                         var result =  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                         print("this is result ${result.toString()}");
                         if(result != null){
                          getProfileData();
                         }
                        }, icon:  Icon(Icons.edit, color: mobileBackgroundColor,)))
                  ],
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.only(
                //     top: 15,
                //   ),
                //   child: Text(
                //     userName != '' || userName != null ?
                //         userName.toString()
                //         : 'Loading',
                //     style: const TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.only(
                //     top: 15,
                //   ),
                //   child: Text(
                //     userData.containsKey('bio') ? userData['bio'] : 'loading',
                //   ),
                // ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
