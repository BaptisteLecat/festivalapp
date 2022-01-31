import 'dart:convert';

import 'package:festivalapp/services/Api/main_fetcher.dart';
import 'package:intl/intl.dart';

class PaymentRepository extends MainFetcher {
  Future<dynamic> createPayment(
      {required String session,
      required String amount,
      required int product,
      int type = 1}) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);
    Map<String, dynamic> body = {
      "datePayment": formattedDate,
      "type": type,
      "status": 1,
      "session": session,
      "amount": amount,
      "product": "api/produits/$product"
    };
    final response = await get(url: "music_genders");
    print(response.content);
    return response.content;
  }
}
