// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' as sb;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
    );
  }

  final supabase = context.read<sb.SupabaseClient>();

  final thisUserId = int.tryParse(context.request.headers['user_id'] ?? '');
  final json = await context.request.json();

  if (thisUserId == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'nenhum usuário sendo referenciado',
    );
  }

  if (json == null || json is! Map) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'invalid data',
    );
  }

  final data = json as Map<String, dynamic>;

  if (data['room_id'] == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Nenhuma sala sendo referenciada',
    );
  }

  final roomMap = await supabase.from('room').select().eq('id', data['room_id'] as int).then((value) => value.firstOrNull);

  if (roomMap == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'A sala não existe!',
    );
  }
  if (roomMap['opponent'] != null && roomMap['created_by'] != thisUserId && roomMap['opponent'] != thisUserId) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Voce não tem vínculo a esta sala',
    );
  } else {
    if (roomMap['created_by'] == thisUserId || roomMap['opponent'] == thisUserId) {
      return Response.json(
        body: {
          'room_id': data['room_id'],
        },
      );
    }
    if (roomMap['opponent'] == null) {
      await supabase.from('room').update({
        'opponent': thisUserId,
      });

      return Response.json(
        body: {
          'room_id': data['room_id'],
        },
      );
    }
  }

  return Response(
    statusCode: HttpStatus.badRequest,
    body: 'Ocorreu um erro inesperado',
  );
}
