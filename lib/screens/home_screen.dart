// import 'package:ctjan/Helper/token_strings.dart';
// import 'package:ctjan/screens/group_screen.dart';
// import 'package:ctjan/screens/feed_screen.dart';
// import 'package:ctjan/screens/wishlist.dart';
// import 'package:ctjan/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String? groupJoined;
//   const HomeScreen({Key? key, this.groupJoined}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   String? userId;
//   String? isGroupJoined;
//
//   getUserDataFromPrefs() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       userId = preferences.getString(TokenString.userid);
//       isGroupJoined = preferences.getString(TokenString.groupJoined);
//     });
//     print("this is group join status home ===>>>> ${isGroupJoined.toString()}");
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration(milliseconds: 300), (){
//       getUserDataFromPrefs();
//     });
//
//
//     // getGroupList();
//     // if(widget.groupJoined == "1"){
//     //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
//     // }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.arrow_back_ios, color:  primaryClr,),
//         backgroundColor: primaryClr,
//         centerTitle: true,
//         title: Padding(
//           padding: const EdgeInsets.only(right: 50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/applogo.png' ,height: 50, width: 50,),
//                Text("CTjan", style: TextStyle(
//                   color: mobileBackgroundColor
//               ),)
//             ],
//           ),
//         ),
//         actions: [
//           IconButton(onPressed: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context)=> const WishlistScreen()));
//         }, icon:  Icon(Icons.favorite_outline, color: mobileBackgroundColor,))],
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {},
//         //     icon: const Icon(
//         //       Icons.add_box_outlined,
//         //     ),
//         //   ),
//         //   IconButton(
//         //     onPressed: () {},
//         //     icon: const Icon(
//         //       Icons.send_outlined,
//         //     ),
//         //   )
//         // ],
//       ),
//       body:
//           isGroupJoined ==null || isGroupJoined == ''?
//               CircularProgressIndicator()
//       : isGroupJoined == "0" ?
//       const GroupScreen()
//       : const FeedScreen(),
//     );
//   }
// }
