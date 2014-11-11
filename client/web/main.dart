import 'dart:html';
import 'dart:convert';
//import 'package:angular/angular.dart';
//import 'package:angular/application_factory.dart';

class Message {
  String user, message;

  Message(this.user, this.message);

  Message.fromJson(Map data) {
    user    = data["user"];
    message = data["message"];
  }

  Map toJson() => {"user": user, "message": message};
}

//@Injectable()
class ChatController {
  WebSocket ws;
  String user = "";
  String message = "";
  List<Message> messages = [];
  //DivElement chatBox = querySelector("#chat-box");

  FormElement form = querySelector("#stuff");

  ChatController() {
    form.onMouseOver.listen((e) => ws.send(JSON.encode({message: "hi there my name is marvin"})));
    // Initialize Websocket connection (9090 for during development locally,
    // otherwise use standard port 80 for production)
    Uri uri = Uri.parse(window.location.href);
    //var port = uri.port != 8080 ? 80 : 9090;
    var port = uri.port != 63342 ? 80 : 9090;
    ws = new WebSocket("ws://${uri.host}:${port}/ws");

    // Listen for Websocket events
    ws.onOpen.listen((e)    => print("Connected"));
    ws.onClose.listen((e)   => print("Disconnected"));
    ws.onError.listen((e)   => print("Error"));

    // Collect messages from the stream
    ws.onMessage.listen((e) {
      messages.add(new Message.fromJson(JSON.decode(e.data)));
      print(messages);
      //chatBox.children.forEach((child) => chatBox.scrollByLines(chatBox.scrollHeight));

    });
  }

  // Send message on the channel
  void send() {
    print("snding message");
    if((user != "") && user != "") {
      ws.send(JSON.encode(new Message(user, message)));

      // Clear message input
      message = "";
    }

    ws.send("kek");
  }
}

void main() {
  var control = new ChatController();

  /*applicationFactory()
      .rootContextType(ChatController)
      .run();*/
}

