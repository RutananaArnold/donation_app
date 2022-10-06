import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musayi/screens/userscreens/all_requests.dart';
import 'package:musayi/screens/userscreens/home.dart';
import 'package:musayi/screens/userscreens/profile.dart';
import 'package:musayi/widgets/drawer_tile.dart';

class Index extends StatefulWidget {
  int currentTabIndex;
  Index({Key? key, this.currentTabIndex = 0}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<ScaffoldState> drawerkey = GlobalKey();
  void openCloseDrawer() {
    drawerkey.currentState!.isDrawerOpen
        ? Navigator.pop(context)
        : drawerkey.currentState?.openDrawer();
  }

  List<String> tabTitles = ['Recent Donors', 'All Requests', 'Profile'];

  List<Widget> tabs = [
    const Home(),
    const Requests(),
    const Profile(),
  ];
  FirebaseAuth signedin = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerkey,
      appBar: AppBar(
          centerTitle: true, title: Text(tabTitles[widget.currentTabIndex])),
      drawer: SizedBox(
        width: 180,
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: const CircleAvatar(),
                  accountName: Text("${signedin.currentUser!.displayName}"),
                  accountEmail: Text("${signedin.currentUser!.email}")),
              DrawerListTile(
                  title: "home",
                  svgSrc: Icons.home,
                  press: () {
                    setState(() {
                      widget.currentTabIndex = 0;
                    });
                    openCloseDrawer();
                  }),
              DrawerListTile(
                  title: "Track Requests",
                  svgSrc: Icons.track_changes,
                  press: () {
                    setState(() {
                      widget.currentTabIndex = 1;
                    });
                    openCloseDrawer();
                  }),
              DrawerListTile(
                  title: "Profile",
                  svgSrc: Icons.person,
                  press: () {
                    setState(() {
                      widget.currentTabIndex = 2;
                    });
                    openCloseDrawer();
                  })
            ],
          ),
        ),
      ),
      body: tabs[widget.currentTabIndex],
    );
  }
}
