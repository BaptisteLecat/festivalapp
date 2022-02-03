import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/views/account/admin/event/admin_edit_event.dart';
import 'package:festivalapp/views/account/admin/event/components/admin_event_tile.dart';
import 'package:flutter/material.dart';

class AdminEventPage extends StatefulWidget {
  const AdminEventPage({Key? key}) : super(key: key);

  @override
  _AdminEventPageState createState() => _AdminEventPageState();
}

class _AdminEventPageState extends State<AdminEventPage> {
  late Future<List<Event>> _futureEvents;
  List<Event> listEvents = [];

  @override
  void initState() {
    _futureEvents = EventFetcher().getEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Liste des Evenements",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white)),
                  Container(
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text("Ajouter",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder(
                  future: _futureEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      listEvents = snapshot.data as List<Event>;
                      return ListView.builder(
                          itemCount: listEvents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  EventFetcher()
                                      .deleteEvent(event: listEvents[index])
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor:
                                                successMessageColor,
                                            content: Text(
                                                'Cet évènement à été supprimé.')));
                                  }).onError((AppException error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                successMessageColor,
                                            content: Text("${error.message}")));
                                  });
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Supprimer",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                child: AdminEventTile(
                                  event: listEvents[index],
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminEditEvent(
                                                  event: listEvents[index],
                                                ))).then((value) {
                                      setState(() {
                                        listEvents[index] = value;
                                      });
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
