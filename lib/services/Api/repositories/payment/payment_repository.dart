import 'dart:convert';

import 'package:festivalapp/services/Api/main_fetcher.dart';
import 'package:intl/intl.dart';

class PaymentRepository extends MainFetcher {
  Future<dynamic> createPayment(
      {required String session,
      required String amount,
      required int eventId,
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
      "event": "api/events/$eventId"
    };
    final response = await postEntity(url: "payments", body: jsonEncode(body));
    print(response.content);
    return response.content;
  }
}
