import 'package:crypt/crypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class supabaseController {
  final supabase = Supabase.instance.client;

  String hashpass(password){
    final c1 = Crypt.sha256(password, salt: 'abcdefghijklmnop');
    return(c1.toString());
  }

  Future<void> createAccount(String user, String email, String password) async {
    print("new user $user, $email, ${hashpass(password)}");
    await supabase.from('usuarios').insert({'nombre': user, 'contraseña': hashpass(password), 'email':email});
  }

  Future<bool> emailCheck(String email) async {
    final response = await supabase.from('usuarios').select();
    bool userExists = false;
    for (var element in response) {
      if (element["email"] == email) {
        userExists = true;
      }
    }
    if (userExists) {
      print("email in use");
      return (true);
    } else {
      print("email not in use");
      return (false);
    }
  }

  Future<bool> userCheck(String email, String password) async {
    final response = await supabase.from('usuarios').select();
    bool userExists = false;
    for (var element in response) {
      if (element["email"] == email && hashpass(element["password"]) == hashpass(password)) {
        userExists = true;
      }
    }
    if (userExists) {
      print("email in use");
      return (true);
    } else {
      print("email not in use");
      return (false);
    }
  }
}
