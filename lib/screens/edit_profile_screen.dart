import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ctjan/Helper/api_path.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/models/get_profile_model.dart';
import 'package:ctjan/resources/auth_methods.dart';
import 'package:ctjan/responsive/mobile_screen_layout.dart';
import 'package:ctjan/responsive/responsive_layout_screen.dart';
import 'package:ctjan/responsive/web_screen_layout.dart';
import 'package:ctjan/screens/login_screen.dart';
import 'package:ctjan/screens/send_otp.dart';
import 'package:ctjan/utils/custom_textfield.dart';
import 'package:ctjan/utils/utils.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<EditProfileScreen> {
   TextEditingController _emailController = TextEditingController();
   TextEditingController _mobileController = TextEditingController();
   TextEditingController _bioController = TextEditingController();
   TextEditingController _userNameController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();

  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  selectImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }



  void navigateToLoginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignInScreen()
        //LoginScreen(),
      ),
    );
  }

  String? profileImage;
  String? userid;

   updateUserProfile()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     userid = prefs.getString(TokenString.userid);
     var headers = {
       'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
     };
     var request = http.MultipartRequest('POST', Uri.parse(ApiPath.updateProfile));
     request.fields.addAll({
       'user_id': userid.toString(),
     'first_name': _userNameController.text.toString(),
       'mobile' : _mobileController.text.toString(),
       'email': _emailController.text.toString(),
     'about_us':_bioController.text.toString()

     });
     if(_profileImage != null) {
       request.files.add(await http.MultipartFile.fromPath(
           'profile_pic:', _profileImage!.path.toString()));
     }

     print("this is update profile request ${request.fields.toString()} and ${request.files.toString()}");
     request.headers.addAll(headers);
     http.StreamedResponse response = await request.send();
     if (response.statusCode == 200) {
       var finalResponse = await response.stream.bytesToString();
       final jsonResponse = json.decode(finalResponse);
       // final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
       if(jsonResponse['response_code'] == "1") {
         showSnackbar(jsonResponse['message'], context);
         setState(() {
           loading = false;
         });
         Navigator.pop(context, true);
       }else{
         showSnackbar(jsonResponse['message'], context);
         setState(() {
           loading = false;
         });
       }
       // print("select qualification here ${selectedQualification}");
     }
     else {
       print(response.reasonPhrase);
     }
   }

  getProfileData()async{
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
          profileImage = jsonResponse.userId!.profilePic.toString();
          _userNameController = TextEditingController(text: jsonResponse.userId!.username.toString());
          _emailController = TextEditingController(text: jsonResponse.userId!.email.toString());
          _mobileController = TextEditingController(text: jsonResponse.userId!.mobile.toString());

          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  // void signUpUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String response = await AuthMethods().signUpUser(
  //       email: _emailController.text,
  //       password: _mobileController.text,
  //       userName: _userNameController.text,
  //       bio: _bioController.text,
  //       file: _profileImage!);
  //   if (!mounted) return;
  //   showSnackbar(response, context);
  //   if (response == "User is Successfully Created") {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => const ResponsiveLayout(
  //           webScreenLayout: WebScreenLayout(),
  //           mobileScreenLayout: MobileScreenLayout(),
  //         ),
  //       ),
  //     );
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
        appBar : AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:  Icon(Icons.arrow_back_ios, color: mobileBackgroundColor,),
          ),
          backgroundColor: primaryClr,
          title: const Text('Edit Profile'),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible(
                  //   flex: 2,
                  //   child: Container(),
                  // ),
                  // SvgPicture.asset(
                  //   'assets/ic_instagram.svg',
                  //   color: primaryColor,
                  //   height: 64,
                  // ),
                  const SizedBox(
                    height: 64,
                  ),
                  Stack(
                    children: [
                      // profileImage != null || profileImage != '' ?
                      // CircleAvatar(
                      //   backgroundColor: Colors.grey,
                      //   backgroundImage: NetworkImage(
                      //     profileImage != '' || profileImage != null?
                      //     profileImage.toString()
                      //         : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
                      //   ),
                      //   radius: MediaQuery.of(context).size.width * 0.08,
                      // )
                      //     :
                      _profileImage != null ?
                  //         ? Container(
                  // width: 150,
                  //   height: 150,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(100)
                  //   ),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.all(Radius.circular(15)),
                  //     child: Image.file(File(_profileImage!.path.toString()),
                  //         fit: BoxFit.cover),
                  //   ),
                  //     )
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                              // radius: 64,
                              child: Container(
                                width: 150,
                                  height: 150,
                                  child: Image.file(File(_profileImage!.path), fit: BoxFit.fill,)))
                          : const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://180dc.org/wp-content/uploads/2016/08/default-profile.png',
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 80,
                        child: Container(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                            ),
                            color: blueColor,
                          ),
                          child: IconButton(
                            onPressed: selectImage,
                            splashColor: Colors.blue,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  CustomTextField(textEditingController: _userNameController, hintText: "Name", textInputType: TextInputType.text, title: "Name", ),
                  CustomTextField(textEditingController: _mobileController, hintText: "Contact No", textInputType: TextInputType.number, title: "Contact No.", maxLngth: 10,),
                  CustomTextField(textEditingController: _emailController, hintText: "Email", textInputType: TextInputType.emailAddress, title: "Email", ),
                  CustomTextField(textEditingController: _bioController, hintText: "About me", textInputType: TextInputType.text, title: "About me", ),

                  const SizedBox(
                    height: 24,
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width - 30,
                  //   child: NeoPopTiltedButton(
                  //     isFloating: true,
                  //     onTapUp: () {
                  //       setState(() {
                  //         loading = true;
                  //       });
                  //     updateUserProfile();
                  //       // AppRouter.pushNamed(Routes.LoginScreenRoute);
                  //     },
                  //     decoration:  NeoPopTiltedButtonDecoration(
                  //         color: primaryClr,
                  //         plunkColor: Colors.black,
                  //         shadowColor: Colors.grey,
                  //         showShimmer: true,
                  //         shimmerColor: Colors.white,
                  //         shimmerWidth: 10),
                  //     child:   Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 30.0,
                  //           vertical: 15,
                  //         ),
                  //         child: loading ? Center(
                  //           child: Container(
                  //             height: 30,
                  //             width: 30,
                  //             child: CircularProgressIndicator(
                  //               color: whiteColor,
                  //             ),
                  //           ),
                  //         ):
                  //         const  Text('Update Profile',
                  //             style: TextStyle(
                  //               color: mobileBackgroundColor,
                  //               //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                  //               fontWeight: FontWeight.bold,
                  //
                  //             )),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        loading = true;
                      });
                      updateUserProfile();
                      // if(mobileController.text.length != 10){
                      //   setState(() {
                      //     loading = false;
                      //   });
                      //   var snackBar = SnackBar(
                      //     backgroundColor: primaryClr,
                      //     content:  Text('Please enter valid mobile number'),
                      //   );
                      //
                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // }
                      // else{
                      //
                      //   mobileLogin(_value1.toString());
                      // }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 52,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: primaryClr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: loading ? Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ),
                      ): const Text("Update Profile", style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),),
                    ),
                  ),
                  // InkWell(
                  //   onTap: signUpUser,
                  //   child: Container(
                  //     width: double.infinity,
                  //     alignment: Alignment.center,
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     decoration: const ShapeDecoration(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(
                  //             4,
                  //           ),
                  //         ),
                  //       ),
                  //       color: blueColor,
                  //     ),
                  //     child: _isLoading
                  //         ? const Center(
                  //             child: CircularProgressIndicator(
                  //               color: primaryColor,
                  //             ),
                  //           )
                  //         : const Text("Sign Up"),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  // Flexible(
                  //   flex: 2,
                  //   child: Container(),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         vertical: 8,
                  //       ),
                  //       child: const Text("Already have an account? "),
                  //     ),
                  //     GestureDetector(
                  //       onTap: navigateToLoginScreen,
                  //       child: Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           vertical: 8,
                  //         ),
                  //         child: const Text(
                  //           "Sign In",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                  //textfield for email
                ],
              ),
            ),
          ),
        ));
  }
}
