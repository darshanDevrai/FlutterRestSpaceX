
import 'package:http/http.dart'  as http;
import 'launchModels.dart';
import 'dart:convert' as json;

Future<List<LaunchObj>> fetchLaunches() async {
  final response = await http.get('https://api.spacexdata.com/v3/launches/past?limit=10');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    final jsonStr = json.jsonDecode(response.body);
    final launchesData = jsonStr.map<LaunchObj>((i) => new LaunchObj.fromJson(i)).toList();

    return launchesData;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


Future<LaunchDetailsObj> fetchSingleLaunch(flight_number) async {
  final response =
  await http.get('https://api.spacexdata.com/v3/launches/'+flight_number.toString());
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    final jsonStr = json.jsonDecode(response.body);
    final launchData = new LaunchDetailsObj.fromJson(jsonStr);
    return launchData;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

