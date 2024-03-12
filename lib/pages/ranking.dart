import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mog_flutter/others/rankingController.dart';
import 'package:mog_flutter/pages/profile.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final supabase = Supabase.instance.client;
  final rankingController rank = rankingController();

  @override
  void initState() {
    super.initState();
    getImage();
  }

  String image2 = "";
  String image1 = "";
  String image3 = "";

  int userid1 = 0;
  int userid2 = 0;
  int userid3 = 0;

  void getImage() async {
    final publicaciones = await supabase
        .from('publicaciones')
        .select()
        .order('likes', ascending: false);

    setState(() {
      image2 = publicaciones[1]["image_data"];
      image1 = publicaciones[0]["image_data"];
      image3 = publicaciones[2]["image_data"];

      userid2 = publicaciones[1]["id_usuario"];
      userid1 = publicaciones[0]["id_usuario"];
      userid3 = publicaciones[2]["id_usuario"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromARGB(255, 22, 29, 77),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "Ranking",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user_id: userid2),
                              ),
                            );
                          }, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Container(
                            child: Image.memory(
                              base64Decode(image2),
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Ancho máximo
                              fit: BoxFit.cover, // Ajuste de la imagen
                            ),
                            width: 80,
                            height: 80,
                          )),
                      SizedBox(
                        width: 100,
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "#2",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                FutureBuilder<int>(
                                  future: rank.getLikes(1),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${snapshot.data} ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user_id: userid1),
                              ),
                            );
                          }, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Container(
                            child: Image.memory(
                              base64Decode(image2),
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Ancho máximo
                              fit: BoxFit.cover, // Ajuste de la imagen
                            ),
                            width: 80,
                            height: 80,
                          )),
                      SizedBox(
                        width: 100,
                        height: 250,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "#1",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                FutureBuilder<int>(
                                  future: rank.getLikes(0),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${snapshot.data} ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 150, left: 20),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user_id: userid3),
                              ),
                            );
                          }, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Container(
                            child: Image.memory(
                              base64Decode(image2),
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Ancho máximo
                              fit: BoxFit.cover, // Ajuste de la imagen
                            ),
                            width: 80,
                            height: 80,
                          )),
                      SizedBox(
                        width: 100,
                        height: 150,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "#3",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                FutureBuilder<int>(
                                  future: rank.getLikes(2),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${snapshot.data} ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
