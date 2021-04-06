import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';


class ImageSelector extends StatefulWidget {
  final productImage;
  final provider;
  final double height;
  final bool circular;
  ImageSelector({this.productImage,this.provider,this.height,this.circular=false});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File fileImage;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () async {
          await widget.provider.pickImage(context);
          fileImage = widget.provider.image;
        },
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            ClipRRect(
              borderRadius: widget.circular ? BorderRadius.circular(100): BorderRadius.circular(0),
              child: Container(
                height: widget.height,
                width: MediaQuery.of(context).size.width,
                child:fileImage != null ? Image.file(
                  fileImage,
                  fit: BoxFit.cover,
                ) : CachedNetworkImage(
                  imageUrl: widget.productImage,
                  fit: BoxFit.cover,
                  placeholder: (context,url)=>Image.asset("images/imageloading.gif"),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              bottom: widget.circular ? 0 : -14,
              right: widget.circular ? 0 : -14,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
