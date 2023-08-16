import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:virtual_assistant/colors.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText speechToText = stt.SpeechToText();
  var text = "Hold the Button and Start Speaking";
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              // print("helllllllllllllllllllllllllllllllllllo");
              // print(text);
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                        print(text);
                      });
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "Speech to Text",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        // color: Color.fromARGB(255, 227, 10, 10),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        margin: const EdgeInsets.only(bottom: 150),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
