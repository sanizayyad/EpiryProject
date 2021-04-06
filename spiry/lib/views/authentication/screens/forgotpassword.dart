import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/errormessage.dart';
import 'package:spiry/commons/widgets/haveaccountbutton.dart';
import 'package:spiry/commons/widgets/logo.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/consttexts.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authenticationprovider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();


  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Widget decideView(auth) {
    if (auth.viewState == ViewState.Busy) return busyView();
    if (auth.viewState == ViewState.Idle) return formView(auth);
    return successView();
  }

  Widget busyView() {
    return Container(height: 230, child: Center(child: BusyLoading(type: 'orange',)));
  }

  Widget formView(auth) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            forgotPasswordTitle,
            style:
            TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        //email field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
        ErrorMessage(
          errorMessage: auth.errorMessage,
        ),
        //submit button
        SignInRegisterButton(
          type: 'Recover Password',
          callBackFunction: () {
            if (_formKey.currentState.validate()) {
               auth.recoverPassword(_email.text);
               auth.clearFields(context, _formKey, [_email]);
            }
          },
        ),
      ],
    );
  }

  Widget successView() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              forgotPasswordSuccess,
              style:
              TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/emailSent.png'),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthenticationProvider>(
        builder: (_,authenticationProvider,child)=>Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.03),
            GestureDetector(
              onTap: () {
//                authenticationProvider.switchAuthenticationScreen(signInScreen);
                authenticationProvider.changeScreen(0);
                authenticationProvider.clearFields(context, _formKey, [_email]);

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.arrow_back_ios),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Back",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Logo(),
            decideView(authenticationProvider),
            SizedBox(
              height: 20,
            ),
            HaveAccount(
              message: "Already have an account ? ",
              navigateTo: signInScreen,
              function: (){
                authenticationProvider.clearFields(context, _formKey, [_email]);
              }
            ),
          ],
        )),
      ),
    );
  }
}


