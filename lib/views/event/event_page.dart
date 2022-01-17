import 'dart:async';

import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/views/event/payment/webhook_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class EventPage extends StatefulWidget {
  final Event event;
  const EventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late CameraPosition _initialCameraPosition;
  Completer<GoogleMapController> _controller = Completer();

  late String _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    if (widget.event.latitude != null && widget.event.longitude != null) {
      _initialCameraPosition = CameraPosition(
          target: LatLng(widget.event.latitude!, widget.event.longitude!),
          zoom: 11.5);
    }
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style.json');
    await _controller.future.then((value) {
      value.setMapStyle(_darkMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 4,
                child: SizedBox(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        widget.event.getPictureEncoded(),
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.arrow_back),
                                      Icon(Icons.favorite)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: const SizedBox(),
                              ),
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(widget.event.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(widget.event.getDateOfEvent(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1)
                                          ],
                                        )
                                      ]),
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                )),
            Expanded(
                flex: 5,
                child: SizedBox(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: Colors.white)),
                                Text(widget.event.description,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: (widget.event.latitude != null &&
                                    widget.event.longitude != null)
                                ? GoogleMap(
                                    markers: {
                                      Marker(
                                          markerId: MarkerId(widget.event.name),
                                          position: LatLng(
                                              widget.event.latitude!,
                                              widget.event.longitude!))
                                    },
                                    myLocationButtonEnabled: false,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                    initialCameraPosition:
                                        _initialCameraPosition,
                                  )
                                : Center(
                                    child:
                                        Text("Pas de de données de position."),
                                  ),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 36, vertical: 6)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ))),
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WebhookPaymentScreen(
                                            event: widget.event,
                                          );
                                        }).then((successPayment) {
                                      if (successPayment == true) {
                                        Future.delayed(
                                            const Duration(milliseconds: 5000),
                                            () {
                                          setState(() {});
                                          while (Navigator.canPop(context)) {
                                            // Navigator.canPop return true if can pop
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Text(
                                      "Acheter un ticket ${widget.event.price}€",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4))
                            ],
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
