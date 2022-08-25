import 'package:chat_app/helper/utility.dart';
import 'package:chat_app/pages/auth/login.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  void getUserLogInStatus() async {
    await UtilityFunctions.getLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLogInStatus();
  }

  @override
  Widget build(BuildContext context) {
    print(_isSignedIn);
    return StreamProvider<UtilityFunctions?>.value(
      initialData: null,
      value: AuthService().user,
      child: ScreenUtilInit(
        designSize: const Size(360, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Constants().primaryColor,
                scaffoldBackgroundColor: Colors.white),
            home: child,
          );
        },
        child: _isSignedIn ? const HomePage() : LoginPage(),
      ),
    );
  }
}
