// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' as sb;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
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

  if (roomMap['opponent'] != thisUserId && roomMap['created_by'] != thisUserId) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Você não pertence a esta sala!',
    );
  }

  return Response.json(
    body: roomMap,
  );
}
