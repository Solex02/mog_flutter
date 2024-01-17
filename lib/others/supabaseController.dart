class supabaseController {
  var encontrado = false;

  String error = "";

  final List usersList = [
    {'email': 'gambasa', 'password': "1234"},
    {'email': "123", 'password': "123"}
  ];

  bool login(String email, String password) {
    for (var element in usersList) {
      if (email == element["email"] && password == element["password"]) {
        encontrado = true;
        break;
      }
    }

    if (encontrado) {
      encontrado = false;
      return true;
    } else {
      return false;
    }
  }

  void createAccount(String user, String email, String password) {
    print(usersList.toString());
    for (var element in usersList) {
      if (email == element["email"]) {
        encontrado = true;
        break;
      }
    }

    if (encontrado) {
      error = "Este usuario ya existe";
      encontrado = false;
    } else {
      usersList.add({"email": email, "password": password});
    }
  }

  String showError() {
    return (error);
  }
}
