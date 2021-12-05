import 'dart:io';

import 'package:festivalapp/Model/AppUser.dart';
import 'package:festivalapp/Model/Message.dart';
import 'package:festivalapp/services/Api/main_fetcher.dart';

class MessageFetcher extends MainFetcher {
  MessageFetcher() {
    this.setUserToken();
  }

  Future<List<Message>> getMessageList() async {
    final response = await this.get("messages");
    print(response);
    return messageFromJson(response);
  }

  Future<Message> postMessage({required String content}) async {
    final response = await this.post("messages", body: {"content": content});
    print(response);
    return Message.fromJson(response);
  }

    Future<dynamic> postImage({required File file}) async {
    final response = await this.postFile("upload", file);
    print(response.body);
    return response;
  }
}
