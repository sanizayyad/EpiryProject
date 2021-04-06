import 'package:flutter/material.dart';

class SuccessProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
          elevation: 4,
          child: Container(
              height: MediaQuery.of(context).size.height*0.35,
              width: MediaQuery.of(context).size.height *0.4,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.check_circle, color: Colors.green,size: 180,),
                  Text("SUCCESS")
                ],
              )
          ),
        )
    );
  }
}
