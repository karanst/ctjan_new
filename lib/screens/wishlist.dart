import 'dart:async';
import 'dart:convert';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/screens/faq.dart';
import 'package:ctjan/widgets/post_card.dart';
import 'package:ctjan/widgets/wishlist_card.dart';
import 'package:http/http.dart' as http;
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/api_path.dart';
import '../utils/global_variables.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishList> postList = [];
  String? userid;
  String? grpId;

  StreamController<List<WishList>> _streamController = StreamController<List<WishList>>();

  Future<List<WishList>?> getWishListData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getWishlistData));
    request.fields.addAll({
      'user_id': userid.toString()
    });

    print("this is wishlist data request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var finalResponse = await response.stream.bytesToString();
    final jsonResponse = WishlistModel.fromJson(json.decode(finalResponse));
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
    return WishlistModel.fromJson(json.decode(finalResponse)).data;
  }


  loadWishlists() async {
    getWishListData().then((res) async {
      _streamController.add(res!);
      return res;
    });
  }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
    Future.delayed(const Duration(milliseconds: 300), (){
      getWishListData();
      loadWishlists();
    });

  }
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
            icon: Icon(Icons.arrow_back_ios, color: whiteColor,
        )),
        backgroundColor: primaryClr,
        centerTitle: true,
        title: const Text("Shortlist"),
      ),
     body:
     StreamBuilder<List<WishList>>(
    stream: _streamController.stream,
      builder: (context, AsyncSnapshot<List<WishList>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("No data in wishlist!", style: TextStyle(
              color: primaryColor
            ),)
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
            child:
            WishlistCard(
              data: snapshot.data![index],
            ),
          )
              : Container(),
        //   gridDelegate:
        // SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3,
        //   childAspectRatio: 0.75
        // ),
        )
            : const Center(
          child: Text('Wishlist empty!', style: TextStyle(
              color: primaryColor
          ),),
        );
      },
    ),
    );
  }
}
