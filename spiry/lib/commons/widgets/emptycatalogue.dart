import 'package:flutter/material.dart';

class EmptyCatalogueState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('images/notif.png'))),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Nothing to show\n Click the button below to add products blah blah blah blah blah blah",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.3),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/arrow.png'),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
