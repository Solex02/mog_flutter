import 'package:flutter/material.dart';
import 'package:mog_flutter/others/color_palette.dart';
import 'package:mog_flutter/pages/Principal.dart';
import 'package:mog_flutter/pages/singup.dart';
import 'package:mog_flutter/widgets/TextField.dart';
import 'package:mog_flutter/others/supabaseController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";

  final supabaseController supa = supabaseController();

  void createAccount() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SingUpPage()),
    );
  }

  Future<void> loginApp() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (await supa.userCheck(emailController.text, passwordController.text) ==
          true) {
        int user_id =
            await supa.getUserId(emailController.text, passwordController.text);
        print("entrar");
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainActivity(
                    user_id: user_id,
                  )),
        );

        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);

        setState(() {
          error = "";
        });
      } else {
        setState(() {
          error = "email or password incorrect";
        });
      }
    }
  }

  void autoLogin() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('email') != null &&
        prefs.getString('password') != null) {
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      if (email != null && password != null) {
        if (await supa.userCheck(
                emailController.text, passwordController.text) ==
            true) {
          int user_id = await supa.getUserId(
              emailController.text, passwordController.text);
          print("entrar");
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainActivity(
                      user_id: user_id,
                    )),
          );
        } else {
          print("fallo auto login");
        }
      }
    }
    print("auto login vacio");
  }

  @override
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          color: mcgpalette0.shade800,
          child: Column(
            children: [
              SizedBox(height: 200),
              Container(
                margin: EdgeInsets.only(right: 250, bottom: 30),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
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
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 20),
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
                        loginApp();
                      },
                      child: Text("Login")),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      createAccount();
                    },
                    child: Text(
                      "Create account",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
