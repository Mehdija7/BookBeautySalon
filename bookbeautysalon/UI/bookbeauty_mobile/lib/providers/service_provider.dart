import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/providers/base_provider.dart';

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Service");

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }

  Future<List<Service>> getMobile() async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Service/Mobile');

    var headers = createHeaders();

    print('****************** URI *******************************************');
    print(uri);

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      print("response: ${response.request}");

      print("RESPONSE BODYYYYYYYYYYYYYYYYYYYY");
      print(" ${response.body}");
      List<Service> services = (jsonDecode(response.body) as List)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList();
      print("++++++++++++++++++++++++ DATA +++++++++++++++++++++++++++++");
      print(" ${services}");

      return services;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
