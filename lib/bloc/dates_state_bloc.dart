import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const ipPort = '//192.168.1.101:3263';

class ConnectionDatesBlocs extends ChangeNotifier {


  final ValueNotifier<List<Map<String, dynamic>>> products =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> categories =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> account =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> orders =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> reserves =
  ValueNotifier<List<Map<String, dynamic>>>([]);


  String extractUserIdFromMessage(String message) {
    final parts = message.split(':');
    if (parts.length == 2) {
      return parts[1].trim();
    }
    return '';
  }

  ConnectionDatesBlocs() {
    connectionDatesBlocsInit();
  }

  late IOWebSocketChannel channel;

  connectionDatesBlocsInit() async {
    webSocketsConnection();
    getProducts();
    getCategories();
  }

  webSocketsConnection() {
    try {
      channel = IOWebSocketChannel.connect('ws:$ipPort');
      channel.stream.listen((message) {
        channel.stream.listen((message) {
          switch (message) {
            case 'update Products':
              getProducts();
              break;
            case 'update categories':
              getCategories();
              break;
            case 'update reserves client':
              final userId = extractUserIdFromMessage(message);
              getReserves(userId);
              break;
              case 'update orders client':
              final userId = extractUserIdFromMessage(message);
              getOrders(userId);
              break;
          }
        });
      }, onError: (error) {
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  getProducts() async {
    final url = Uri.parse('http:$ipPort/get_all_products');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final productsData = List<Map<String, dynamic>>.from(data);
      products.value = productsData;
    }
  }

  getCategories() async {
    final url = Uri.parse('http:$ipPort/get_all_categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final categoriesData = List<Map<String, dynamic>>.from(data);
      categories.value = categoriesData;
    }
  }

  getOrders(String userId) async {
    final url = Uri.parse('http:$ipPort/get_client_orders_userid');

    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

    var body = jsonEncode({
      'user_id': userId
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final ordersData = List<Map<String, dynamic>>.from(data);
        orders.value = ordersData;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
}

getReserves(String userId) async {
  final url = Uri.parse('http:$ipPort/get_client_reserves_userid');


  var headers = {'Content-Type': 'application/json; charset=UTF-8'};

  var body = jsonEncode({
    'user_id': userId
  });

  try {
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final reservesData = List<Map<String, dynamic>>.from(data);
      reserves.value = reservesData;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
}
