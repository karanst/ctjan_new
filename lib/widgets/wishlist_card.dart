import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/wishlist_model.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class WishlistCard extends StatefulWidget {
  final WishList? data;
  const WishlistCard({Key? key, this.data}) : super(key: key);

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {


  String? userid;

  removeFromWishList()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiPath.removeFromWishList));

    request.fields.addAll({
      'user_id': userid.toString(),
      'post_id':widget.data!.postId!.toString(),
    });

    print("this is send comment request ${request.fields.toString()}");

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
                          widget.data!.username.toString(),
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
                          children: ['Remove from wishlist']
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    removeFromWishList();
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
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ),
                )
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
                          height: 200.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          viewportFraction: 1.0,
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
                                    child: item.isEmpty
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
                        child: widget.data!.img!.isEmpty
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
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16,
          //   ),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // DefaultTextStyle(
          //       //   style: Theme.of(context).textTheme.subtitle2!.copyWith(
          //       //         fontWeight: FontWeight.bold,
          //       //       ),
          //       //   child: Text(
          //       //       widget.data!.totalLikes.toString() != '0' ||
          //       //               widget.data!.totalLikes.toString() != null
          //       //           ? '${widget.data!.totalLikes.toString()} likes'
          //       //           : '0 likes',
          //       //       //'${widget.data!.} likes',
          //       //       style: const TextStyle(
          //       //         color: primaryColor,
          //       //       )
          //       //       //Theme.of(context).textTheme.bodyText2,
          //       //       ),
          //       // ),
          //       // Container(
          //       //   width: double.infinity,
          //       //   padding: const EdgeInsets.only(
          //       //     top: 8,
          //       //   ),
          //       //   child: RichText(
          //       //       text: TextSpan(
          //       //           style: const TextStyle(color: primaryColor),
          //       //           children: [
          //       //         TextSpan(
          //       //           text: widget.data!.username.toString(),
          //       //           style: const TextStyle(
          //       //             fontWeight: FontWeight.bold,
          //       //             color: primaryColor,
          //       //           ),
          //       //         ),
          //       //         TextSpan(
          //       //             text: '  ${widget.data!.description.toString()}',
          //       //             style: const TextStyle(
          //       //               color: primaryColor,
          //       //             )),
          //       //       ])),
          //       // ),
          //       // InkWell(
          //       //   onTap: () {},
          //       //   child: Container(
          //       //     padding: const EdgeInsets.symmetric(vertical: 4),
          //       //     child: GestureDetector(
          //       //       onTap: () {
          //       //         //   Navigator.push(
          //       //         //   context,
          //       //         //   MaterialPageRoute(
          //       //         //     builder: (context) => CommentsScreen(
          //       //         //       snap: widget.snap,
          //       //         //     ),
          //       //         //   ),
          //       //         // );
          //       //       },
          //       //       child: commentLen > 0
          //       //           ? Text(
          //       //         'View all $commentLen comments',
          //       //         style: const TextStyle(
          //       //           fontSize: 16,
          //       //           color: secondaryColor,
          //       //         ),
          //       //       )
          //       //           : Container(),
          //       //     ),
          //       //   ),
          //       // ),
          //       Container(
          //         padding: const EdgeInsets.symmetric(vertical: 4),
          //         child: Text(
          //           widget.data!.date.toString(),
          //           // DateFormat.yMMMd().format(
          //           //   widget.data!.date.
          //           //  // widget.snap['datePublished'].toDate(),
          //           // ),
          //           style: const TextStyle(
          //             fontSize: 12,
          //             color: secondaryColor,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
