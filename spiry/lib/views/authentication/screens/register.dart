import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/errormessage.dart';
import 'package:spiry/commons/widgets/haveaccountbutton.dart';
import 'package:spiry/commons/widgets/logo.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authenticationprovider.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthenticationProvider>(
        builder: (_,authenticationProvider,child)=>Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              GestureDetector(
                onTap: () {
//                  authenticationProvider.switchAuthenticationScreen(signInScreen);
                  authenticationProvider.changeScreen(0);
                  authenticationProvider.clearFields(context, _formKey, [_username,_email,_password]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back_ios),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Logo(),
              //username
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Username",
                        icon: Icon(Icons.person),
                      ),
                      validator: usernameValidator,
                    ),
                  ),
                ),
              ),
              //email field
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                  ? BusyLoading(type: 'green',)
                  : SignInRegisterButton(
                type: 'Register',
                callBackFunction: () {
                  if (_formKey.currentState.validate()) {
                     authenticationProvider.signUpWithEmailAndPassword(_username.text, _email.text, _password.text);
                     authenticationProvider.clearFields(context, _formKey, [_username,_email,_password]);
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              HaveAccount(
                message: "Already have an acoount ? ",
                navigateTo: signInScreen,
                function: (){
                  authenticationProvider.clearFields(context, _formKey, [_username,_email,_password]);
                },
              ),
            ],
          ),
        ),
      ),)
    );
  }
}
