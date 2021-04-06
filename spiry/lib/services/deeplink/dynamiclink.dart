import 'package:spiry/services/navigation/navigationservice.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../locator.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data =  await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          _handleDeepLink(dynamicLink);
        }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) async{
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      bool isJoinPantry = deepLink.pathSegments.contains('joinPantry');
      if(isJoinPantry){Map queries = deepLink.queryParametersAll;
//        if(locator<SelectPantryProvider>().isCurrentRoute){
////          await locator<SelectPantryProvider>().acceptPantryDialog(queries);
//        }else
//          await locator<NavigationService>().pushReplacementNameUntil(selectPantry,arguments: [queries]);
      }
    }
  }

  Future<String> createDynamicLink(String pathParameters,{String title, String description}) async {

    final DynamicLinkParameters parameters  = DynamicLinkParameters(
      uriPrefix: 'https://expiry.page.link',
      link: Uri.parse('https://expiry.page.link/$pathParameters'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.spiry',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.spiry',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title ?? "",
        description: description ?? "",
      ),
    );


    Uri url;
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;
    return url.toString();
  }
}