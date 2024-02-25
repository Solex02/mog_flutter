import 'package:flutter/material.dart';
import 'package:mog_flutter/others/rankingController.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final rankingController rank = rankingController();

  late int liketop1 = rank.getLikes(0);
  late int liketop2 = rank.getLikes(1);
  late int liketop3 = rank.getLikes(2);

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
                            print("prueba");
                          }, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Image(
                            image: AssetImage('assets/images/podium.png'),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 100,
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                              child: Text(
                            "#2\n $liketop2",
                            style: TextStyle(color: Colors.white),
                          )),
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
                          onTap: () {}, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Image(
                            image: AssetImage('assets/images/podium.png'),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 100,
                        height: 250,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                              child: Text(
                            "Data",
                            style: TextStyle(color: Colors.white),
                          )),
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
                          onTap: () {}, // Handle your callback.
                          splashColor: Colors.brown.withOpacity(0.5),
                          child: Image(
                            image: AssetImage('assets/images/podium.png'),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 100,
                        height: 150,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 52, 65, 151)),
                          child: Center(
                              child: Text(
                            "Data",
                            style: TextStyle(color: Colors.white),
                          )),
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
            Text(
              "Previous Weeks",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
