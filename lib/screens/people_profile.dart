// // import 'package:ctjan/models/people_model.dart';
// // import 'package:flutter/material.dart';
// // import '../utils/colors.dart';
// // class PeopleprofileScreen extends StatefulWidget {
// //   final Data? data;
// //   const PeopleprofileScreen({Key? key, this.data}) : super(key: key);
// //
// //   @override
// //   State<PeopleprofileScreen> createState() => _PeopleprofileScreenState();
// // }
// //
// // class _PeopleprofileScreenState extends State<PeopleprofileScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           leading: Icon(Icons.arrow_back_ios, color:  primaryClr,),
// //           backgroundColor: primaryClr,
// //           centerTitle: true,
// //           title: Text("People", style: TextStyle(
// //               color: mobileBackgroundColor
// //           ),),
// //           // actions: [
// //           //   IconButton(onPressed: (){
// //           //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const WishlistScreen()));
// //           // }, icon:
// //           // Icon(Icons.favorite_outline, color: mobileBackgroundColor,))],
// //           // actions: [
// //           //   IconButton(
// //           //     onPressed: () {},
// //           //     icon: const Icon(
// //           //       Icons.add_box_outlined,
// //           //     ),
// //           //   ),
// //           //   IconButton(
// //           //     onPressed: () {},
// //           //     icon: const Icon(
// //           //       Icons.send_outlined,
// //           //     ),
// //           //   )
// //           // ],
// //         ),
// //         body:
// //         SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Card(
// //                 color: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(20)
// //                 ),
// //                 elevation: 5,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Column(
// //                     children: [
// //
// //                     ],
// //                   ),
// //                 ),
// //               )
// //
// //             ],
// //           ),
// //         )
// //
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const MyStatefulWidget(),
//       ),
//     );
//   }
// }
//
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({super.key});
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   bool _customTileExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         const ExpansionTile(
//           title: Text('ExpansionTile 1'),
//           subtitle: Text('Trailing expansion arrow icon'),
//           children: <Widget>[
//             ListTile(title: Text('This is tile number 1')),
//           ],
//         ),
//         ExpansionTile(
//           title: const Text('ExpansionTile 2'),
//           subtitle: const Text('Custom expansion arrow icon'),
//           trailing: Icon(
//             _customTileExpanded
//                 ? Icons.arrow_drop_down_circle
//                 : Icons.arrow_drop_down,
//           ),
//           children: const <Widget>[
//             ListTile(title: Text('This is tile number 2')),
//           ],
//           onExpansionChanged: (bool expanded) {
//             setState(() => _customTileExpanded = expanded);
//           },
//         ),
//         const ExpansionTile(
//           title: Text('ExpansionTile 3'),
//           subtitle: Text('Leading expansion arrow icon'),
//           controlAffinity: ListTileControlAffinity.leading,
//           children: <Widget>[
//             ListTile(title: Text('This is tile number 3')),
//           ],
//         ),
//       ],
//     );
//   }
// }
