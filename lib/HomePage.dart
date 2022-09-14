import 'package:flutter/material.dart';
import 'Tab_Anime.dart';                  //packages different tabs in our app
import 'Tab_Movies.dart';
import 'Tab_WebSeries.dart';


//Stateful widget so that it we can change tabs in our app.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var _tabController;           // tab controller which will help us to change
  @override  // when we click on different images on our

  void initState() {            // home page
    super.initState();
    _tabController=TabController(length: 4, vsync: this);   // here we are initializing
  }                                                         // our tab-controller

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Organizer"),
          backgroundColor:  Colors.orange.shade400,
          bottom: TabBar(
            controller: _tabController,  // here we use the previously initialized controller so that we can navigate using images.
            labelColor: Color.fromARGB(255, 239, 229, 209),
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
            indicatorColor: Colors.white,
            tabs: [
              Container(
                width: 80,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Anime",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Web Series",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Movies",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: [
              Scaffold(
                body: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 250,
                        left: 50,
                        child: Image(
                          image: AssetImage("assets/Home.png"),
                          width: 250,
                        ),
                      ),
                      Positioned(
                        left: -10,
                        top: 120,
                        child: TextButton(
                          onPressed: () {
                            _tabController.index=1;
                            },
                          child: Image(
                            image: AssetImage("assets/Anime.png"),
                            width: 180,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 370,
                        left: 60,
                        child: TextButton(
                          onPressed: () {
                            _tabController.index=2;
                            },
                          child: Image(
                            image: AssetImage("assets/Web Series.png"),
                            width: 230,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 200,
                        child: TextButton(
                          onPressed: () {
                            _tabController.index=3;
                            },
                          child: Image(
                            image: AssetImage("assets/Movies.png"),
                            width: 180,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 630,
                        left: 90,
                        child: Text(
                          "Made with ❤ in India",
                          style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: Text(
                          "Yo, What's Up?",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Anime(),
              Web_Series(),
              Movies(),
            ],
          ),
        ),
    );
  }
}
