import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' as sb;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
    );
  }

  final userId = context.request.headers['user_id'];

  if (userId == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'user_id not found',
    );
  }
  if (int.tryParse(userId) == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'user_id is invalid type',
    );
  }

  final supabase = context.read<sb.SupabaseClient>();

  final resp = await supabase.from('room').insert({
    'created_by': int.parse(userId),
    'turn': Random().nextBool(),
  }).select();

  return Response.json(body: resp.first);
}
