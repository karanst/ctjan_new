import 'package:ctjan/models/wishlist_model.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:flutter/material.dart';

class WishlistCard extends StatefulWidget {
  final WishList? data;
  const WishlistCard({Key? key, this.data}) : super(key: key);

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      color: Colors.white,
      elevation: 0,
      child: Container(
        color: Colors.white,
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            widget.data!.img.toString() == '' || widget.data!.img == null ?
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('assets/placeholder.png')
                  )
              ),
            )
            : Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(widget.data!.img.toString())
                )
              ),
            ),
         Padding(
           padding: const EdgeInsets.only(top: 20.0),
           child: Text(widget.data!.name.toString(), style: const TextStyle(fontWeight: FontWeight.w600, color: primaryColor),),
         )
            // Header Section
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 4,
            //     horizontal: 16,
            //   ).copyWith(right: 0),
            //   child: Row(
            //     children: [
            //       CircleAvatar(
            //         radius: 16,
            //         backgroundImage: NetworkImage(
            //           widget.data!.img.toString(),
            //         ),
            //       ),
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.only(
            //             left: 8,
            //           ),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 widget.data!.name.toString(),
            //                 style: const TextStyle(
            //                   color: primaryColor,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //
            //       // IconButton(
            //       //   onPressed: () {
            //       //     showDialog(
            //       //       context: context,
            //       //       builder: (context) => Dialog(
            //       //         child: ListView(
            //       //           padding: const EdgeInsets.symmetric(
            //       //             vertical: 16,
            //       //           ),
            //       //           shrinkWrap: true,
            //       //           children: ['Delete']
            //       //               .map(
            //       //                 (e) => InkWell(
            //       //                   onTap: () async {
            //       //                     // FirestoreMethods().deletePost(
            //       //                     //     widget.snap['postId']);
            //       //                     Navigator.of(context).pop();
            //       //                   },
            //       //                   child: Container(
            //       //                     padding: const EdgeInsets.symmetric(
            //       //                       vertical: 12,
            //       //                       horizontal: 16,
            //       //                     ),
            //       //                     child: Text(e),
            //       //                   ),
            //       //                 ),
            //       //               )
            //       //               .toList(),
            //       //         ),
            //       //       ),
            //       //     );
            //       //   },
            //       //   icon: const Icon(
            //       //     Icons.more_vert,
            //       //     color: primaryColor,
            //       //   ),
            //       // )
            //
            //     ],
            //   ),
            // ),
            //Image Section
            // GestureDetector(
            //   onDoubleTap: () async {
            //     setState(() {
            //       isLiked = !isLiked;
            //     });
            //     likeUnlike();
            //     // await FirestoreMethods().likePost(
            //     //   widget.snap['postId'],
            //     //   user!.uid,
            //     //   widget.snap['likes'],
            //     // );
            //     setState(() {
            //       isLikeAnimating = true;
            //     });
            //   },
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.35,
            //         width: double.infinity,
            //         child: Image.network(
            //           widget.data!.img.toString(),
            //           // widget.snap['postUrl'],
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       AnimatedOpacity(
            //         duration: const Duration(milliseconds: 200),
            //         opacity: isLikeAnimating ? 1 : 0,
            //         child: LikeAnimation(
            //           isAnimating: isLikeAnimating,
            //           duration: const Duration(
            //             milliseconds: 400,
            //           ),
            //           child: const Icon(
            //             Icons.favorite,
            //             color: primaryColor,
            //             size: 120,
            //           ),
            //           onEnd: () {
            //             setState(() {
            //               isLikeAnimating = false;
            //             });
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // // Action section
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
            // //Description and comment count
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       DefaultTextStyle(
            //         style: Theme.of(context).textTheme.subtitle2!.copyWith(
            //           fontWeight: FontWeight.bold,
            //         ),
            //         child: Text('${widget.data!.totalLike} likes',
            //             style: const TextStyle(
            //               color: primaryColor,
            //             )
            //           //Theme.of(context).textTheme.bodyText2,
            //         ),
            //       ),
            //       Container(
            //         width: double.infinity,
            //         padding: const EdgeInsets.only(
            //           top: 8,
            //         ),
            //         child: RichText(
            //             text: TextSpan(
            //                 style: const TextStyle(color: primaryColor),
            //                 children: [
            //                   TextSpan(
            //                     text: widget.data!.name.toString(),
            //                     style: const TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       color: primaryColor,
            //                     ),
            //                   ),
            //                   TextSpan(
            //                       text: '  ${widget.data!.description.toString()}',
            //                       style: const TextStyle(
            //                         color: primaryColor,
            //                       )),
            //                 ])),
            //       ),
            //       InkWell(
            //         onTap: () {},
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 4),
            //           child: GestureDetector(
            //             onTap: () {
            //               //   Navigator.push(
            //               //   context,
            //               //   MaterialPageRoute(
            //               //     builder: (context) => CommentsScreen(
            //               //       snap: widget.snap,
            //               //     ),
            //               //   ),
            //               // );
            //             },
            //             child: commentLen > 0
            //                 ? Text(
            //               'View all $commentLen comments',
            //               style: const TextStyle(
            //                 fontSize: 16,
            //                 color: secondaryColor,
            //               ),
            //             )
            //                 : Container(),
            //           ),
            //         ),
            //       ),
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
      )
    );
  }
}
