import 'package:spiry/locator.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:spiry/services/deeplink/dynamiclink.dart';
import 'package:spiry/services/firebase/abstracts/authenticationservice.dart';
import 'package:spiry/services/firebase/remotedata/firebaseauthentication.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';
import 'package:flutter/material.dart';

import 'screens/forgotpassword.dart';
import 'screens/register.dart';
import 'screens/signin.dart';


class AuthenticationProvider extends BaseProviderModel {
  final FirebaseAuthenticationService _firebaseAuthenticationService = locator<AuthenticationService>();
//  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
//  final PushNotificationService _pushNotificationService = locator<PushNotificationService>();

  List<Widget> allScreens = [SignInScreen(),RegisterScreen(),ForgotPasswordScreen()];
  List<Widget> initialScreens = [Container(),Container(),Container()];
  List<int> firstBuild = [];
  int screenIndex;
  String errorMessage = '';

  void changeScreen(index){
    errorMessage = '';
    if(!firstBuild.contains(index)){
      initialScreens.removeAt(index);
      initialScreens.insert(index, allScreens[index]);
      firstBuild.add(index);
    }
    screenIndex = index;
    setViewState(ViewState.Idle);
  }

  void clearFields(context,formKey,List<TextEditingController> controllers){
    FocusScope.of(context).requestFocus(FocusNode());
    formKey.currentState.reset();
    for(TextEditingController controller in controllers)
      controller.clear();
  }


  void startFireStoreDatabase(UserModel userModel){
    fireStoreService.startFireStore(userModel);
  }

  Future<void> handleStartUpLogic() async {
    UserModel user = await _firebaseAuthenticationService.currentUser();
    await Future.delayed(Duration(seconds: 1));
    if (user != null) {
       startFireStoreDatabase(user);
       await locator<SelectPantryProvider>().changePantry("Default Pantry");
       navigationService.pushReplacementName(homeScreen);
//       await _dynamicLinkService.handleDynamicLinks();
    } else {
       navigationService.pushReplacementName(authenticationScreen);
    }
  }

  void signIn(String email, String password) async {
    await _authenticate('signInWithEmail', null, email, password);
  }
  void signUpWithEmailAndPassword(String username, String email, String password) async {
    await _authenticate('signUpWithEmail', username, email, password);
  }
  void signInWithGoogle() async {
    await _authenticate('signInWithGoogle', null, null, null);
  }

  Future<void> _authenticate(String type, String username, String email, String password) async {
    errorMessage = '';
    setViewState(ViewState.Busy);
    try {
      //authenticating
      UserModel user;
      if (type == 'signUpWithEmail') {
        user = await _firebaseAuthenticationService.createUserWithEmailAndPassword(username, email, password);
      } else if (type == 'signInWithEmail') {
        user = await _firebaseAuthenticationService.signInWithEmailAndPassword(email, password);
      } else if (type == 'signInWithGoogle') {
        user = await _firebaseAuthenticationService.signInWithGoogle();
      }
      //if authenticating is successful start database
      if (user != null) {
        startFireStoreDatabase(user);
         if(user.isNewUser){
          await fireStoreService.addUser(user);
         }
         await locator<SelectPantryProvider>().changePantry("Default Pantry");
         navigationService.pushReplacementName(homeScreen);
//         await _dynamicLinkService.handleDynamicLinks();
      }
      setViewState(ViewState.Idle);
    } catch (e) {
      setViewState(ViewState.Idle);
      errorMessage = e.message.toString();
      print(errorMessage);
    }
  }

  Future<void> recoverPassword(String email) async {
    errorMessage = '';
    setViewState(ViewState.Busy);
    try {
      await _firebaseAuthenticationService.sendPasswordResetEmail(email);
      setViewState(ViewState.Success);
    } catch (e) {
      setViewState(ViewState.Idle);
      errorMessage = e.message.toString();
    }
  }

  Future<void> signOut() async {
    try {
      locator.resetLazySingleton<SelectPantryProvider>();
      await _firebaseAuthenticationService.signOut();
      navigationService.pushReplacementName(splashScreen);
    } catch (e) {
      print(e.message);
    }
  }
  Future<void> deleteAccount() async{
    try {
      locator<CatalogueProvider>().userDeleted = true;
      await fireStoreService.removeUser();
      await _firebaseAuthenticationService.deleteUser();
      await signOut();
    }  catch (e) {
      print('error happening');
      print(e.message);
    }
  }
}
