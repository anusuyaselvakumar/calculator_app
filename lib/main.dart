import 'package:calculator/button.dart';
import 'package:calculator/text.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> buttons = [
    'AC',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '=',
  ];

  bool isOperator(String x) {
    if (x == '*' ||
        x == '/' ||
        x == '+' ||
        x == '=' ||
        x == '-' ||
        x == '%' ||
        x == 'AC' ||
        x == 'DEL') {
      return true;
    } else {
      return false;
    }
  }

  var userInput = "";
  var showAnswer = "";

  void toggleSign() {
    setState(() {
      if (userInput.isNotEmpty) {
        if (userInput.startsWith('-')) {
          userInput = userInput.substring(1); // Remove the negative sign
        } else {
          userInput = '-$userInput'; // Add the negative sign
        }
      }
    });
  }

  void equalIsPressed() {
    String questions = userInput;
    Parser p = Parser();
    Expression exp = p.parse(questions);
    ContextModel cm = ContextModel();
    double res = exp.evaluate(EvaluationType.REAL, cm);

    showAnswer = res.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Calculator',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        leading: const Icon(
          Icons.calculate,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          // user input and ans
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyText(
                  text: userInput,
                  fontSize: 35,
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                ),
                MyText(
                  text: showAnswer,
                  fontSize: 45,
                  alignment: Alignment.centerRight,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),

          //for buttons
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                // clear button

                return MyButton(
                  onTap: () {
                    if (index == 0) {
                      setState(() {
                        userInput = "";
                        showAnswer = "";
                      });
                      // delete button
                    } else if (buttons[index] == "DEL") {
                      setState(() {
                        userInput =
                            userInput.substring(0, userInput.length - 1);
                      });
                    }
                    // for +/- button
                    else if (buttons[index] == '+/-') {
                      toggleSign();
                    }
                    // for equal button
                    else if (buttons[index] == '=') {
                      setState(() {
                        equalIsPressed();
                      });
                    } else {
                      setState(() {
                        userInput += buttons[index];
                      });
                    }
                  },
                  buttonText: buttons[index],
                  color: isOperator(buttons[index])
                      ? const Color.fromARGB(148, 174, 44, 221)
                      : const Color.fromARGB(190, 136, 134, 137),
                  textColor: isOperator(buttons[index])
                      ? const Color.fromARGB(255, 242, 235, 245)
                      : Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
