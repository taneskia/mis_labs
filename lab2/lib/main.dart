import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MIS Labs',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ClothingSelector());
  }
}

class ClothingSelector extends StatefulWidget {
  const ClothingSelector({Key? key}) : super(key: key);

  @override
  _ClothingSelectorState createState() => _ClothingSelectorState();
}

class _ClothingSelectorState extends State<ClothingSelector> {
  final _questions = [
    {
      'question': 'Do you want a hat?',
      'answers': ['Yes', 'No']
    },
    {
      'question': 'What kind of top do you want?',
      'answers': ['Shirt', 'Blouses', 'Cardigan']
    },
    {
      'question': 'What color of pants do you want?',
      'answers': ['Black', 'Gray', 'White']
    },
    {
      'question': 'What kind of shoes do you want?',
      'answers': ['Trainers', 'Boots', 'Oxford']
    }
  ];

  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothing Selector'),
        elevation: 5.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(
          children: [
            Text(
              _questions[_index]['question'].toString(),
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            ...(_questions[_index]['answers'] as List<String>).map((a) =>
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: answerSelected,
                        child: Text(
                          a,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void answerSelected() {
    setState(() {
      if (_index < _questions.length - 1) _index++;
    });
  }
}
