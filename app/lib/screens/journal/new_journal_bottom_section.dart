import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class BottomSection extends StatefulWidget {
  final Function(BuildContext context) discardChanges;
  final TextEditingController bodyController;

  BottomSection(this.discardChanges, this.bodyController);

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool isListening = false;
  SpeechToText stt;

  @override
  void initState() {
    super.initState();
    stt = SpeechToText();
  }

  @override
  void dispose() {
    super.dispose();
    stt.stop();
    stt.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0))
        ],
      ),
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => widget.discardChanges(context),
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => speechToText(context),
              icon: Icon(
                Icons.mic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        if (isListening)
          GestureDetector(
            onTap: () {
              setState(() {
                isListening = false;
                stt.stop();
              });
            },
            child: Container(
              height: 60,
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Listening",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Icon(
                    Icons.mic,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          )
      ]),
    );
  }

  void speechToText(BuildContext context) async {
    bool available = await stt.initialize(onStatus: (status) {
      print("Status: $status");
      if (status != "listening") {
        setState(() {
          isListening = false;
        });
      }
    });
    if (available) {
      setState(() {
        isListening = true;
      });
    }

    print("is it gonna record ? $available ");
    stt.listen(
        onResult: (SpeechRecognitionResult result) {
          widget.bodyController.text += result.recognizedWords;
        },
        listenFor: Duration(seconds: 15));
  }
}
