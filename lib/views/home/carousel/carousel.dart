import 'dart:convert';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/views/event/event_page.dart';
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
            return const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
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
                options: CarouselOptions(
                    autoPlayCurve: Curves.easeInOutQuart,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlay: true,
                    height: 400.0,
                    viewportFraction: 0.7,
                    enlargeCenterPage: true),
                items: listEvents.map((event) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventPage(
                                        event: event,
                                      )));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28))),
                            child: (event.picture != null)
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Image.memory(
                                          event.getPictureEncoded(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                          left: 10,
                                          bottom: 14,
                                          child: Column(
                                            children: [
                                              Text(
                                                event.getDateOfEvent(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.white),
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
                                : Text("No image")),
                      );
                    },
                  );
                }).toList(),
              );
            }
          }
        });
  }
}
