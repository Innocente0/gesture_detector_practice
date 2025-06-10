import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const StatusApp());

class StatusApp extends StatelessWidget {
  const StatusApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Status Gesture Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      scaffoldBackgroundColor: Colors.grey[100],
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Color> _bgColors = [
    Colors.teal.shade300,
    Colors.purple.shade300,
    Colors.orange.shade300,
    Colors.blueGrey.shade300,
  ];
  int _current = 0;
  bool _isPaused = false;
  Timer? _holdTimer;
  bool _liked = false;

  void _nextStatus() {
    if (_isPaused) return;
    setState(() {
      _current = (_current + 1) % _bgColors.length;
      _liked = false;
    });
  }

  void _pauseStatus(bool pause) {
    setState(() => _isPaused = pause);
    if (pause) {
      _holdTimer?.cancel();
    }
  }

  void _likeStatus() {
    setState(() => _liked = !_liked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_liked ? 'Status Liked ❤️' : 'Like Removed'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Status'),
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _nextStatus,
        onDoubleTap: _likeStatus,
        onLongPressStart: (_) { _pauseStatus(true); },
        onLongPressEnd: (_) { _pauseStatus(false); },
        onTapDown: (_) {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _bgColors[_current],
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Status ${_current + 1}',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_liked)
                const Positioned(
                  bottom: 40,
                  right: 40,
                  child: Icon(Icons.favorite, size: 48, color: Colors.redAccent),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SecondPage()),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _tapCount = 0;
  Timer? _resetTimer;
  bool _liked = false;

  List<Color> _tints = [
    Colors.transparent,
    Colors.red.withOpacity(0.4),
    Colors.green.withOpacity(0.4),
    Colors.blue.withOpacity(0.4),
  ];
  int _tintIndex = 0;
  Offset _offset = Offset.zero;
  double _scale = 1.0;

  void _handleTripleTap() {
    _tapCount++;
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 600), () {
      _tapCount = 0;
    });
    if (_tapCount == 3) {
      Navigator.of(context).pop();
    }
  }

  void _cycleTint() {
    setState(() => _tintIndex = (_tintIndex + 1) % _tints.length);
  }

  void _like() {
    setState(() => _liked = !_liked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_liked ? 'You liked this ❤️' : 'Like removed'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Status'),
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleTripleTap,
        onDoubleTap: _like,
        onLongPress: _pauseHold,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _cycleTint,
                    onScaleUpdate: (details) {
                      setState(() {
                        _scale = (_scale * details.scale).clamp(0.5, 4.0);
                        _offset += details.focalPointDelta;
                      });
                    },
                    child: Transform.translate(
                      offset: _offset,
                      child: Transform.scale(
                        scale: _scale,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            _tints[_tintIndex],
                            BlendMode.srcATop,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://picsum.photos/300',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_liked)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Icon(Icons.favorite, size: 48, color: Colors.redAccent),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pauseHold() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status Held...'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
