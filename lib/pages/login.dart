import 'package:flutter/material.dart';
import 'package:mog_flutter/pages/singup.dart';
import 'package:mog_flutter/widgets/TextField.dart';
import 'package:mog_flutter/others/supabaseController.dart';

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
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (await supa.userCheck(emailController.text, passwordController.text) == true) {
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
      body: SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(
          color: Color.fromARGB(255, 22, 29, 77),
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
                  padding:
                      EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 20),
                  child: CustomTextField(
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
          )),)
    );
  }
}
