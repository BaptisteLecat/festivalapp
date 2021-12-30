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
}
