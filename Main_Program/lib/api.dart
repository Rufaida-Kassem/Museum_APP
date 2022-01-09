import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:main_program/Models/Goods.dart';
import 'package:main_program/Models/max_sold_quantity.dart';
import 'package:main_program/Models/coming_events.dart';
import 'package:main_program/Models/coming_tours.dart';
import 'package:main_program/Models/event_location.dart';
import 'package:main_program/Models/search_sov_id.dart';
import 'package:main_program/Models/tour_location.dart';
import 'package:main_program/Models/visitor_id.dart';
import 'package:main_program/Models/statistics.dart';

import 'Models/Visitors_Arrival_Time.dart';
import 'Models/num_visitors.dart';


class list_holder {
  List<dynamic> arguments;
  list_holder(this.arguments);
}

class DBManager {
  //This stores the url that we'll deal with the restful api through
  //for web-based applications this will be http://localhost:5000/
  //for mobile-based applications (emulators) this will be http://10.0.2.2:5000
  static const String BASE_URL = 'http://10.0.2.2:5000';
  static Future<int> executeNonQuery(String query) async {
    var queryParameters = {'query': query};
    var response = await http.post(Uri.parse('${BASE_URL}/ExecuteNonQuery'),
        body: queryParameters);
    int ret = json.decode(response.body)["result"];
    return ret; // 1 if process is done //0 otherwse
  }

  static Future<int> executeNonQueryProc(
      String procName, List<dynamic> listParams) async {
    //parameters are sent as a string
    var queryParameters = {
      'procName': procName,
      'Parameters': jsonEncode(listParams)
    };
    var response = await http.post(Uri.parse('${BASE_URL}/ExecuteNonQueryproc'),
        body: queryParameters);
    if (response.statusCode == 200) {
      return 1; // 1 if process is done //0 otherwise
    } else {
      print(response.statusCode);
      return 0;
    }
  }

  static Future<dynamic> executeScaler(String query) async {
    var queryParameters = {"query": query};
    var response = await http.post(Uri.parse('${BASE_URL}/ExecuteScaler'),
        body: queryParameters);
    dynamic ret;
    if (response.statusCode == 200) {
      ret = json.decode(response.body)["result"];
    } else {
      print(response.statusCode);
      return null;
    }

    return ret; // return output as a dynamic
  }

  static Future<dynamic> executeScalerProc(
      String procName, List<dynamic> listParams) async {
    var queryParameters = {
      'procName': procName,
      'Parameters': jsonEncode(listParams)
    };
    var response = await http.post(Uri.parse('${BASE_URL}/ExecuteScalerProc'),
        body: queryParameters);
    dynamic ret;
    if (response.statusCode == 200) {
      ret = json.decode(response.body)["result"];
    } else {
      print(response.statusCode);
      return null;
    }

    return ret; // return output as a dynamic
  }

  static Future<dynamic> executeReader(String query) async {
    var queryParameters = {'query': query};
    var response = await http.post(Uri.parse('${BASE_URL}/ExecuteReader'),
        body: queryParameters);
    if (response.statusCode == 200) {
      dynamic ret = json.decode(response.body); // list<list<dynamic>>
      return ret; // list of lists
    } else {
      print(response.statusCode);
      return null;
    }
  }




  //--------------- Doaa --------------------------------------
  static Future<List<Good>> getGoods() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getdata')));
    try {
      final goods = goodsFromJson(response.body);
      return goods;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  static Future<List<max_sold>> getmaxsold() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getMaxQuantity')));
    try {
      final max_sold = max_soldFromJson(response.body);
      return max_sold;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  static Future<List<stat>> getstat() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getstatistics')));
    try {
      final stat = statFromJson(response.body);
      return stat;
    } catch (error) {
      print(error);
      rethrow;
    }
  }




  static Future<List<max_sold>> getmaxsale() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getMaxSale')));
    try {
      final max_sold = max_soldFromJson(response.body);
      return max_sold;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  static Future<List<visitors_arr_time>> getVisitorsArrivalTime() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getVisitorsArrivalTime')));
    try {
      final visitors_arr_time = visitors_arr_timeFromJson(response.body);
      return visitors_arr_time;
    } catch (error) {
      print(error);
      rethrow;
    }
  }







  //using procedure
  static Future<List<events>> getevents() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getEvents')));
    try {
      final events = eventsFromJson(response.body);
      return events;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  //using procedure
  static Future<List<tours>> gettours() async {
    final response = await http.get((Uri.parse('${BASE_URL}/getTours')));
    try {
      final tours = toursFromJson(response.body);
      return tours;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  //using procedure
  static Future<List<event_loc>> geteventloc(String event_title) async {

    final response = await http.post(Uri.parse('${BASE_URL}/getEventLocation'), body:{'event_title':event_title});
    try {
      final event_loc = event_locFromJson(response.body);
      return event_loc;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  //using procedure
  static Future<List<tour_loc>> gettourloc(String tour_topic) async {

    final response = await http.post(Uri.parse('${BASE_URL}/getTourLocation'), body:{'tour_topic':tour_topic});
    try {
      final tour_loc = tour_locFromJson(response.body);
      return tour_loc;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  //using procedure
  static Future<List<visitor_id>> search_visitor_id(int id) async {

    final response = await http.post(Uri.parse('${BASE_URL}/SearchVisitorID'), body:{'ID':id.toString()});
    try {
      final visitor_id = visitor_idFromJson(response.body);
      return visitor_id;
    } catch (error) {
      print(error);
      return [];
      //rethrow;
    }
  }


  //using procedure
  static Future<List<sov_id>> search_sov_id(int id) async {

    final response = await http.post(Uri.parse('${BASE_URL}/selectSoveID'), body:{'ID':id.toString()});
    try {
      final sov_id = sov_idFromJson(response.body);
      return sov_id;
    } catch (error) {
      print(error);
      return [];
      //rethrow;
    }
  }




  //using procedure
  static Future<List<num_visiotrs>> count_visitors_now(String arrTime) async {

    final response = await http.post(Uri.parse('${BASE_URL}/getNumVisitorsNow'), body:{'arr_time':arrTime});
    try {
      final num_visiotrs = num_visiotrsFromJson(response.body);
      return num_visiotrs;
    } catch (error) {
      print(error);
      return [];
      //rethrow;
    }
  }





//--------------- Doaa --------------------------------------
}





