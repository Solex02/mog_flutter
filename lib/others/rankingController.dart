import 'package:supabase_flutter/supabase_flutter.dart';

class rankingController {
  final supabase = Supabase.instance.client;

  Future<int> getLikes(int puesto) async {
    final publicaciones = await supabase
        .from('publicaciones')
        .select()
        .order('likes', ascending: false);
    int likes = publicaciones[puesto]["likes"];

    return likes;
  }

  Future<int> getUser(int puesto) async {
    final publicaciones = await supabase
        .from('publicaciones')
        .select()
        .order('likes', ascending: false);

    int idUsuario = publicaciones[puesto]["user_id"];

    return idUsuario;
  }

  Future<String> getImage(int puesto) async {
    final publicaciones = await supabase
        .from('publicaciones')
        .select()
        .order('likes', ascending: false);

    String image = publicaciones[puesto]["image_data"];

    return image;
  }
}
