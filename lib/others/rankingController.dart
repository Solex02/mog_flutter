import 'package:supabase_flutter/supabase_flutter.dart';

class rankingController {
  final supabase = Supabase.instance.client;

  Future<int> getLikes(int puesto) async {

    final publicaciones = await supabase.from('publicaciones').select().order('likes', ascending: false);
    List topRank = [
    {"likes": publicaciones[0]["likes"]},
    {"likes": publicaciones[1]["likes"]},
    {"likes": publicaciones[2]["likes"]}
    ];  

    int likes = topRank[puesto]["likes"];

    return likes;
  }

  Future<int> getUser(int puesto) async {

    final publicaciones = await supabase.from('publicaciones').select().order('likes', ascending: false);

    List topRank = [
    {"user_id": publicaciones[0]["id_usuario"]},
    {"user_id": publicaciones[1]["id_usuario"]},
    {"user_id": publicaciones[2]["id_usuario"]}
    ]; 

    int idUsuario = topRank[puesto]["user_id"];

    return idUsuario;
  }

  
}
