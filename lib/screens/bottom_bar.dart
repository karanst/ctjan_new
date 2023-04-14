import 'dart:io';

import 'package:ctjan/screens/add_post.dart';
import 'package:ctjan/screens/home_screen.dart';
import 'package:ctjan/screens/people_screen.dart';
import 'package:ctjan/screens/places_screen.dart';
import 'package:ctjan/screens/viewallgroupscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/screens/add_post_screen.dart';
import 'package:ctjan/screens/group_screen.dart';
import 'package:ctjan/screens/feed_screen.dart';
import 'package:ctjan/screens/profile_screen.dart';
import 'package:ctjan/screens/wishlist.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBar extends StatefulWidget {
  final int? index;
  final String? groupJoined;
  const BottomBar({Key? key, this.index, this.groupJoined}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentIndex = 0;
  var _selBottom = 0;
  String? bookID;

  @override
  void initState() {
    // getUserDataFromPrefs();
    super.initState();
    // getUserDataFromPrefs();
    if (widget.index != null) {
      setState(() {
        _currentIndex = widget.index!;
        currentIndex = widget.index!;
      });
    }
    // setState(() {
    //   userId = preferences.getString(TokenString.userid);
    //   isGroupJoined = preferences.getString(TokenString.groupJoined);
    // });
  }

  String? userId ;
  String? isGroupJoined;


  // getUserDataFromPrefs() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //  setState(() {
  //    userId = preferences.getString(TokenString.userid);
  //    isGroupJoined = preferences.getString(TokenString.groupJoined);
  //  });
  // }

  int currentIndex = 0;
  bool isLoading = false;

  Widget _getBottomNavigator() {
    return Material(
      // color: AppColor().colorTextSecondary(),
      //elevation: 2,
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 50,
        buttonBackgroundColor: primaryClr,
        backgroundColor: const Color(0xffe0e0e0),
        // backgroundColor: Color(0xfff4f4f4),
        items: <Widget>[
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.home_filled,
                color: _currentIndex == 0 ? whiteColor : blackClr,
              )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 0 ?
            //       'images/icons/home_fill.png'
            //           : 'images/icons/home_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.place,
                color: _currentIndex == 1 ? whiteColor : blackClr,
              )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 1?
            //       'images/icons/product_fill.png'
            //           : 'images/icons/product_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.people_alt_outlined,
                color: _currentIndex == 2 ? whiteColor : blackClr,
              )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 1?
            //       'images/icons/product_fill.png'
            //           : 'images/icons/product_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),
          // Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: Icon(
          //       _currentIndex == 2 ?
          //       Icons.favorite
          //           : Icons.favorite_border,
          //       color: _currentIndex == 2 ? whiteColor : blackClr,
          //     )
          //   // ImageIcon(
          //   //   AssetImage(
          //   //       _currentIndex == 2?
          //   //       'images/icons/booking_fill.png'
          //   //           : 'images/icons/booking_fill.png'),
          //   //   color: AppColor().colorPrimary(),
          //   // ),
          // ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              // _currentIndex == 3 ?
              Icons.person,
              // : Icons.person_3_outlined,
              color: _currentIndex == 3 ? whiteColor : blackClr,
            ),
            // child:
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 3 ?
            //       'images/icons/profile_fill.png'
            //           : 'images/icons/profile_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),

        ],
        onTap: (index) {
          print("current index here ${index}");
          setState(() {
            _currentIndex = index;
            _selBottom = _currentIndex;
            print("sel bottom ${_selBottom}");
            //_pageController.jumpToPage(index);
          });
          // if (currentIndex == 3 ) {
          // if (CUR_USERID == null) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Login(),
          //     ),
          //   );
          //   // _pageController.jumpToPage(2);
          // }
          // }
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    List<dynamic> _handlePages = [
       const GroupScreen(),
      // const AddPosts(),
      const ViewallGroup(),
      const PeopleScreen(),
      //AddPostScreen(),
      const ProfileScreen(),
    ];
    // [
    //   HomeScreen(bookingId: widget.bookingId,), ProductsServicesScreen(),  ManageService(index: 0, isIcon: false,), Profile() ];
    return
      WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Exit"),
                    content: const Text("Are you sure you want to exit?"),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primaryClr
                        ),
                        child: const Text("YES"),
                        onPressed: () {

                          exit(0);
                          // SystemNavigator.pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primaryClr
                        ),
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
            return true;
          },
          child: Scaffold(
              body:
              //widget.groupJoined == "0" ?
              _handlePages[_currentIndex],
                //  :  _handlePages1[_currentIndex],
              bottomNavigationBar: _getBottomNavigator()
          )
      );
  }
}