import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const ModeSelectionPage(),
    );
  }
}

class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecione o modo de jogo:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TicTacToePage(isVsComputer: false)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text(
                'Humano vs Humano',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TicTacToePage(isVsComputer: true)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text(
                'Humano vs Robô',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  final bool isVsComputer;

  const TicTacToePage({super.key, required this.isVsComputer});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _status = "Turno do X";

  @override
  void initState() {
    super.initState();

    // Se o modo for "vs Robô" e não for o turno do jogador (X), o robô faz a primeira jogada.
    if (widget.isVsComputer && !_isXTurn) {
      _makeComputerMove();
    }
  }

  void _handleTap(int index) {
    if (_board[index] == '' && !_hasWinner()) {
      setState(() {
        _board[index] = _isXTurn ? 'X' : 'O';

        if (_hasWinner()) {
          _status = 'Vitória de ${_isXTurn ? 'X' : 'O'}!';
        } else if (_isBoardFull()) {
          _status = 'Empate!';
        } else {
          _isXTurn = !_isXTurn;

          if (widget.isVsComputer && !_isXTurn) {
            _status = "Turno do Robô";
            _makeComputerMove();
          } else {
            _status = 'Turno do ${_isXTurn ? 'X' : 'O'}';
          }
        }
      });
    }
  }

  void _makeComputerMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      for (int i = 0; i < _board.length; i++) {
        if (_board[i] == '') {
          setState(() {
            _board[i] = 'O'; // Robô sempre joga como "O"
            if (_hasWinner()) {
              _status = 'Vitória do Robô!';
            } else if (_isBoardFull()) {
              _status = 'Empate!';
            } else {
              _isXTurn = !_isXTurn;
              _status = 'Turno do X';
            }
          });
          break;
        }
      }
    });
  }

  bool _isBoardFull() {
    return !_board.contains('');
  }

  bool _hasWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombinations) {
      if (_board[combo[0]] != '' &&
          _board[combo[0]] == _board[combo[1]] &&
          _board[combo[1]] == _board[combo[2]]) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _status = "Turno do X";

      // Se o robô começar, ele faz a primeira jogada após o reset.
      if (widget.isVsComputer && !_isXTurn) {
        _makeComputerMove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        backgroundColor: Colors.pink,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < 500
              ? constraints.maxWidth * 0.9
              : 400;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _status,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildBoard(gridSize),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoard(double gridSize) {
    return Container(
      width: gridSize,
      height: gridSize,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _handleTap(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[100],
                border: Border.all(color: Colors.pinkAccent, width: 2),
              ),
              child: Center(
                child: Text(
                  _board[index],
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _board[index] == 'X'
                        ? Colors.pink
                        : Colors.deepPurple,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


