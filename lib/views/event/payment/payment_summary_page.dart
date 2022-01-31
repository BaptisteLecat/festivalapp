import 'package:flutter/material.dart';
import 'package:festivalapp/views/event/payment/webhook_payment_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:festivalapp/model/event.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';
import 'package:festivalapp/services/stripe/stripe_services.dart';

class PaymentSummaryPage extends StatefulWidget {
  Event event;
  PaymentSummaryPage({Key? key, required this.event}) : super(key: key);

  @override
  _PaymentSummaryPageState createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Récapitulatif de l'achat"),
          ),
          body: LoaderOverlay(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("asset/image/bkg_home.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.event.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          "${widget.event.price}",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                  ),
                  Container(
                      // height: 160,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DottedLine(
                            dashColor: Theme.of(context).primaryColor,
                            dashGapLength: 10,
                            dashLength: 6,
                            lineThickness: 2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total :",
                                  style: Theme.of(context).textTheme.headline5),
                              Text("${widget.event.price}€",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: TextButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return WebhookPaymentScreen(
                                              event: widget.event,
                                            );
                                          }).then((successPayment) {
                                        if (successPayment == true) {
                                          context.loaderOverlay.show();
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 5000), () {
                                            setState(() {
                                              context.loaderOverlay.hide();
                                            });
                                            while (Navigator.canPop(context)) {
                                              // Navigator.canPop return true if can pop
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                      });
                                    },
                                    child: Text("Procéder au paiement",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor))),
                              ))
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
