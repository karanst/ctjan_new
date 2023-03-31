// import 'package:ctjan/screens/add_post_screen.dart';
// import 'package:ctjan/utils/colors.dart';
// import 'package:flutter/material.dart';
//
// class AddPosts extends StatefulWidget {
//   const AddPosts({Key? key}) : super(key: key);
//
//   @override
//   State<AddPosts> createState() => _AddPostsState();
// }
//
// class _AddPostsState extends State<AddPosts> {
//   var type;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryClr,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: primaryClr,
//           ),
//           onPressed: (){
//             // Navigator.pop(context);
//           },
//         ),
//         title: const Text('Add Post'),
//         centerTitle: true,
//         // actions: [
//         //   // TextButton(
//         //   //   onPressed: () => postImage(
//         //   //     user.uid,
//         //   //     user.username,
//         //   //     user.photoUrl,
//         //   //   ),
//         //   //   child: const Text(
//         //   //     'Post',
//         //   //     style: TextStyle(
//         //   //       color: Colors.white,
//         //   //       fontWeight: FontWeight.bold,
//         //   //       fontSize: 16,
//         //   //     ),
//         //   //   ),
//         //   // )
//         // ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(left: 5),
//               width: MediaQuery.of(context).size.width - 50,
//               height: 60,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.grey,
//                       offset:  Offset(
//                         1.0,
//                         1.0,
//                       ),
//                       blurRadius: 0.5,
//                       spreadRadius: 0.5,
//                     ),
//                   ]
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton(
//                   isExpanded: true,
//                   // Initial Value
//                   value: type,
//                   dropdownColor: Colors.white,
//                   hint: const Text("Select Post Type", style: TextStyle(
//                       color: webBackgroundColor
//                   ),),
//                   // Down Arrow Icon
//                   icon:  const Icon(Icons.keyboard_arrow_down,color:  webBackgroundColor),
//
//                   // Array list of items
//                   items: ['Normal', 'Event', 'Public'].map(( items) {
//                     return DropdownMenuItem(
//                       value: items
//                           .toString(),
//                       child: Text(items.toString(), style: TextStyle(
//                           color: webBackgroundColor
//                       ),),
//                     );
//                   }).toList(),
//                   // After selecting the desired option,it will
//                   // change button value to selected value
//                   onChanged: ( newValue) {
//                     setState(() {
//                       type = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20,),
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen(
//                   type: type,
//                 )));
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width / 1.1,
//                 height: 52,
//                 alignment: Alignment.center,
//                 //padding: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                     color: primaryClr,
//                     borderRadius: BorderRadius.circular(10)
//                 ),
//                 child:
//                 // isLoading ? Center(
//                 //   child: Container(
//                 //     height: 30,
//                 //     width: 30,
//                 //     child: CircularProgressIndicator(
//                 //       color: whiteColor,
//                 //     ),
//                 //   ),
//                 // ):
//                 const Text("Submit", style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600
//                 ),),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
