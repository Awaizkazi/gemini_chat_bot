// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gemini_chat_bot/Model/model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});

  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  TextEditingController promptController = TextEditingController();
  static const apiKey = "AIzaSyDTGVhWyrev3MjOBJhm5j5bbb_mkHcASVo";
  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: apiKey,
  );
  final List<ModelMessage> prompt = [];

  Future<void> SendMessage() async {
    final message = promptController.text;
    // * For Prompt
    setState(() {
      promptController.clear();
      prompt.add(
        ModelMessage(
          isPrompt: true,
          message: message,
          time: DateTime.now(),
        ),
      );
    });
    // * For respond
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(
        ModelMessage(
          isPrompt: false,
          message: response.text ?? "",
          time: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.purpleAccent[100],
        title: const Text('Gemini AI ChatBot'),
      ),
      body: Column(
        children: [
          // TODO Give reply to user using the Gemini API
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final message = prompt[index];
                return UserPrompt(
                  isPrompt: message.isPrompt,
                  message: message.message,
                  date: DateFormat('hh:mm a').format(message.time),
                );
              },
              itemCount: prompt.length,
            ),
          ),
          //! Enter user input
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promptController,
                    autocorrect: true,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Enter a prompt here",
                    ),
                  ),
                ),
                // ignore: prefer_const_constructors
                Spacer(),
                GestureDetector(
                  onTap: () {
                    SendMessage();
                  },
                  child: const CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.purpleAccent,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container UserPrompt(
      {required final bool isPrompt,
      required String message,
      required String date}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 80 : 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPrompt ? Colors.purple : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isPrompt ? Radius.circular(15) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO For Prompt and respond
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
          // * For Prompt and respond time
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
