import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/models/myposts_model.dart';

import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/token_strings.dart';


class MyPostCard extends StatefulWidget {
  final MyPosts? data;
  final String? postId;
  const MyPostCard({Key? key, this.data, this.postId}) : super(key: key);

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {


  // String? userid;
  //
  // removeFromWishList()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = prefs.getString(TokenString.userid);
  //   var headers = {
  //     'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
  //   };
  //   var request = http.MultipartRequest('POST',
  //       Uri.parse(ApiPath.removeFromWishList));
  //
  //   request.fields.addAll({
  //     'user_id': userid.toString(),
  //     'post_id':widget.data!.postid!.toString(),
  //   });
  //
  //   print("this is send comment request ${request.fields.toString()}");
  //
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //
  //     var finalResponse = await response.stream.bytesToString();
  //     final jsonResponse = json.decode(finalResponse);
  //     if(jsonResponse['response_code'] == '1'){
  //       showSnackbar("${jsonResponse['message']}", context);
  //       // setState(() {
  //       //   _commentController.clear();
  //       // });
  //       // loadComments();
  //       // showSnackbar("${jsonResponse['message']}", context);
  //
  //     }
  //     else{
  //       showSnackbar("${jsonResponse['message']}", context);
  //     }
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }


  String? userid;

  deletePosts()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.deletePost));

    request.fields.addAll({
      // 'user_id': userid.toString(),
      'post_id':widget.postId!.toString(),
    });

    print("this is delete post request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['response_code'] == '1'){
        showSnackbar("${jsonResponse['message']}", context);
        Navigator.pop(context, 'true');
        // setState(() {
        //   _commentController.clear();
        // });
        // loadComments();
        // showSnackbar("${jsonResponse['message']}", context);
      }
      else{
        showSnackbar("${jsonResponse['message']}", context);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  int _currentPost =  0;
  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < widget.data!.img!.length; i++) {
      dots.add(
        Container(
          margin: EdgeInsets.all(5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPost == i
                ? primaryClr
                : Colors.grey.withOpacity(0.5),
          ),
        ),
      );
    }
    return dots;
  }



  @override
  Widget build(BuildContext context) {
    // user = Provider.of<UserProvider>(context).getUser;
    // return user == null
    //     ? Container()
    //     :
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.data!.profilePic.toString(),
                  ),
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
                        Text(
                          '${widget.data!.fName.toString()} ${widget.data!.lName.toString()}',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: ['Delete Post']
                              .map(
                                (e) => InkWell(
                              onTap: () async {
                                deletePosts();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Text(e),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ),
                )
                // IconButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => Dialog(
                //         child: Container(
                //           height: 150,
                //           width: MediaQuery.of(context). size.width ,
                //           decoration: BoxDecoration(
                //               color: whiteColor,
                //               borderRadius: BorderRadius.circular(15)
                //           ),
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text("Remove from wishlist", style: TextStyle(color: primaryClr),),
                //               const SizedBox(height: 40,),
                //               Padding(
                //                 padding: const EdgeInsets.all(8),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     ElevatedButton(onPressed: (){
                //                       // removeFromWishList();
                //                       Navigator.pop(context);
                //                     }, child:  Text("Remove", style: TextStyle(color: whiteColor),),
                //                       style: ElevatedButton.styleFrom(
                //                           primary: primaryClr
                //                       ),),
                //                     ElevatedButton(onPressed: (){
                //                       Navigator.pop(context);
                //                     }, child:  Text("Cancel", style: TextStyle(color: primaryClr),),
                //                       style: ElevatedButton.styleFrom(
                //                           primary: secondaryColor
                //                       ),),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
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
          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              // setState(() {
              //   isLiked = !isLiked;
              // });
              // likeUnlike();
              // // await FirestoreMethods().likePost(
              // //   widget.snap['postId'],
              // //   user!.uid,
              // //   widget.snap['likes'],
              // // );
              // setState(() {
              //   isLikeAnimating = true;
              // });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // widget.data!.img!.isNotEmpty  || widget.data!.img == null ?
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.35,
                //   width: double.infinity,
                //   child: Image.asset(
                //     'assets/placeholder.png',
                //     // widget.snap['postUrl'],
                //     fit: BoxFit.cover,
                //   ),
                // )
                // :
                widget.data!.img!.length > 1
                    ? CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPost = index;
                      });
                    },
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 1,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration:
                    Duration(milliseconds: 1000),
                    viewportFraction: 1,
                  ),
                  items: widget.data!.img!.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.35,
                              width: double.infinity,
                              child: item.isEmpty || item == imageUrl
                                  ? Image.asset(
                                'assets/placeholder.png',
                                // widget.snap['postUrl'],
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                item,
                                // widget.snap['postUrl'],
                                fit: BoxFit.cover,
                              ),
                            ));
                      },
                    );
                  }).toList(),
                )
                    : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: widget.data!.img!.isEmpty || widget.data!.img![0].toString() == imageUrl
                      ? Image.asset(
                    'assets/placeholder.png',
                    // widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    widget.data!.img![0].toString(),
                    // widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                // Container(
                //   height: 40,
                //   child: ListView.builder(
                //     itemCount: widget.data!.img!.length,
                //       itemBuilder: (context, index){
                //     return DotsIndicator(
                //       dotsCount: widget.data!.img!.length,
                //       position: 1,
                //     );
                //   }),
                // )


                // AnimatedOpacity(
                //   duration: const Duration(milliseconds: 200),
                //   opacity: isLikeAnimating ? 1 : 0,
                //   child: LikeAnimation(
                //     isAnimating: isLikeAnimating,
                //     duration: const Duration(
                //       milliseconds: 400,
                //     ),
                //     child: const Icon(
                //       Icons.favorite,
                //       color: primaryColor,
                //       size: 120,
                //     ),
                //     onEnd: () {
                //       setState(() {
                //         isLikeAnimating = false;
                //       });
                //     },
                //   ),
                // )
              ],
            ),
          ),
          widget.data!.img!.length > 1 ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildDots(),
          )
              : const SizedBox.shrink(),
          // Action section
          // Row(
          //   children: [
          //     LikeAnimation(
          //       isAnimating: isLiked,
          //       //widget.snap['likes'].contains(user!.uid),
          //       smallLike: isLiked,
          //       child: IconButton(
          //         onPressed: () async {
          //           setState(() {
          //             isLiked = !isLiked;
          //           });
          //           likeUnlike();
          //           // await FirestoreMethods().likePost(
          //           //   widget.snap['postId'],
          //           //   user!.uid,
          //           //   widget.snap['likes'],
          //           // );
          //         },
          //         icon: isLiked
          //             ? const Icon(
          //           Icons.favorite,
          //           color: Colors.red,
          //         )
          //             : const Icon(
          //           Icons.favorite_outline_outlined,
          //           color: primaryColor,
          //         ),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => CommentsScreen(
          //               postId: widget.data!.id,
          //               groupId: widget.data!.groupId,
          //
          //               // data: commentList[i],
          //             ),
          //           ),
          //         );
          //       },
          //       icon: const Icon(
          //         Icons.comment_outlined,
          //         color: primaryColor,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Share.share('Check out this awesome post on CTJan https://www.youtube.com');
          //       },
          //       icon: const Icon(
          //         Icons.send_outlined,
          //         color: primaryColor,
          //       ),
          //     ),
          //     Expanded(
          //       child: Align(
          //         alignment: Alignment.bottomRight,
          //         child: IconButton(
          //           onPressed: () {
          //             saveToWishlist();
          //           },
          //           icon: const Icon(
          //             Icons.bookmark_border,
          //             color: primaryColor,
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          //Description and comment count
        ],
      ),
    );
  }
}
