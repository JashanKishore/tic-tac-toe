// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToe(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> _board = List.generate(3, (index) => List.filled(3, ''));

  bool isAiTurn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
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
              child: Text('Reset Game', 
              style: TextStyle(
                color: Colors.black),
                ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTileTapped(int i, int j) {
    if (!isAiTurn && _board[i][j] == '') {
      setState(() {
        _board[i][j] = 'X';
      });

      // Check for a winner or a draw
    if (_checkWinner('X')) {
      _showDialog('Player X wins!');
    } else if (_isBoardFull()) {
      _showDialog('It\'s a draw!');
    } else {
      // Set _isAiTurn to true to disable user input during AI's turn
      isAiTurn = true;
        // Computer's move (simple AI, just fills the first available spot)
        _computerMove();
        if (_checkWinner('O')) {
          _showDialog('Player O wins!');
        } else if (_isBoardFull()) {
          _showDialog('It\'s a draw!');
        }

        // Set isAiTurn back to false after AI's move to enable user input
        isAiTurn = false;
    }
  }
}

void _computerMove() {
  // Check for potential winning moves for the player (X) and block them
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (_board[i][j] == '') {
        // Simulate the move to check for potential win
        _board[i][j] = 'X';
        if (_checkWinner('X')) {
          // Block the winning move
          setState(() {
            _board[i][j] = 'O';
          });
          return;
        } else {
          // Undo the move if it doesn't lead to a win
          _board[i][j] = '';
        }
      }
    }
  }

  // If there are no winning moves to block, fill the first available spot
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
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _board[i][j] = '';
      }
    }
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
