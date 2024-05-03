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

  final data = await context.request.json();

  if (data == null || data is! Map) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'invalid data',
    );
  }

  final resp = await supabase.from('user').insert({
    'name': data['name'] ?? 'Anônimo',
  }).select();

  return Response.json(
    body: resp.first,
  );
}
