import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/group_list_model.dart';
import 'package:ctjan/models/search_group_model.dart';
import 'package:ctjan/widgets/group_card.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ctjan/screens/profile_screen.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/global_variables.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getGroupList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GroupList> list = [];
  List<GroupList> searchList = [];

  // getGroupList()async{
  //
  //   var headers = {
  //     'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
  //   };
  //   var request = http.MultipartRequest('GET', Uri.parse(ApiPath.groupList));
  //   request.fields.addAll({
  //     // 'user_id': userid.toString()
  //     // 'seeker_email': '$userid'
  //   });
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var finalResponse = await response.stream.bytesToString();
  //     final jsonResponse = GroupListModel.fromJson(json.decode(finalResponse));
  //     if(jsonResponse.responseCode == "1") {
  //
  //       setState(() {
  //         list = jsonResponse.data!;
  //       });
  //       print("this is group list length ${list.length}");
  //     }else{
  //
  //     }
  //     // print("select qualification here ${selectedQualification}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  searchGroups(String? keyword)async{
    searchList.clear();

    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.searchGroups));
    request.fields.addAll({
      'search_keyword': keyword.toString()
      //_searchController.text.toString()
      // 'user_id': userid.toString()a
      // 'seeker_email': '$userid'
    });
    print("this is search request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      // final jsonResponse = json.decode(finalResponse);
      final jsonResponse = GroupListModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          searchList = jsonResponse.data!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryClr,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios, color: whiteColor,)),
        title: Text("Search")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Card(
                color: whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: TextField(
                  maxLines: 1,
                  controller: _searchController,
                  onChanged: (String val){
                    // if(val.length >=4) {
                    setState(() {
                      searchGroups(val);
                      searchList.clear();
                    });
                    // }
                  },
                  onSubmitted: (String? val){
                    _searchController.clear();
                    searchGroups(val);
                  },
                  style: const TextStyle(color: primaryColor),
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, top: 14),
                    hintText: 'Search for a group or area',
                    hintStyle: const TextStyle(
                        color: primaryColor
                    ),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search_outlined, color: primaryClr,)
                    // icon: Icon(Icons.search_outlined, color: primaryClr,),
                  ),
                  // onFieldSubmitted: (String _) {
                  //   setState(() {
                  //     _isShowUser = true;
                  //   });
                  // },
                ),
              ),
              // FutureBuilder(
              //         future: FirebaseFirestore.instance
              //             .collection('users')
              //             .where(
              //               'username',
              //               isGreaterThanOrEqualTo: _searchController.text,
              //             )
              //             .get(),
              //         builder: (context, snapshot) {
              //           if (!snapshot.hasData) {
              //             return const Center(
              //               child: CircularProgressIndicator(
              //                 color: primaryColor,
              //               ),
              //             );
              //           }
              //           return ListView.builder(
              //             itemCount: (snapshot.data! as dynamic).docs.length,
              //             itemBuilder: (context, index) {
              //               return InkWell(
              //                 onTap: () => Navigator.of(context).push(
              //                   MaterialPageRoute(
              //                     builder: (context) => const ProfileScreen(
              //                       // uid: (snapshot.data! as dynamic).docs[index]
              //                       //     ['uid'],
              //                     ),
              //                   ),
              //                 ),
              //                 child: ListTile(
              //                   leading: CircleAvatar(
              //                     backgroundImage: NetworkImage(
              //                       (snapshot.data! as dynamic)
              //                               .docs[index]
              //                               .data()
              //                               .containsKey('photoUrl')
              //                           ? (snapshot.data! as dynamic).docs[index]
              //                               ['photoUrl']
              //                           : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
              //                     ),
              //                   ),
              //                   title: Text(
              //                     (snapshot.data! as dynamic).docs[index]['username'],
              //                   ),
              //                 ),
              //               );
              //             },
              //           );
              //         },
              //       ),
              searchList.isNotEmpty ?
              Container(
                // height: MediaQuery.of(context).size.height,
                child: Card(
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
                            itemCount: searchList.length,
                            itemBuilder: (context, index){
                              return GroupCard(
                                isButtonVisible: true,
                                data: searchList[index],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              )
                  :  Container(
                width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                      child:  Text("No results found!", style: TextStyle(color: primaryColor),))),
              // const Padding(
              //   padding:  EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
              //   child:  Text("Groups", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
              // ),
              // list.isNotEmpty ?
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   child: Card(
              //     color: Colors.white,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20)
              //     ),
              //     elevation: 5,
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(
              //         children: [
              //           ListView.builder(
              //               physics: const NeverScrollableScrollPhysics(),
              //               shrinkWrap: true,
              //               itemCount: list.length,
              //               itemBuilder: (context, index){
              //                 return GroupCard(
              //                   data: list[index],
              //                 );
              //               }),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
              //     : Center(child: CircularProgressIndicator(
              //   color: primaryClr,
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
