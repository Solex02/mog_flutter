import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class resendController {

  final serviceId = "service_44kc5k9";
  final templateId = "template_j44wvpp";
  final userId = "uA2IVwsGBllyasoZs";

  int verifycode = Random().nextInt(89999) + 10000;

  Future<void> postData(String userName, String userEmail) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'service_id': serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "user_name": userName,
            "user_email": userEmail,
            "user_subject":"subject",
            "message":verifycode
          }
        }));

    print(response.body);
  }

  getVerifyCode(){
    return(verifycode);
  }
}
