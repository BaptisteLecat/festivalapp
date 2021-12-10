import 'dart:async';

import 'package:festivalapp/model/event.dart';
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
  final CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);
  Completer<GoogleMapController> _controller = Completer();

  late String _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
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
                child: Container(
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: _initialCameraPosition,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
