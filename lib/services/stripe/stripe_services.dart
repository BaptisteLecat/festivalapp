import 'dart:convert';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/Api/repositories/payment/payment_repository.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({
    required this.message,
    required this.success,
  });
}

class StripeServices {
  static const String _apiBase = 'https://api.stripe.com/v1';
  static String _paymentApiUrl = '${StripeServices._apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(_paymentApiUrl);
  static const String currency = "EUR";
  static const String publishKey =
      "pk_test_51Jc8zTFVWF1HZU91DIEn30SI9EZWdQD7Q32IjEBDNW2Gju5iqZR9kdbUTLouUofBd5dRt7aaklRsEEiRMnaAOHWm00FZgUqv4m";
  static const String _secret =
      'sk_test_51Jc8zTFVWF1HZU917EGx35My6pxXyJvdtqCHrgh6OgDUoeKUoPjAuS6ASZtC1hw7u3hVGc4RehWjTnfzD0FloRQV00BQYEVlHy';

  static Map<String, String> _headers = {
    'Authorization': 'Bearer ${StripeServices._secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  // 2. Gather customer billing information (ex. email)
  final _billingDetails = BillingDetails(
    email: "payment@baptiste-lecat.fr",
    name: "payment",
    phone: "phone",
    address: Address(
      city: null,
      country: null,
      line1: null,
      line2: null,
      state: null,
      postalCode: null,
    ),
  );

  Future<PaymentIntent> _comfirmPaymentToStripe(
      Map<String, dynamic> clientSecret) async {
    try {
      // 3. Confirm payment with card details
      // The rest will be done automatically using webhooks
      // ignore: unused_local_variable
      return await Stripe.instance.confirmPayment(
        clientSecret['client_secret'],
        PaymentMethodParams.card(
          billingDetails: this._billingDetails,
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> _createPaymentInAPI(
      {required String amount,
      required int productId,
      required sessionId}) async {
    await PaymentRepository()
        .createPayment(amount: amount, product: productId, session: sessionId);
  }

  Future<StripeTransactionResponse> startPayment({required Event event}) async {
    try {
      // 1. fetch Intent Client Secret from backend
      final clientSecret = await this._fetchPaymentIntentClientSecret(
          amount: event.getPriceStripeFormatted());
      await this._createPaymentInAPI(
          amount: event.price.toString(),
          productId: event.id,
          sessionId: clientSecret["id"]);
      await this._comfirmPaymentToStripe(clientSecret);
      return StripeTransactionResponse(
          message: "La transaction a été effectué", success: true);
    } on PlatformException catch (error) {
      return StripeServices.getErrorAndAnalyze(error);
    } on StripeException catch (error) {
      return StripeTransactionResponse(
          message: error.error.localizedMessage!, success: false);
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Une erreur est survenue lors de la transaction',
          success: false);
    }
  }

  Future<Map<String, dynamic>> _fetchPaymentIntentClientSecret(
      {required String amount}) async {
    final url = Uri.parse(StripeServices._paymentApiUrl);
    final response = await http.post(
      url,
      headers: StripeServices._headers,
      body: {
        'amount': amount,
        'currency': StripeServices.currency,
      },
    );
    if (response.statusCode != 200) {
      throw Exception();
    }
    return json.decode(response.body);
  }

  static getErrorAndAnalyze(err) {
    String message = 'Une erreur est survenue';
    if (err.code == 'cancelled') {
      message = 'Le paiement a été annulé';
    }
    return StripeTransactionResponse(message: message, success: false);
  }
}
