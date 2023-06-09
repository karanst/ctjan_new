// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ctjan/resources/auth_methods.dart';
// import 'package:ctjan/screens/signup.dart';
// import 'package:ctjan/screens/edit_profile_screen.dart';
// import 'package:ctjan/screens/edit_profile_screen.dart';
// import 'package:ctjan/utils/colors.dart';
// import 'package:ctjan/utils/global_variables.dart';
// import 'package:ctjan/widgets/text_field_input.dart';
//
// import '../responsive/mobile_screen_layout.dart';
// import '../responsive/responsive_layout_screen.dart';
// import '../responsive/web_screen_layout.dart';
// import '../utils/utils.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//   }
//
//   void loginUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     String response = await AuthMethods().loginUser(
//         email: _emailController.text, password: _passwordController.text);
//     if (!mounted) return;
//     showSnackbar(response, context);
//     if (response == "Signed In Successfully") {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const ResponsiveLayout(
//             webScreenLayout: WebScreenLayout(),
//             mobileScreenLayout: MobileScreenLayout(),
//           ),
//         ),
//       );
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   void navigateToSignUpScreen() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const SignUp(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//       child: Container(
//         padding: MediaQuery.of(context).size.width > webScreenSize
//             ? EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width / 3)
//             : const EdgeInsets.symmetric(horizontal: 32),
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Flexible(
//               flex: 2,
//               child: Container(),
//             ),
//             SvgPicture.asset(
//               'assets/ic_instagram.svg',
//               color: primaryColor,
//               height: 64,
//             ),
//             const SizedBox(
//               height: 64,
//             ),
//             TextFieldInput(
//               textEditingController: _emailController,
//               hintText: "Enter your email",
//               textInputType: TextInputType.emailAddress,
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             TextFieldInput(
//               textEditingController: _passwordController,
//               hintText: "Enter your passoword",
//               textInputType: TextInputType.text,
//               isPassword: true,
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             InkWell(
//               onTap: loginUser,
//               child: Container(
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: const ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(
//                           4,
//                         ),
//                       ),
//                     ),
//                     color: blueColor),
//                 child: _isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: primaryColor,
//                         ),
//                       )
//                     : const Text("Login"),
//               ),
//             ),
//             const SizedBox(
//               height: 12,
//             ),
//             Flexible(
//               flex: 2,
//               child: Container(),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                   ),
//                   child: const Text("Don't have an account? "),
//                 ),
//                 GestureDetector(
//                   onTap: navigateToSignUpScreen,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                     ),
//                     child: const Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//             //textfield for email
//           ],
//         ),
//       ),
//     ));
//   }
// }
