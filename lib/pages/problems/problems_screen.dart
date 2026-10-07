
import 'package:empty_app/services/firebase_service.dart';
import 'package:empty_app/utils/scripts/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_tex/flutter_tex.dart';

class ProblemsScreen extends StatefulWidget {
  const ProblemsScreen({super.key});

  @override
  State<ProblemsScreen> createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> 
{
  Map arguments = {};

  final Stopwatch _stopwatch = Stopwatch();
  Timer _timer = Timer.periodic(const Duration(days: 1), (Timer timer) {});
  String _result = '00:00';

  List problems = [];
  int problemLength = 0;
  int currentProblem = 0;
  int attemps = 1;

  Map<String, dynamic> problemData = {
    'title': 'Cargando...',
    'paragraph': 'Cargando...',
    'category': 'Cargando',
    'subcategory': 'Cargando...',
    'difficulty': 'Cargando...',
    'answers': [
      'Cargando...',
      'Cargando...',
      'Cargando...',
      'Cargando...'
    ],
    'solution': '1',
  };

  void _startTimer()
  {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer timer) 
    { 
      setState(() {
        _result = '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });

    _stopwatch.start();
  }

  void _stopTimer()
{
  if(_timer.isActive)
  {
    _timer.cancel();
  }

  _stopwatch.stop();
}

  void _resetTimer()
  {
    _stopTimer();
    _stopwatch.reset();
    setState(() {});
  }

  void _initializeScreen() async
  {
    if(!await existsInternet())
    {
      showWarningBottomSheet(context, 'Sin conexión a internet', 'Puede constestar las preguntas normalmente, pero si detiene la ejecución antes de conectarse de nuevo, no se guardarán sus respuestas', false);

      await Future.delayed(const Duration(seconds: 10));

      Navigator.pop(context);
    }

    showProgressBottomSheet(context, 'Cargando problemas');

    arguments = ModalRoute.of(context)!.settings.arguments as Map;

    List<String> fields = ['scholarKey'];
    List<String> values = [arguments['scholarKey']];


    if(arguments['category'] != 'all')
    {
      fields.add('category');
      values.add(arguments['category']);

      if(arguments['subcategory'] != 'all') 
      {
        fields.add('subcategory');
        values.add(arguments['subcategory']);    
      }
    }

    if(arguments['difficulty'] != 'all') {
      fields.add('difficulty');
      values.add(arguments['difficulty']);
    }

    fields.add('academicLevel');
    values.add(arguments['academicLevel']);

    problems = await getMultipleEqualToQueriedCollection(
      'problems', 
      fields, 
      values,
    );
    
    Navigator.pop(context);

    if(problems.isEmpty)
    {
      showFailureBottomSheet(context, 'No existen problemas', 'Parece que no hay problemas registrados para esta categoria', false);

      await Future.delayed(const Duration(seconds: 5));

      Navigator.pop(context);
      Navigator.pop(context);
      
      return;
    }

    problemLength = problems.length - 1;

    problemData = problems[currentProblem];

    setState(() {});

    _startTimer();
  }

  @override void initState() 
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }
  
  @override
  Widget build(BuildContext context) 
  {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (BuildContext context) 
                {
                  return CupertinoAlertDialog(
                  title: const Text('¿Desea regresar?'),
                  content: TextButton(
                    onPressed: ()
                    {
                      _stopTimer();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Regresar"),
                  ),
                );  
                }
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.red,),
          ),
            title: Text("${arguments['category']} (${currentProblem+1}/${problemLength+1})",
              style: const TextStyle(
              
              color: Colors.white,
              fontSize: 25,
              ),
            ),
            centerTitle: true,
        ),
    
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTimer(),

              Expanded(
                child: Center(
                  child: TeXView(
                    child: TeXViewColumn(
                      children: [
                        TeXViewDocument('<h3>${problemData['title']}</h3>', 
                          style: TeXViewStyle(
                            backgroundColor: Colors.blue[700],
                            borderRadius: const TeXViewBorderRadius.only(topLeft: 10, topRight: 10),
                            textAlign: TeXViewTextAlign.center,
                            padding: const TeXViewPadding.only(bottom: 20, top: 20, left: 20, right: 20),
                            contentColor: Colors.white
                          )
                        ),

                        TeXViewDocument('<h4>${problemData['category']}: ${problemData['subcategory'] == 'all' ? 'Cualquiera' : problemData['subcategory']}</h4>', 
                          style: TeXViewStyle(
                            backgroundColor: Colors.yellow[800],
                            textAlign: TeXViewTextAlign.center,
                            padding: const TeXViewPadding.only(bottom: 10, top: 10, left: 20, right: 20),
                            contentColor: Colors.white
                          )
                        ),

                        _buildDifficultyTitle(problemData['difficulty']),

                        TeXViewDocument('<p>${problemData['paragraph']}</p>', 
                          style: const TeXViewStyle(
                            textAlign: TeXViewTextAlign.justify
                          )
                        ),

                        _buildTeXViewAnswer(problemData['answers'][0], 'A'),
                        _buildTeXViewAnswer(problemData['answers'][1], 'B'),
                        _buildTeXViewAnswer(problemData['answers'][2], 'C'),
                        _buildTeXViewAnswer(problemData['answers'][3], 'D'),

                      ]
                    )
                  ),
                ),
              ),

              _buildAnswers()
            ]
          ),
        )
      ),
    );
  }

  Widget _buildTimer()
  {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(_result, 
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300
          ),
        ),
        const Align(
          alignment: Alignment.centerRight, 
          child: Icon(Icons.timer, size: 30,),
        )
      ],
    );
  }

  Widget _buildAnswers()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Selecciona una respuesta',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15
          ),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnswerButton(1, 'A', Colors.blue[500]),

              _buildAnswerButton(2, 'B', Colors.blue[600]),
            ],
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnswerButton(3, 'C', Colors.blue[700]),

            _buildAnswerButton(4, 'D', Colors.blue[800]),
          ],
        ),
      ],
    );
  }

  TeXViewWidget _buildDifficultyTitle(String difficulty)
  {

    String difficultyUI = '';
    Color? color = Colors.blue[500];

    if(difficulty == 'easy') 
    {
      difficultyUI = 'Fácil';
      color = Colors.green[500];
    }

    else if(difficulty == 'normal') 
    {
      difficultyUI = 'Medio';
      color = Colors.yellow[800];
    }

    else if(difficulty == 'hard')
    { 
      difficultyUI = 'Díficil';
      color = Colors.red[500];
    }

    else if(difficulty == 'expert')
    {
      difficultyUI = 'Experto';
      color = Colors.red[900];
    }
  
    return TeXViewDocument('<h5>$difficultyUI</h5>', 
      style: TeXViewStyle(
        backgroundColor: color,
        borderRadius: const TeXViewBorderRadius.only(bottomLeft: 10, bottomRight: 10),
        textAlign: TeXViewTextAlign.center,
        padding: const TeXViewPadding.only(bottom: 10, top: 10, left: 20, right: 20),
        margin: const TeXViewMargin.only(bottom: 10),
        contentColor: Colors.white
      )
    );
  }

  Widget _buildAnswerButton(int answerId, String message, Color? backgroundColor)
  {
    return SizedBox(
      height: 50,
      width: 150,
      child: TextButton(
        onPressed: () async 
        {
          _stopTimer();

          if(answerId != int.parse(problemData['solution']))
          {
            showFailureBottomSheet(context, 'Respuesta incorrecta', 'Intenta de nuevo');
            attemps++;
            _startTimer();
            return;
          }
         
          showSuccessBottomSheet(context, '¡Respuesta correcta!', 'Cargando siguiente problema...', false);
          
          var responseData = {
            'scholarKey': arguments['scholarKey'],
            'problemId': problemData['uid'],
            'attemps': attemps,
            'elapsedTime': _stopwatch.elapsed.inSeconds,
            'date': {
              'day': DateTime.now().day,
              'month': DateTime.now().month,
              'year': DateTime.now().year
            }
          };

          if(!await existsInternet())
          {
            uploadDocument('responses', responseData);
            await Future.delayed(const Duration(seconds: 2));
          }
          else
          {
            await uploadDocument('responses', responseData);
            await Future.delayed(const Duration(seconds: 2));
          }

          Navigator.pop(context);

          if(currentProblem >= problemLength)
          {
            showWarningBottomSheet(context, 'No quedan mas problemas', 'Regresando a la seccion de categorias', false);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.pop(context);
            return;
          }

          currentProblem++;
          problemData = problems[currentProblem];
          attemps = 1;
          _resetTimer();
          _startTimer();

          setState(() {});
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          
        ), 
        child: Text(message, 
          style: const TextStyle(
            color: Colors.white
          ),
          )
      ),
    );
  }

  TeXViewWidget _buildTeXViewAnswer(String answer, String answerIdentifier)
  {
    return TeXViewDocument('<h5>$answerIdentifier) $answer</h5>', 
      style: const TeXViewStyle(
        
        borderRadius: TeXViewBorderRadius.all(10),
        
        padding: TeXViewPadding.only(bottom: 10, top: 10, left: 20, right: 20),
        margin: TeXViewMargin.only(top: 10,),
        contentColor: Colors.black
      )
    );
  }
}

