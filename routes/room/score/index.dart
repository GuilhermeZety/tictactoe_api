// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' as sb;

import '../../../src/utils/room_utils.dart';

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
  if (data['locale'] == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Nenhum local de marcação foi inserido',
    );
  }

  final roomMap = await supabase.from('room').select().eq('id', data['room_id'] as int).then((value) => value.firstOrNull);

  if (roomMap == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'A sala não existe!',
    );
  }
  if (roomMap['opponent'] == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Ainda não há um Oponente!',
    );
  }

  final isCreator = thisUserId == roomMap['created_by'];

  if (isCreator && roomMap['turn'] == false) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'O turno é do Oponente',
    );
  }
  if (!isCreator && roomMap['turn'] == true) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'O turno é do Oponente',
    );
  }
  //
  final board = RoomUtils.treatBoard(roomMap['board'] as List<dynamic>);
  if (RoomUtils.getBoardValue(board, data['locale'] as int) != null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Este local de marcação ja foi inserido!',
    );
  }

  final boardChanged = RoomUtils.changeBoardValue(board, data['locale'] as int, thisUserId);

  final winner = RoomUtils.hasVictory(boardChanged, thisUserId, roomMap['opponent'] as int);

  await supabase.from('room').update({
    'board': boardChanged,
    'turn': !(roomMap['turn'] as bool),
    if (winner != null) ...{
      'winner': winner,
      'ended': true,
      if (winner == roomMap['created_by']) 'creator_victories': (roomMap['creator_victories'] as int) + 1,
      if (winner == roomMap['opponent']) 'opponent_victories': (roomMap['opponent_victories'] as int) + 1,
    },
  }).eq('id', roomMap['id'] as int);

  if (winner != null) {
    return Response.json(
      body: {
        'victory': true,
        'winner': winner,
      },
    );
  }
  return Response(
    body: 'OK',
  );
}
