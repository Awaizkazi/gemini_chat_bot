// ignore_for_file: prefer_const_constructors

import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:gemini_chat_bot/Model/model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  final bool isPrompt = true;
  Future<void> SendMessage() async {
    final message = promptController.text;
    setState(() {
      prompt.add(
        ModelMessage(
          isPrompt: true,
          message: message,
          time: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('AI ChatBot'),
      ),
      body: Column(
        children: [
          // TODO Give reply to user using the Gemini API
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final message = prompt[index];
                return UserPrompt(message, index);
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
                  onTap: () {},
                  child: const CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.green,
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

  Container UserPrompt(ModelMessage message, int index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPrompt == true ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.message,
            style: TextStyle(
              fontWeight:
                  isPrompt == index ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt == index ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
