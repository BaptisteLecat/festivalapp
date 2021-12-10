import 'package:festivalapp/model/event.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  final Event event;
  const EventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
            Expanded(flex: 5, child: Container(color: Colors.blue))
          ],
        ),
      ),
    );
  }
}
