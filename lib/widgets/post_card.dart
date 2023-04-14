import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/comments_model.dart';
import 'package:ctjan/models/like_status_model.dart';
import 'package:ctjan/models/posts_model.dart';
import 'package:ctjan/screens/comments_screen.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/providers/user_provider.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:ctjan/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class PostCard extends StatefulWidget {
  final PostList? data;
  const PostCard({Key? key, required this.data}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  User? user;
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getLikeStatus();
    // getComments();
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
  String? userid;
  List<Comments> commentList = [];
  String likeStats = '';
  bool isLiked = false;
  bool isDisliked = false;
  bool isShortlisted = false;

  likeUnlike(String? likeDislike) async {
    // String likeStatus = '';
    // if (isLiked == true) {
    //   setState(() {
    //     likeStatus = '1';
    //   });
    // } else {
    //   setState(() {
    //     likeStatus = '0';
    //   });
    // }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.likeUnlike));
    request.fields.addAll({
      'like_status': likeDislike.toString(),
      'user_id': userid.toString(),
      'post_id': widget.data!.id.toString(),
      'group_id': widget.data!.groupId.toString()
    });

    print("this is post like request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if (jsonResponse['response_code'] == '1') {
        print("like response message ${jsonResponse['message']}");

        // showSnackbar("${jsonResponse['message']}", context);
      } else {}
    } else {
      print(response.reasonPhrase);
    }
  }

  saveToWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiPath.addToWishlist));

    request.fields.addAll({
      'user_id': userid.toString(),
      'post_id': widget.data!.id!.toString(),
    });

    print("this is whishlist request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      //LikeStatusModel.fromJson(json.decode(finalResponse));
      print("this is response message ${jsonResponse['message']}");
      if (jsonResponse['response_code'] == '1') {
        showSnackbar(jsonResponse['message'], context);
      } else {
        showSnackbar(jsonResponse['message'], context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiPath.getPostLikes));

    request.fields.addAll({
      'user_id': userid.toString(),
      'post_id': widget.data!.id!.toString(),
    });

    print("this is like status request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = LikeStatusModel.fromJson(json.decode(finalResponse));

      if (jsonResponse.responseCode == '1') {
        setState(() {
          likeStats = jsonResponse.data![0].likeStatus.toString();
        });
        print("this is like status =====>>>  ${likeStats.toString()}");
        if (likeStats == "1") {
          setState(() {
            isLiked = true;
          });
        } else {
          setState(() {
            isLiked = false;
          });
        }
      } else {}
    } else {
      print(response.reasonPhrase);
    }
  }

  getComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getComments));
    request.fields.addAll({
      'post_id': widget.data!.id.toString(),
    });

    print("this is login request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = CommentsModel.fromJson(json.decode(finalResponse));
      if (jsonResponse.responseCode == '1') {
        setState(() {
          commentList = jsonResponse.data!;
        });

        // showSnackbar("${jsonResponse['message']}", context);
      } else {}
    } else {
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
                widget.data!.profilePic.toString() == imageUrl || widget.data!.profilePic.toString() ==''?
                   const  CircleAvatar(
                     radius: 20,
                      child: Icon(Icons.person, color: Colors.white,),
                    ) :
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.data!.profilePic.toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      bottom: 10
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.data!.fName.toString()} ${widget.data!.lName.toString()}',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3,),
                        Text(
                          widget.data!.postType.toString(),
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10
                          ),
                        ),
                        Text(
                          widget.data!.description.toString(),
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                             "${widget.data!.startDate.toString()}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 10
                              ),
                            ),
                            SizedBox(width: 30,),
                            Text(
                             "${widget.data!.endDate.toString()}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 10
                              ),
                            ),
                          ],
                        ),
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
                //                   onTap: () async {
                //                     // FirestoreMethods().deletePost(
                //                     //     widget.snap['postId']);
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Container(
                //                     padding: const EdgeInsets.symmetric(
                //                       vertical: 12,
                //                       horizontal: 16,
                //                     ),
                //                     child: Text(e),
                //                   ),
                //                 ),
                //               )
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
          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLiked = !isLiked;
              });
              likeUnlike('1');
              // await FirestoreMethods().likePost(
              //   widget.snap['postId'],
              //   user!.uid,
              //   widget.snap['likes'],
              // );
              setState(() {
                isLikeAnimating = true;
              });
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
                          height: 200.0,
                          enlargeCenterPage: false,
                          autoPlay: false,
                          aspectRatio: 1,
                          // 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: false,
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
                                    width: MediaQuery.of(context).size.width,
                                    child: item.isEmpty || widget.data!.img![0].toString() == imageUrl
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


                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 120,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeAnimation(
                isAnimating: isLiked,
                //widget.snap['likes'].contains(user!.uid),
                smallLike: isLiked,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    likeUnlike('1');
                    // await FirestoreMethods().likePost(
                    //   widget.snap['postId'],
                    //   user!.uid,
                    //   widget.snap['likes'],
                    // );
                  },
                  icon: isLiked
                      ? const Icon(
                          Icons.thumb_up,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.thumb_up_alt_outlined,
                          color: primaryColor,
                        ),
                ),
              ),
              widget.data!.postType == "Normal Post" ?
              SizedBox.shrink()
             : LikeAnimation(
                isAnimating: isDisliked,
                //widget.snap['likes'].contains(user!.uid),
                smallLike: isDisliked,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      isDisliked = !isDisliked;
                    });
                    likeUnlike('2');
                    // await FirestoreMethods().likePost(
                    //   widget.snap['postId'],
                    //   user!.uid,
                    //   widget.snap['likes'],
                    // );
                  },
                  icon: isDisliked
                      ? const Icon(
                    Icons.thumb_down,
                    color: Colors.red,
                  )
                      : const Icon(
                    Icons.thumb_down_alt_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.data!.id,
                        groupId: widget.data!.groupId,

                        // data: commentList[i],
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  Share.share(
                      'Check out this awesome post on CTJan https://www.youtube.com');
                },
                icon: const Icon(
                  Icons.share_rounded,
                  color: primaryColor,
                ),
              ),
              LikeAnimation(
                isAnimating: isShortlisted,
                //widget.snap['likes'].contains(user!.uid),
                smallLike: isShortlisted,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      isShortlisted = !isShortlisted;
                    });
                    saveToWishlist();
                    // await FirestoreMethods().likePost(
                    //   widget.snap['postId'],
                    //   user!.uid,
                    //   widget.snap['likes'],
                    // );
                  },
                  icon: isShortlisted
                      ? const Icon(
                    Icons.star,
                    color: Colors.red,
                  )
                      : const Icon(
                    Icons.star_border,
                    color: primaryColor,
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     saveToWishlist();
              //   },
              //   icon: const Icon(
              //     Icons.star_border_purple500_outlined,
              //     color: primaryColor,
              //   ),
              // )
            ],
          ),
          //Description and comment count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  child: Row(
                    children: [
                      Text(
                          widget.data!.totalLikes.toString() == '0' ||
                                  widget.data!.totalLikes.toString() == null
                              ? '0 likes'
                              : '${widget.data!.totalLikes.toString()} likes',
                          //'${widget.data!.} likes',
                          style: const TextStyle(
                            color: primaryColor,
                          )
                          //Theme.of(context).textTheme.bodyText2,
                          ),
                      SizedBox(width: 30,),
                      // Text(
                      //     widget.data!.totalDislikes.toString() == '0' ||
                      //             widget.data!.totalDislikes.toString() == null
                      //         ? '0 Dislikes'
                      //         : '${widget.data!.totalDislikes.toString()} Dislikes',
                      //     //'${widget.data!.} likes',
                      //     style: const TextStyle(
                      //       color: primaryColor,
                      //     )
                      //     //Theme.of(context).textTheme.bodyText2,
                      //     ),
                    ],
                  ),
                ),
                // Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.only(
                //       top: 8,
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           widget.data!.name.toString(),
                //           style: const TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: primaryColor,
                //           ),
                //         ),
                //         Text(widget.data!.description.toString(),
                //             style: const TextStyle(
                //               fontSize: 12,
                //               color: primaryColor,
                //             )),
                //       ],
                //     )),

                // RichText(
                //     text: TextSpan(
                //         style: const TextStyle(color: primaryColor),
                //         children: [
                //       TextSpan(
                //         text: widget.data!.name.toString(),
                //         style: const TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: primaryColor,
                //         ),
                //       ),
                //       TextSpan(
                //           text: '  ${widget.data!.description.toString()}',
                //           style: const TextStyle(
                //             color: primaryColor,
                //           )),
                //     ])),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onTap: () {
                        //   Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CommentsScreen(
                        //       snap: widget.snap,
                        //     ),
                        //   ),
                        // );
                      },
                      child: commentLen > 0
                          ? Text(
                              'View all $commentLen comments',
                              style: const TextStyle(
                                fontSize: 16,
                                color: secondaryColor,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 4),
                //   child: Text(
                //     widget.data!.date.toString(),
                //     // DateFormat.yMMMd().format(
                //     //   widget.data!.date.
                //     //  // widget.snap['datePublished'].toDate(),
                //     // ),
                //     style: const TextStyle(
                //       fontSize: 12,
                //       color: secondaryColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
