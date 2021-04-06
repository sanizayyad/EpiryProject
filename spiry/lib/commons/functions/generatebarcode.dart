import 'dart:math';

import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';

import '../../locator.dart';

String barcodeGen(){
  int min = 100000;
  var rand = min +  Random().nextInt(900000 - min);
  return "${rand}GEN";
}


Future<String> generateBarcode() async{
  var products =  locator<CatalogueProvider>().products;
  var existingBarcodes = products.map((prod)=>prod.barcode).toList();
  String recursiveCheck(){
    var barcode = barcodeGen();
    if(!existingBarcodes.contains(barcode)){
      return barcode;
    }
    return recursiveCheck();
  }

  return recursiveCheck();
}
