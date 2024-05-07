// ignore_for_file: avoid_print, inference_failure_on_instance_creation

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:supabase/supabase.dart' as sb;

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) async {
      print('connected');

      final supabase = context.read<sb.SupabaseClient>();

      supabase.from('room').stream(primaryKey: ['id']).eq('id', 4).listen((_) {
            if (_.isEmpty) {
              channel.sink.add(null);
            } else {
              channel.sink.add(jsonEncode(_.first));
            }
          });

      channel.stream.listen(
        print,
        onDone: () => print('disconnected'),
      );
    },
  );

  return handler(context);
}


//EXEMPLO DE USO

// final channel = WebSocketChannel.connect(
//   Uri.parse('ws://192.168.2.120:8080/room/stream'),
// );
// channel.stream.listen((event) {
//   if (event != null) {
//     board.value = event;
//   }
// });
