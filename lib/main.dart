import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'src/networking.dart';
import 'src/launchModels.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SpaceX Launches - Rest Api'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<LaunchObj>> launchesList;

  @override
  void initState() {
    super.initState();
    launchesList = fetchLaunches();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: new FutureBuilder<List<LaunchObj>>(
            future: launchesList,
            builder: (context, snapshot) {

              if (!snapshot.hasData) return Center(child: new CircularProgressIndicator());
              List<LaunchObj> launches = snapshot.data;
              return GridView.builder(
                itemCount: launches.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child:
                    new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(flight_number: launches[index].flight_number),
                          ),
                        );
                      },
                      child: Card(
                        child: new Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Container(
                              color: Colors.grey,
                              child:
                              new Image.network(
                                launches[index].img ?? 'https://via.placeholder.com/100',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Container(
                              color: Colors.black.withOpacity(0.5),
                              padding: const EdgeInsets.all(8.0),
                              width: 200,

                              child: Text(launches[index].mission_name, style: TextStyle(fontSize: 18,color:Colors.white)),
                            )
                          ],
                        ),
                        elevation: 2,
                        margin: EdgeInsets.all(10),

                      ),
                    ),


                  );
                }
              );
            },
          )
      ),
    );
  }
}



class DetailScreen extends StatelessWidget {
  final String flight_number;

  DetailScreen({Key key, @required this.flight_number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Lauch Details"),
      ),
      body: LaunchDetailPage(flight_number: flight_number)
    );
  }
}


class LaunchDetailPage extends StatefulWidget {
  LaunchDetailPage({Key key, this.flight_number}) : super(key: key);

  final String flight_number;

  @override
  _LaunchDetailPageState createState() => _LaunchDetailPageState();
}

class _LaunchDetailPageState extends State<LaunchDetailPage> {
  Future<LaunchDetailsObj> launchObj;

  @override
  void initState() {
    super.initState();
    launchObj = fetchSingleLaunch(widget.flight_number);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: new FutureBuilder<LaunchDetailsObj>(
        future: launchObj,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container( child: new CircularProgressIndicator());
          LaunchDetailsObj launch = snapshot.data;
          return Center(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child:Text(launch.launchObj.mission_name, style: TextStyle(fontSize: 22),),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        child:
                        new Image.network(
                          launch.launchObj.img ?? 'https://via.placeholder.com/100',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child:Text(launch.details, style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Container(
                        child: new Image.network(
                          launch.mission_patch ?? 'https://via.placeholder.com/100',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ),

          );
        },
      )
    );
  }



}

