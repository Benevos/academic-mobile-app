import 'dart:async';

import 'package:calcula_uat/services/firebase_service.dart';
import 'package:calcula_uat/utils/scripts/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class ProblemsScreen extends StatefulWidget
{
  const ProblemsScreen({super.key});

  @override
  State<ProblemsScreen> createState() =>
      _ProblemsScreenState();
}

class _ProblemsScreenState
    extends State<ProblemsScreen>
{
  Map arguments = {};

  final Stopwatch _stopwatch =
      Stopwatch();

  Timer? _timer;

  String _result = '00:00';

  List problems = [];

  int problemLength = 0;
  int currentProblem = 0;
  int attemps = 1;

  Map<String, dynamic> problemData = {
    'title': 'Cargando...',
    'paragraph': 'Cargando...',
    'category': 'Cargando...',
    'subcategory': 'Cargando...',
    'difficulty': 'Cargando...',
    'answers': [
      'Cargando...',
      'Cargando...',
      'Cargando...',
      'Cargando...',
    ],
    'solution': '1',
  };

  void _startTimer()
  {
    _timer?.cancel();

    _stopwatch.start();

    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (Timer timer)
      {
        if(!mounted)
        {
          timer.cancel();
          return;
        }

        setState(()
        {
          _result =
              '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:'
              '${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      },
    );
  }

  void _stopTimer()
  {
    _timer?.cancel();
    _timer = null;

    _stopwatch.stop();
  }

  void _resetTimer()
  {
    _stopTimer();

    _stopwatch.reset();

    if(mounted)
    {
      setState(()
      {
        _result = '00:00';
      });
    }
  }

  Future<void> _initializeScreen() async
  {
    final bool internetAvailable =
        await existsInternet();

    if(!mounted)
    {
      return;
    }

    if(!internetAvailable)
    {
      showWarningBottomSheet(
        context,
        'Sin conexión a internet',
        'Los problemas cargados previamente pueden seguir disponibles. '
        'Las respuestas realizadas sin conexión se almacenarán localmente '
        'y Firestore intentará sincronizarlas cuando regrese la conexión. '
        'El contenido que no haya sido almacenado previamente puede no estar disponible.',
        false,
      );

      await Future.delayed(
        const Duration(seconds: 10),
      );

      if(!mounted)
      {
        return;
      }

      Navigator.pop(context);
    }

    if(!mounted)
    {
      return;
    }

    showProgressBottomSheet(
      context,
      'Cargando problemas',
    );

    final route =
        ModalRoute.of(context);

    if(route == null)
    {
      Navigator.pop(context);
      return;
    }

    arguments =
        route.settings.arguments as Map;

    final List<String> fields = [
      'scholarKey'
    ];

    final List<String> values = [
      arguments['scholarKey'].toString()
    ];

    if(arguments['category'] != 'all')
    {
      fields.add('category');

      values.add(
        arguments['category'].toString(),
      );

      if(
        arguments['subcategory'] !=
        'all'
      )
      {
        fields.add('subcategory');

        values.add(
          arguments['subcategory']
              .toString(),
        );
      }
    }

    if(
      arguments['difficulty'] !=
      'all'
    )
    {
      fields.add('difficulty');

      values.add(
        arguments['difficulty']
            .toString(),
      );
    }

    fields.add('academicLevel');

    values.add(
      arguments['academicLevel']
          .toString(),
    );

    problems =
        await getMultipleEqualToQueriedCollection(
      'problems',
      fields,
      values,
    );

    if(!mounted)
    {
      return;
    }

    Navigator.pop(context);

    if(problems.isEmpty)
    {
      showFailureBottomSheet(
        context,
        'No existen problemas',
        'Parece que no hay problemas registrados para esta categoría.',
        false,
      );

      await Future.delayed(
        const Duration(seconds: 5),
      );

      if(!mounted)
      {
        return;
      }

      Navigator.pop(context);
      Navigator.pop(context);

      return;
    }

    problemLength =
        problems.length - 1;

    currentProblem = 0;
    attemps = 1;

    problemData =
        problems[currentProblem];

    setState(() {});

    _startTimer();
  }

  @override
  void initState()
  {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_)
      {
        _initializeScreen();
      },
    );
  }

  @override
  void dispose()
  {
    _timer?.cancel();
    _stopwatch.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final String categoryTitle =
        arguments['category']
            ?.toString() ??
        'Problemas';

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false,

          leading: IconButton(
            onPressed: ()
            {
              showDialog(
                context: context,

                builder:
                    (
                      BuildContext
                          dialogContext,
                    )
                {
                  return CupertinoAlertDialog(
                    title: const Text(
                      '¿Desea regresar?',
                    ),

                    content: TextButton(
                      onPressed: ()
                      {
                        _stopTimer();

                        Navigator.pop(
                          dialogContext,
                        );

                        Navigator.pop(
                          context,
                        );
                      },

                      child: const Text(
                        'Regresar',
                      ),
                    ),
                  );
                },
              );
            },

            icon: const Icon(
              Icons.arrow_back,
              color: Colors.red,
            ),
          ),

          title: Text(
            '$categoryTitle '
            '(${currentProblem + 1}/${problemLength + 1})',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),

          centerTitle: true,
        ),

        body: Container(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            children: [
              _buildTimer(),

              Expanded(
                child: Center(
                  child: TeXView(
                    child: TeXViewColumn(
                      children: [
                        TeXViewDocument(
                          '<h3>${problemData['title']}</h3>',

                          style:
                              TeXViewStyle(
                            backgroundColor:
                                Colors.blue[
                                    700],

                            borderRadius:
                                const TeXViewBorderRadius
                                    .only(
                              topLeft: 10,
                              topRight: 10,
                            ),

                            textAlign:
                                TeXViewTextAlign
                                    .center,

                            padding:
                                const TeXViewPadding
                                    .only(
                              bottom: 20,
                              top: 20,
                              left: 20,
                              right: 20,
                            ),

                            contentColor:
                                Colors.white,
                          ),
                        ),

                        TeXViewDocument(
                          '<h4>'
                          '${problemData['category']}: '
                          '${problemData['subcategory'] == 'all' ? 'General' : problemData['subcategory']}'
                          '</h4>',

                          style:
                              TeXViewStyle(
                            backgroundColor:
                                Colors.yellow[
                                    800],

                            textAlign:
                                TeXViewTextAlign
                                    .center,

                            padding:
                                const TeXViewPadding
                                    .only(
                              bottom: 10,
                              top: 10,
                              left: 20,
                              right: 20,
                            ),

                            contentColor:
                                Colors.white,
                          ),
                        ),

                        _buildDifficultyTitle(
                          problemData[
                                  'difficulty']
                              .toString(),
                        ),

                        TeXViewDocument(
                          '<p>${problemData['paragraph']}</p>',

                          style:
                              const TeXViewStyle(
                            textAlign:
                                TeXViewTextAlign
                                    .justify,
                          ),
                        ),

                        _buildTeXViewAnswer(
                          problemData['answers']
                                  [0]
                              .toString(),
                          'A',
                        ),

                        _buildTeXViewAnswer(
                          problemData['answers']
                                  [1]
                              .toString(),
                          'B',
                        ),

                        _buildTeXViewAnswer(
                          problemData['answers']
                                  [2]
                              .toString(),
                          'C',
                        ),

                        _buildTeXViewAnswer(
                          problemData['answers']
                                  [3]
                              .toString(),
                          'D',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _buildAnswers(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer()
  {
    return Stack(
      alignment: Alignment.center,

      children: [
        Text(
          _result,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 30,
            fontWeight:
                FontWeight.w300,
          ),
        ),

        const Align(
          alignment:
              Alignment.centerRight,

          child: Icon(
            Icons.timer,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildAnswers()
  {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [
        const Text(
          'Selecciona una respuesta',

          style: TextStyle(
            fontWeight:
                FontWeight.w500,
            fontSize: 15,
          ),
        ),

        Container(
          margin:
              const EdgeInsets.fromLTRB(
            0,
            0,
            0,
            5,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,

            children: [
              _buildAnswerButton(
                1,
                'A',
                Colors.blue[500],
              ),

              _buildAnswerButton(
                2,
                'B',
                Colors.blue[600],
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceEvenly,

          children: [
            _buildAnswerButton(
              3,
              'C',
              Colors.blue[700],
            ),

            _buildAnswerButton(
              4,
              'D',
              Colors.blue[800],
            ),
          ],
        ),
      ],
    );
  }

  TeXViewWidget _buildDifficultyTitle(
    String difficulty,
  )
  {
    String difficultyUI = '';

    Color? color =
        Colors.blue[500];

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
      difficultyUI = 'Difícil';
      color = Colors.red[500];
    }
    else if(difficulty == 'expert')
    {
      difficultyUI = 'Experto';
      color = Colors.red[900];
    }

    return TeXViewDocument(
      '<h5>$difficultyUI</h5>',

      style: TeXViewStyle(
        backgroundColor: color,

        borderRadius:
            const TeXViewBorderRadius
                .only(
          bottomLeft: 10,
          bottomRight: 10,
        ),

        textAlign:
            TeXViewTextAlign.center,

        padding:
            const TeXViewPadding.only(
          bottom: 10,
          top: 10,
          left: 20,
          right: 20,
        ),

        margin:
            const TeXViewMargin.only(
          bottom: 10,
        ),

        contentColor:
            Colors.white,
      ),
    );
  }

  Widget _buildAnswerButton(
    int answerId,
    String message,
    Color? backgroundColor,
  )
  {
    return SizedBox(
      height: 50,
      width: 150,

      child: TextButton(
        onPressed: () async
        {
          _stopTimer();

          final int? correctAnswer =
              int.tryParse(
            problemData['solution']
                .toString(),
          );

          if(
            correctAnswer == null ||
            answerId != correctAnswer
          )
          {
            showFailureBottomSheet(
              context,
              'Respuesta incorrecta',
              'Intenta de nuevo',
            );

            attemps++;

            _startTimer();

            return;
          }

          showSuccessBottomSheet(
            context,
            '¡Respuesta correcta!',
            'Cargando siguiente problema...',
            false,
          );

          final Map<String, dynamic>
              responseData = {
            'scholarKey':
                arguments['scholarKey'],

            'problemId':
                problemData['uid'],

            'attemps':
                attemps,

            'elapsedTime':
                _stopwatch
                    .elapsed
                    .inSeconds,

            'date': {
              'day':
                  DateTime.now().day,

              'month':
                  DateTime.now().month,

              'year':
                  DateTime.now().year,
            },
          };

          final bool internetAvailable =
              await existsInternet();

          if(!internetAvailable)
          {
            unawaited(
              uploadDocument(
                'responses',
                responseData,
              ),
            );
          }
          else
          {
            await uploadDocument(
              'responses',
              responseData,
            );
          }

          await Future.delayed(
            const Duration(
              seconds: 2,
            ),
          );

          if(!mounted)
          {
            return;
          }

          Navigator.pop(context);

          if(
            currentProblem >=
            problemLength
          )
          {
            showWarningBottomSheet(
              context,
              'No quedan más problemas',
              'Regresando a la sección de categorías',
              false,
            );

            await Future.delayed(
              const Duration(
                seconds: 2,
              ),
            );

            if(!mounted)
            {
              return;
            }

            Navigator.pop(context);
            Navigator.pop(context);

            return;
          }

          currentProblem++;

          problemData =
              problems[currentProblem];

          attemps = 1;

          _resetTimer();
          _startTimer();

          if(mounted)
          {
            setState(() {});
          }
        },

        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(
            backgroundColor,
          ),
        ),

        child: Text(
          message,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  TeXViewWidget _buildTeXViewAnswer(
    String answer,
    String answerIdentifier,
  )
  {
    return TeXViewDocument(
      '<h5>$answerIdentifier) $answer</h5>',

      style:
          const TeXViewStyle(
        borderRadius:
            TeXViewBorderRadius.all(
          10,
        ),

        padding:
            TeXViewPadding.only(
          bottom: 10,
          top: 10,
          left: 20,
          right: 20,
        ),

        margin:
            TeXViewMargin.only(
          top: 10,
        ),

        contentColor:
            Colors.black,
      ),
    );
  }
}
