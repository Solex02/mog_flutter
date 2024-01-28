import 'package:flutter/material.dart';
import 'package:mog_flutter/others/resendController.dart';
import 'package:mog_flutter/pages/login.dart';
import 'package:mog_flutter/widgets/TextField.dart';
import 'package:mog_flutter/others/supabaseController.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  
  //Controladores para coger el interior de los text Fields
  final emailController = TextEditingController(); 
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmPasswordController = TextEditingController();

  final verificationController = TextEditingController();

  //Iniciar el cliente de supabase
  final supabase = Supabase.instance.client;

  
  //Linea de texto vacia para poder mostrarle errores al usuario
  String error = "";


  //Referencia del codigo de supabaseController y resendController
  final supabaseController supa = supabaseController();
  final resendController resend = resendController();

  //Funcion que verifica si el email ya esta en uso, si existe da un error si no existe envia un email de verificacion y enseña un dialog
  Future<void> doesEmailExist() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      if (await supa.emailCheck(emailController.text) ==
          false) { //si el email no existe
        sendEmail(); //enviar email con codigo de verificacion
        buildDialog(); //enseñar alert dialog
      } else {
        setState(() {
          error = "This email is already in use try to log in instead";
        });
      }
    }
  }

void sendEmail() {
  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      userNameController.text.isNotEmpty) {
    int verificationCode = resend.generateVerifyCode();
    resend.postData(userNameController.text, emailController.text, verificationCode);
  }
}

  //funcion pora construir el alert dialog
  void buildDialog() {
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
            Navigator.of(context).pop();
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
  }


  // funcion para verificar que el codigo que se le ha enviado al usuairio por email es correcto
  void codeVerification(String pin) {
  print("Entered PIN: $pin");
  int storedVerificationCode = resend.getVerifyCode();

  if (pin != null && storedVerificationCode != null && pin.toString() == storedVerificationCode.toString()) {
    print("Verification code correct");
    supa.createAccount(userNameController.text, emailController.text, passwordController.text);
  } else {
    print("Verification code incorrect");
    print(storedVerificationCode);
    print(pin.toString());
  }
}



  //funcion para enviar email
  

  //boton de back
  void back() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Color.fromARGB(255, 22, 29, 77),
          child: Column(
            children: [
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
          ElevatedButton(onPressed: () {doesEmailExist(); }, child: Text("Create account")),
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
    ],
          )),)
    );
  }
}
