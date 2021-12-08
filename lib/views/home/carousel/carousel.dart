import 'dart:convert';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/api/repositories/event/event_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: EventFetcher().getEventList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              print(snapshot.error);
              return const Center(
                child: Text("Une erreur est survenue."),
              );
            } else {
              List<Event> listEvents = snapshot.data as List<Event>;
              return CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: listEvents.map((event) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(color: Colors.amber),
                          child: (event.picture != null)
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(
                                      event.getPictureEncoded(),
                                      fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                        left: 0,
                                        bottom: 0,
                                        child: Column(
                                          children: [
                                            Text(
                                              event.getDateOfEvent(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                            Text(
                                              event.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            )
                                          ],
                                        ))
                                  ],
                                )
                              : Text("No image"));
                    },
                  );
                }).toList(),
              );
            }
          }
        });
  }
}
