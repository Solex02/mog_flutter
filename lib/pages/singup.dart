import 'package:flutter/material.dart';
import 'package:mog_flutter/others/resendController.dart';
import 'package:mog_flutter/pages/login.dart';
import 'package:mog_flutter/widgets/TextField.dart';
import 'package:mog_flutter/others/supabaseController.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmPasswordController = TextEditingController();

  final verificationController = TextEditingController();

  String error = "";

  final supabaseController supa = supabaseController();
  final resendController resend = resendController();

  final String apiUrl = 'https://api.resend.com/emails';
  final String apiKey = "re_HCsSoSaD_Gh5rBokiYX37qmB47XReHzCT";

  void createAccount() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      supa.createAccount(userNameController.text, emailController.text,
          passwordController.text);
      setState(() {
        error = supa.showError();
        supa.error = "";
      });
    }
    sendEmail();
  }

  void codeVerification(pin){
    if(pin == resend.getVerifyCode()){
      print("correct");
    }
    else{
      print("incorrect");
    }
  }

  void sendEmail() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      resend.postData(userNameController.text, emailController.text);
    }
  }

  void back() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children2 = [
      SizedBox(height: 200),
      Container(
        margin: EdgeInsets.only(right: 115, bottom: 30),
        child: Text(
          "Create Account",
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: CustomTextField(
            controller: userNameController,
            icon: Icon(Icons.person),
          )),
      Container(
          padding: EdgeInsets.only(left: 40, right: 40, top: 10),
          child: CustomTextField(
            controller: emailController,
            icon: Icon(Icons.email),
          )),
      Container(
          padding: EdgeInsets.only(left: 40, right: 40, top: 10),
          child: CustomPasswordField(
            controller: passwordController,
            icon: Icon(Icons.lock),
          )),
      Container(
          padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 20),
          child: CustomPasswordField(
            controller: comfirmPasswordController,
            icon: Icon(Icons.lock),
          )),
      Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 20),
        child: Text(
          error,
          style: TextStyle(color: Colors.red),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                //createAccount();
                showDialog(
                  //if set to true allow to close popup by tapping out of the popup
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Insert Verification code"),
                    content: OTPTextField(
                      length: 5,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        codeVerification(pin);
                      },
                    ),
                    actions: [
                     
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    elevation: 24,
                  ),
                );
              },
              child: Text("Create account")),
          SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {
              back();
            },
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      )
    ];
    return Scaffold(
      body: Container(
          color: Color.fromARGB(255, 22, 29, 77),
          child: Column(
            children: children2,
          )),
    );
  }
}
