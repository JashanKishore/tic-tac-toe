import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> _board = List.generate(3, (index) => List.filled(3, ''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () {
                        _onTileTapped(i, j);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Text(
                            _board[i][j],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  void _onTileTapped(int i, int j) {
    if (_board[i][j] == '') {
      setState(() {
        _board[i][j] = 'X';
      });

      // Check for a winner or a draw
      if (_checkWinner('X')) {
        _showDialog('Player X wins!');
      } else if (_isBoardFull()) {
        _showDialog('It\'s a draw!');
      } else {
        // Computer's move (simple AI, just fills the first available spot)
        _computerMove();
        if (_checkWinner('O')) {
          _showDialog('Player O wins!');
        } else if (_isBoardFull()) {
          _showDialog('It\'s a draw!');
        }
      }
    }
  }

  void _computerMove() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          setState(() {
            _board[i][j] = 'O';
          });
          return;
        }
      }
    }
  }

  bool _checkWinner(String player) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == player && _board[i][1] == player && _board[i][2] == player) {
        return true;
      }
    }

    // Check columns
    for (int j = 0; j < 3; j++) {
      if (_board[0][j] == player && _board[1][j] == player && _board[2][j] == player) {
        return true;
      }
    }

    // Check diagonals
    if (_board[0][0] == player && _board[1][1] == player && _board[2][2] == player) {
      return true;
    }

    if (_board[0][2] == player && _board[1][1] == player && _board[2][0] == player) {
      return true;
    }

    return false;
  }

  bool _isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (index) => List.filled(3, ''));
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
