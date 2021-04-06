import 'package:spiry/locator.dart';
import 'package:spiry/models/bottomnavitem.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottomnavprovider.dart';

class CustomBottomNav extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CustomBottomNav> with TickerProviderStateMixin {
  Animation<double> _animation;
  Animation<double> _scaleAnimation;
  int prevInd = 0;

  @override
  void initState() {
    locator<BottomNavBarProvider>().translateAnimationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(locator<BottomNavBarProvider>().translateAnimationController)
      ..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(locator<BottomNavBarProvider>().translateAnimationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  @override
  void dispose() {
//    locator<BottomNavBarProvider>().disposeState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<BottomNavBarProvider>(
        builder: (_, bottomNavProvider, child) => Container(
          color: Colors.white,
          child: Container(
            height: 56,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, 57 * _animation.value ),
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(bottom: 12,top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                         BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6.0,
                         spreadRadius: .01,
                          offset:  Offset(0.0, -5.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: bottomNavProvider.screensInfo.map((screen) {
                        var currentIndex = bottomNavProvider.screensInfo.indexOf(screen);
                        bool active = currentIndex == bottomNavProvider.screenIndex;
                        BottomNavItem item = bottomNavProvider.screensInfo[currentIndex];
                        return Expanded(
                          child: _BuildItem(
                            active: active,
                            item: item,
                            func: () {
                              if(currentIndex == 2)
                                bottomNavProvider.animTap(prevInd);
                              else{
                                prevInd = currentIndex;
                                bottomNavProvider.changeScreen(currentIndex);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Positioned(
                  top: -15,
                  left: width * 0.5 - 25,
                  right: width * 0.5 - 25,
                  child: Transform.rotate(
                    angle: 0.785398 * _animation.value,
                    child: Transform.scale(
                      scale:_scaleAnimation.value,
                      child: Container(
                        height: 40,
                        child: FloatingActionButton(
                          elevation: 1,
                          backgroundColor: primaryColor,
                          onPressed: () {
                            prevInd = bottomNavProvider.screenIndex != 2 ? bottomNavProvider.screenIndex : prevInd;
                            bottomNavProvider.animTap(prevInd);
                          },
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _BuildItem extends StatelessWidget {
  final BottomNavItem item;
  final bool active;
  final Function func;

  _BuildItem({this.item, this.active = false, this.func});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        func();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.iconData,
            size: 20,
            color: active ? primaryColor : Colors.grey,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            item.title,
            style: TextStyle(
              color: active ? primaryColor: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
