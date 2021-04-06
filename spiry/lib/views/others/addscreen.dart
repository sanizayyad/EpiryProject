import 'package:spiry/locator.dart';
import 'package:spiry/models/additemmodel.dart';
import 'package:spiry/services/navigation/navigationservice.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/views/bottomnav/bottomnavprovider.dart';
import 'package:flutter/material.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with TickerProviderStateMixin{
  AnimationController animationController;
  List items;
  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    Stream stream = locator<BottomNavBarProvider>().indexStreamController.stream;
    stream.listen((index){
      if(index == 2){
        setState(() {});
      }
    });
    items = AddItemModel.addItems();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: items.map((item){
                final int count = 7;
                int index = items.indexOf(item);
                final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: Interval((1 / count) * index, 1.0,curve: Curves.decelerate)));

                animationController.reset();
                animationController.forward();

                return Item(itemModel: items[index],animation: animation,animationController: animationController,);
              }).toList()
            ),
          ),
        );

  }
}

class Item extends StatelessWidget {
  final AddItemModel itemModel;
  final animation;
  final animationController;


  Item({this.itemModel,this.animation,this.animationController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context,child)=>FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 70 * (1-animation.value), 0.0),
              child: Align(
                child: Card(
                  color: itemModel.color,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  margin: EdgeInsets.symmetric(vertical: 14),
                  child: InkWell(
                    onTap: () async{
                      int index = 0;
                      var arguments;
                      if(itemModel.route == productAddEdit){
                        index = 0;
                        arguments = [null,locator<CatalogueProvider>().categoriesList];
                      }else if(itemModel.route == shoppingAddEdit){
                        index = 1;
                        arguments = [null];
                      }
                      locator<NavigationService>().pushNamed(itemModel.route, arguments: arguments).then((value){
                        locator<BottomNavBarProvider>().animTap(index);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                      child: Text(
                        itemModel.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8),
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
