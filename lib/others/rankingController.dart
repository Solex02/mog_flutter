import 'package:supabase_flutter/supabase_flutter.dart';

class rankingController {
  final supabase = Supabase.instance.client;

  List topRank = [];


  Future<void> mostLikedUsers() async {
    
    final publicaciones = await supabase.from('publicaciones').select().order('likes', ascending: false);
    List topRank = [
    {"user_id": publicaciones[0]["id_usuario"], "likes": publicaciones[0]["likes"]},
    {"user_id": publicaciones[1]["id_usuario"], "likes": publicaciones[1]["likes"]},
    {"user_id": publicaciones[2]["id_usuario"], "likes": publicaciones[2]["likes"]}
    ];  


  }

  int getLikes(int puesto){

    mostLikedUsers();

    int likes = topRank[puesto]["likes"];

    return likes;
  }

  int getUser(int puesto){

    mostLikedUsers();

    int idUsuario = topRank[puesto]["id_usuario"];

    return idUsuario;
  }

  
}
