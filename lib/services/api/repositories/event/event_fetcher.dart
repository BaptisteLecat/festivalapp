import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class EventFetcher extends MainFetcher {
  Future<List<Event>> getEventList() async {
    final response = await this.get(url: "events");
    print(response);
    return listEventFromJson(response);
  }
}
