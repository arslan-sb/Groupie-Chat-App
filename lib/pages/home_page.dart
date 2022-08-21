import 'package:chat_app/helper/utility.dart';
import 'package:chat_app/pages/auth/login.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _auth = AuthService();
  String userName = "";
  String userEmail = "NOEMAIL";

  getUserData() async {
    await UtilityFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await UtilityFunctions.getUserEmail().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
        ],
        title: Text("Groups",
            style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 100.h),
          children: <Widget>[
            CircleAvatar(
              radius: 50.r,
              backgroundImage: const NetworkImage(
                "https://papik.pro/en/uploads/posts/2022-06/1655831806_1-papik-pro-p-cool-avatar-pictures-1.jpg",
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              userName,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30.h,
            ),
            Divider(
              height: 5.h,
            ),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: const Icon(Icons.group),
              onTap: () {
                nextScreenReplacement(context, HomePage());
              },
              title: Text(
                "Groups",
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
            ),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: const Icon(Icons.person),
              onTap: () {
                nextScreen(context, Profile());
              },
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
            ),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 127, 126, 126),
              ),
              onTap: () async {
                _auth.signOut();
                nextScreenReplacement(context, LoginPage());
              },
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Text(""),
          Text(userEmail),
          Text(userName),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (await _auth.signOut() == true) {
                    nextScreenReplacement(context, LoginPage());
                  } else {
                    print("NOT OUT");
                  }
                },
                child: Text("Sign out")),
          ),
        ],
      ),
    );
  }
}
