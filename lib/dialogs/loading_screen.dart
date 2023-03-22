import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  //singleton pattern
  LoadingScreen._sharedInstance();

  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();

  factory LoadingScreen.instance() {
    return _shared;
  }

  LoadingScreenController? _controller;
  void show({
    required BuildContext context,
    required String text,
}){
if(_controller?.update(text)??false){
return;
}
_controller=_showOverlay(context: context, text: text);
  }
  void hide(){
    _controller?.close();
    _controller=null;
  }
  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textStreamController = StreamController<String>();
    textStreamController.add(text);

    //getting the size
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<String>(
                      builder: (context, streamData) {
                        if (streamData.hasData) {
                          return Text(
                            streamData.data!,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container();
                        }
                      },
                      stream: textStreamController.stream,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    state?.insert(overlay);
    return LoadingScreenController(close: () {
      textStreamController.close();
      overlay.remove();
      return true;
    }, update: (text) {
      textStreamController.add(text);
      return true;
    });
  }
}
