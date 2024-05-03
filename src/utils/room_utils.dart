// ignore_for_file: lines_longer_than_80_chars

class RoomUtils {
  static List<List<int?>> treatBoard(List<dynamic> board) {
    return List<List<int?>>.from(board.map((e) => List<int?>.from(e as List<dynamic>)));
  }

  static int? getBoardValue(List<List<int?>> board, int locale) {
    switch (locale) {
      case 1:
        return board[0][0];
      case 2:
        return board[0][1];
      case 3:
        return board[0][2];
      case 4:
        return board[1][0];
      case 5:
        return board[1][1];
      case 6:
        return board[1][2];
      case 7:
        return board[2][0];
      case 8:
        return board[2][1];
      case 9:
        return board[2][2];
      default:
    }
    return null;
  }

  static List<List<int?>> changeBoardValue(List<List<int?>> board, int locale, int value) {
    final bbb = board;
    switch (locale) {
      case 1:
        bbb[0][0] = value;
      case 2:
        bbb[0][1] = value;
      case 3:
        bbb[0][2] = value;
      case 4:
        bbb[1][0] = value;
      case 5:
        bbb[1][1] = value;
      case 6:
        bbb[1][2] = value;
      case 7:
        bbb[2][0] = value;
      case 8:
        bbb[2][1] = value;
      case 9:
        bbb[2][2] = value;
      default:
    }
    return bbb;
  }

  static int? hasVictory(List<List<int?>> board, int creatorId, int opponentId) {
    final boardList = [
      ...board[0],
      ...board[1],
      ...board[2],
    ];

    if (boardList.where((element) => element == null).length < 3) {
      return null;
    }

    for (final element in indexesSuccess) {
      if (boardList[element[0]] == creatorId && boardList[element[1]] == creatorId && boardList[element[2]] == creatorId) {
        return creatorId;
      }
      if (boardList[element[0]] == opponentId && boardList[element[1]] == opponentId && boardList[element[2]] == opponentId) {
        return opponentId;
      }
    }
    return null;
  }
}

List<List<int>> indexesSuccess = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
  [1, 4, 7],
  [2, 5, 8],
  [3, 6, 9],
  [1, 5, 9],
  [3, 5, 7],
];
