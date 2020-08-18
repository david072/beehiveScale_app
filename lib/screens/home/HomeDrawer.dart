import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/home/home.dart';
import 'package:stockwaage_app/screens/login/auth.dart';
import 'package:stockwaage_app/screens/login/login.dart';

class HomeDrawer extends StatefulWidget {
  final FirebaseUser user;

  HomeDrawer({@required this.user});

  static void toggle() {
    _HomeDrawerState.instance.toggleCollapsed();
  }

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  static bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration dur = const Duration(milliseconds: 300);
  double padding = 0;

  static _HomeDrawerState instance;

  void updatePadding() => setState(() {
    padding = isCollapsed ? 0 : 11.3;
  });

  @override
  void initState() {
    setState(() {
      instance = this;
    });
    Home.getBeehiveScaleIIs(widget.user);
    super.initState();
  }

  void toggleCollapsed() {
    print('toggling...');
    setState(() {
      isCollapsed = !isCollapsed;
    });
    updatePadding();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: Color(0xffd8d8d8),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 130),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      widget.user == null || widget.user.photoUrl == null
                          ? AssetImage(
                              'assets/icons/emptyProfileIcon.png',
                            )
                          : NetworkImage(widget.user.photoUrl),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12),
                  height: 24,
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.user == null ? '/User name here/' : widget.user.displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'segoe ui',
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NavigationItem(
                    name: 'Home',
                    icon: Icons.home,
                  ),
                  //Text('Home'),
                  SizedBox(
                    height: 20,
                  ),
                  NavigationItem(
                    name: 'Stockwaage\nhinzufügen',
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: NavigationItem(
                name: 'Log out',
                icon: Icons.exit_to_app,
                textColor: Colors.red,
                onTap: () => {
                  Authentication().signOut(),
                  toggleCollapsed(),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
                },
              ),
            ),
          ),
          AnimatedPositioned(
            top: isCollapsed ? 0 : 0.2 * screenHeight,
            bottom: isCollapsed ? 0 : 0.2 * screenWidth,
            left: isCollapsed ? 0 : 0.6 * screenWidth,
            right: isCollapsed ? 0 : -0.4 * screenWidth,
            duration: dur,
            child: GestureDetector(
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                elevation: 8,
                color: Color(0xffffffff),
                child: Container(
                  padding: EdgeInsets.only(
                      top: padding, left: padding, bottom: padding),
                  child: Home.getHomePage(context),
                ),
              ),
              onTap: () => {
                setState(() {
                  isCollapsed = true;
                }),
                updatePadding()
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color textColor;
  final Function onTap;

  NavigationItem({@required this.icon, @required this.name, this.textColor = const Color(0xff000000), this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 32,
            color: Color(0xff5e5e5e),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'bahnschrift',
              color: textColor
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
