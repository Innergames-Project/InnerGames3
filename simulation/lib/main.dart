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
      iconTheme: IconThemeData(color: Colors.white), // <-- dit maakt back arrow wit
      actionsIconTheme: IconThemeData(color: Colors.white),
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
              child: Icon(
                Icons.question_mark,
                color: Colors.white,
              ),
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
  late List<int?> answers;

final List<Map<String, dynamic>> questions = [
  {
    'question': 'Initial Contact',
    'options': ['Goed', 'Matig', 'Slecht'],
  },
  {
    'question': 'Building Rapport',
    'options': ['Stap A', 'Stap B', 'Stap C'],
  },
  {
    'question': 'Risk Assessment',
    'options': ['Veiligheid', 'Planning', 'Communicatie'],
  },
  {
    'question': 'Creating an Action Plan',
    'options': ['Goed', 'Matig', 'Slecht'],
  },
  {
    'question': 'Advocacy & Coordination',
    'options': ['Stap A', 'Stap B', 'Stap C'],
  },
  {
    'question': 'Monitoring Progress',
    'options': ['Veiligheid', 'Planning', 'Communicatie'],
  },
];

@override
void initState() {
  super.initState();
  answers = List.filled(questions.length, null);
}

void nextQuestion() {
  if (currentQuestion < questions.length - 1) {
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
    title: '',
    showBack: true,
  ),

body: buildBackground(
  child: SafeArea(
child: Container(
  width: double.infinity,
  height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

          SizedBox(height: 20),

          Text(
            q['question'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE82B91),
            ),
          ),

          SizedBox(height: 20),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              buildTag('Analysis & planning'),
              buildTag('Assesment'),
              buildTag('Family support'),
              buildTag('Community integration'),
            ],
          ),

          SizedBox(height: 20),

          Text(
            "You receive a call from Anna, a 22-year-old daughter concerned about her mother Maria (45). Anna reports that her mother has been missing medical appointments, neglecting household tasks, and showing signs of depression. Anna is worried but unsure how to help. This is your first interaction with the family.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),

          SizedBox(height: 20),

...List.generate(q['options'].length, (i) {
  final letters = ['A', 'B', 'C'];

  final isSelected = answers[currentQuestion] == i;

  return GestureDetector(
    onTap: () {
      setState(() {
        answers[currentQuestion] = i;
      });
    },
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFA5B800).withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFA5B800),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Text(
            letters[i],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFA5B800),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              q['options'][i],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}),


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE82B91),
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            onPressed: answers[currentQuestion] != null ? nextQuestion : null,
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 12),

          Text(
            '${currentQuestion + 1}/6',
            style: TextStyle(
              color: const Color.fromARGB(255, 42, 42, 42),
              fontSize: 14,
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
                    'Start case simulation',
                    style: TextStyle(
                      fontSize: 30, // groter
                      fontWeight: FontWeight.w800, // dikker
                      color: Color(0xFFE82B91), // hex kleur
                    ),
                  ),
                  SizedBox(height: 20),

                  // 2 korte alinea's
                  Text(
                    "Maria's Case: Supporting a Client with Depression and Social Isolation",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Practice your assessment, intervention, and support skills in this realistic social work scenario",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),

                  // 4 woorden (chips)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      buildTag('Analysis & planning'),
                      buildTag('Assesment'),
                      buildTag('Family support'),
                      buildTag('Community integration'),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.credit_card, color: Color(0xFFA5B800), size: 55), // groter
                          SizedBox(height: 6),
                          Text(
                            '6 cards',
                            style: TextStyle(
                              color: Color(0xFFA5B800),
                              fontSize: 25, // groter
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      Column(
                        children: [
                          Icon(Icons.list_alt, color: Color(0xFFA5B800), size: 55),
                          SizedBox(height: 6),
                          Text(
                            '6 steps',
                            style: TextStyle(
                              color: Color(0xFFA5B800),
                              fontSize: 25, // groter
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
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

Widget buildTag(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Color(0xFFD9D9D9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
    ),
  );
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