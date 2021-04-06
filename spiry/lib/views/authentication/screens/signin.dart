import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/errormessage.dart';
import 'package:spiry/commons/widgets/haveaccountbutton.dart';
import 'package:spiry/commons/widgets/logo.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../authenticationprovider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthenticationProvider>(
        builder: (_,authenticationProvider,child)=>Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Logo(),
              //email field
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        icon: Icon(Icons.alternate_email),
                      ),
                      validator: emailValidator,
                    ),
                  ),
                ),
              ),
              //password field
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        icon: Icon(Icons.lock_outline),
                      ),
                      validator: passwordValidator,
                    ),
                  ),
                ),
              ),
              ErrorMessage(
                errorMessage: authenticationProvider.errorMessage,
              ),
              //submit button
              authenticationProvider.viewState == ViewState.Busy
                  ? BusyLoading(type: 'orange')
                  : Column(
                children: <Widget>[
                  SignInRegisterButton(type: 'Sign In', callBackFunction: (){
                    if (_formKey.currentState.validate()) {
                       authenticationProvider.signIn(_email.text, _password.text);
                       authenticationProvider.clearFields(context, _formKey, [_email,_password]);
                    }},),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      InkWell(
                        onTap: () {
                          authenticationProvider.changeScreen(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: Text(
                            "Forgot password ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  HorDivider(),
                  GoogleButton(),
                ],
              ),
              HaveAccount(
                message: "Don't have an account ? ",
                navigateTo: registerScreen,
                function: (){
                  authenticationProvider.clearFields(context, _formKey, [_email,_password]);
                },
              )
            ],
          ),
        ),
      ),)
    );
  }
}

class HorDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: screenWidth * 0.15, vertical: 14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'or',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        color: greenColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(0),
        onPressed: ()  {
           locator<AuthenticationProvider>().signInWithGoogle();
        },
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 45,
              decoration: BoxDecoration(
                color: greenColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Icon(
                FontAwesomeIcons.google,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                'Sign In with Google',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 0.7,
                    wordSpacing: 1,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
