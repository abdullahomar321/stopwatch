import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/logo.dart';

class StopwatchProvider extends ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  final List<Duration> _laps = [];

  Duration get elapsed => _elapsed;
  List<Duration> get laps => List.unmodifiable(_laps);
  bool get isRunning => _isRunning;

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsed += const Duration(seconds: 1);
        notifyListeners();
      });
    }
  }

  void stop() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _elapsed = Duration.zero;
    notifyListeners();
  }

  void addLap() {
    if (_elapsed > Duration.zero) {
      _laps.insert(0, _elapsed);
      notifyListeners();
    }
  }

  void deleteLap(int index) {
    _laps.removeAt(index);
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class stopwatch extends StatelessWidget {
  const stopwatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StopwatchProvider(),
      child: const _StopwatchScreen(),
    );
  }
}
class _StopwatchScreen extends StatelessWidget {
  const _StopwatchScreen();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StopwatchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.purple.shade900,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => logo()),
                );
              },
              icon: const Icon(Icons.arrow_back_ios,
                  size: 30, color: Colors.black),
            ),
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.purple.shade900,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 0),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'StopWatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 33,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: provider.addLap,
                icon: const Icon(Icons.add, color: Colors.black, size: 35),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.black,
                    child: SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: 4.0,
                                  child: CircularProgressIndicator(
                                    value: null,
                                    strokeWidth: 4,
                                    backgroundColor: Colors.black,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                        Colors.purpleAccent),
                                  ),
                                ),
                                Text(
                                  provider.formatDuration(provider.elapsed),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: provider.start,
                                icon: const Icon(Icons.play_arrow,
                                    color: Colors.purpleAccent),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: provider.stop,
                                icon: const Icon(Icons.stop,
                                    color: Colors.purpleAccent),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: provider.reset,
                                icon: const Icon(Icons.restart_alt,
                                    color: Colors.purpleAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.laps.length,
                    itemBuilder: (context, index) {
                      final lapTime = provider.laps[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(16.0),
                          height: 80,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    provider.formatDuration(lapTime),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    'Lap ${provider.laps.length - index}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.purpleAccent),
                                onPressed: () => provider.deleteLap(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
