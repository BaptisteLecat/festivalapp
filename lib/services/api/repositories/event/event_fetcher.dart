import 'dart:convert';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class EventFetcher extends MainFetcher {
  Future<List<Event>> getEventList({String? label}) async {
    final response = await this.get(
        url: (label != "Tout" && label != null && label != "")
            ? "events?musicgenders.label=$label"
            : "events");
    print(response.content);
    return listEventFromJson(response.content);
  }

  Future<Event> postEvent({required Event event}) async {
    print("postevennt");
    final response =
        await postEntity(url: "events", body: jsonEncode(event.toJson()));
    print(response.content);
    return Event.fromJson(response.content);
  }

  Future<Event> putEvent({required Event event}) async {
    print(event.name);
    final response = await put(url: "events/${event.id}", body: event.toJson());
    print(response.content);
    return Event.fromJson(response.content);
  }

  Future<int> deleteEvent({required Event event}) async {
    final response = await delete(url: "events/${event.id}");
    print(response.content);
    return response.statusCode;
  }
}
