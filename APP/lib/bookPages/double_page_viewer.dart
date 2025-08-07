import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:palette_generator/palette_generator.dart';
import 'book.dart';
import 'package:audioplayers/audioplayers.dart';

class DoublePageBookViewer extends StatefulWidget {
  final List<BookPage> pages;

  const DoublePageBookViewer({super.key, required this.pages});

  @override
  State<DoublePageBookViewer> createState() => _DoublePageBookViewerState();
}

class _DoublePageBookViewerState extends State<DoublePageBookViewer> {
  late final TurnPageController _controller;
  int _currentPairIndex = 0;

  Map<int, Color> _dominantColors = {};
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  bool _showText = true;

  Future<void> _playVoice(String url, int index) async {
    try {
      if (_playingIndex == index) {
        await _audioPlayer.stop();
        setState(() => _playingIndex = null);
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url));
        setState(() => _playingIndex = index);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("שגיאה בניגון הקול: $e")));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TurnPageController();
  }

  void _goToNextPagePair() {
    if (_currentPairIndex + 2 < widget.pages.length) {
      setState(() {
        _currentPairIndex += 2;
      });
      _controller.animateToPage(_currentPairIndex ~/ 2);
    }
  }

  void _goToPreviousPagePair() {
    if (_currentPairIndex - 2 >= 0) {
      setState(() {
        _currentPairIndex -= 2;
      });
      _controller.animateToPage(_currentPairIndex ~/ 2);
    }
  }

  Future<void> _extractDominantColor(String imageUrl, int index) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
          NetworkImage(imageUrl),
          size: const Size(200, 100),
        );

    setState(() {
      _dominantColors[index] =
          paletteGenerator.dominantColor?.color ?? Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPairs = (widget.pages.length / 2).ceil();

    return Scaffold(
      body: Stack(
        children: [
          TurnPageView.builder(
            controller: _controller,
            itemCount: totalPairs,
            itemBuilder: (context, index) {
              final leftIndex = index * 2;
              final rightIndex = leftIndex + 1;

              final leftPage = widget.pages[leftIndex];
              final rightPage =
                  rightIndex < widget.pages.length
                      ? widget.pages[rightIndex]
                      : BookPage(
                        imagePath: '',
                        text: '',
                        voiceUrl: '',
                        isEndPage: true,
                      );

              return Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPage(leftPage, leftIndex, isLeft: true),
                    ),
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: _buildPage(rightPage, rightIndex, isLeft: false),
                    ),
                  ],
                ),
              );
            },
            animationTransitionPoint: 0.5,
            overleafColorBuilder: (index) => Colors.grey.shade300,
          ),
          Positioned(
            left: 8,
            top: MediaQuery.of(context).size.height / 2 - 24,
            child: _arrowButton(
              icon: Icons.arrow_back_ios,
              onTap: _goToPreviousPagePair,
            ),
          ),
          Positioned(
           key: Key("Next Page"),
            right: 8,
            top: MediaQuery.of(context).size.height / 2 - 24,
            child: _arrowButton(

              icon: Icons.arrow_forward_ios,
              onTap: _goToNextPagePair,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pages ${_currentPairIndex + 1} - ${(_currentPairIndex + 2).clamp(1, widget.pages.length)} of ${widget.pages.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.black54,
              onPressed: () {
                setState(() {
                  _showText = !_showText;
                });
              },
              child: Icon(
                _showText ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BookPage page, int index, {required bool isLeft}) {
    if (page.isEndPage) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Lottie.asset("assets/images/dancing_book.json"),
            ),
            const SizedBox(height: 24),
            const Text(
              'THE END!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      );
    }

    if (page.imagePath.isNotEmpty && !_dominantColors.containsKey(index)) {
      _extractDominantColor(page.imagePath, index);
    }

    final backgroundColor = _dominantColors[index] ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: Offset(isLeft ? -2 : 2, 1),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (page.imagePath.isNotEmpty)
              Image.network(page.imagePath, fit: BoxFit.contain),

            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.centerLeft,
            //       end: Alignment.centerRight,
            //       colors: [
            //         backgroundColor.withOpacity(0.85),
            //         Colors.transparent,
            //         Colors.transparent,
            //         backgroundColor.withOpacity(0.85),
            //       ],
            //       stops: [0.0, 0.1, 0.9, 1.0],
            //     ),
            //   ),
            // ),

            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         backgroundColor.withOpacity(0.85),
            //         Colors.transparent,
            //         Colors.transparent,
            //         backgroundColor.withOpacity(0.85),
            //       ],
            //       stops: [0.11, 0.15, 0.9, 1.0],
            //     ),
            //   ),
            // ),
            if (page.voiceUrl.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  key: Key("Play Sound$index"),
                  onTap: () => _playVoice(page.voiceUrl, index),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: Icon(
                      _playingIndex == index ? Icons.stop : Icons.volume_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

            if (_showText)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showText ? 1.0 : 0.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        key: Key("Page$index"),
                        page.text,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Text(
                'Page ${index + 1}',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onTap,
        iconSize: 30,
      ),
    );
  }
}
