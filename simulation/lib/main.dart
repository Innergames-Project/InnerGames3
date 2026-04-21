import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Simulation',
      home: StartScreen(),
    );
  }
}

Widget buildBackground({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/app_bg.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  CustomAppBar({required this.title, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Icon(Icons.question_mark),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// QUIZ SCHERM
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  List<int?> answers = List.filled(6, null);

  final List<Map<String, dynamic>> questions = List.generate(6, (index) {
    return {
      'question': 'Vraag ${index + 1}',
      'options': ['A', 'B', 'C'],
    };
  });

  void nextQuestion() {
    if (currentQuestion < 5) {
      setState(() => currentQuestion++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(answers: answers),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[currentQuestion];

return Scaffold(
  extendBodyBehindAppBar: true,
  backgroundColor: Colors.transparent,
  appBar: CustomAppBar(
    title: 'Vraag ${currentQuestion + 1}/6',
    showBack: true,
  ),
  body: buildBackground(
    child: SafeArea(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(q['question'], style: TextStyle(fontSize: 20)),
          ...List.generate(3, (i) {
            return RadioListTile<int>(
              title: Text(q['options'][i]),
              value: i,
              groupValue: answers[currentQuestion],
              onChanged: (val) {
                setState(() {
                  answers[currentQuestion] = val;
                });
              },
            );
          }),
          ElevatedButton(
            onPressed: answers[currentQuestion] != null ? nextQuestion : null,
            child: Text('Volgende'),
          )
        ],
      ),
    ),
      ),
    );
  }
}

// RESULTAAT SCHERM
class ResultScreen extends StatelessWidget {
  final List<int?> answers;

  ResultScreen({required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Resultaten',
        showBack: true,
      ),
      body: buildBackground(
        child: SafeArea(
          child: ListView.builder(
            itemCount: answers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Vraag ${index + 1}'),
                subtitle: Text('Antwoord: ${answers[index] ?? "Geen"}'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(title: 'Quiz Simulation'),
      body: buildBackground(
        child: SafeArea(
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quiz Simulation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE82B91),
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizScreen()),
                        );
                      },
                      child: Text(
                        'Start Simulation',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Hulp'),
      ),
      body: buildBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Dit is een quiz simulatie.\n\n'
              'Kies bij elke vraag één antwoord en ga verder.\n'
              'Aan het einde zie je een overzicht van je antwoorden.',
            ),
          ),
        ),
      ),
    );
  }
}