import 'package:flutter/cupertino.dart';
import 'package:empty_app/utils/scripts/global_functions.dart';
import 'package:empty_app/services/firebase_service.dart';

Future<void> answerButtonFlow(BuildContext context, int answerId, Map<String, dynamic> problemData, Stopwatch _stopwatch, int currentProblem, int problemLength, Map<dynamic, dynamic> arguments) async 
{
  bool isCorrect = false;

  if(answerId != int.parse(problemData['solution']))
  {
    showFailureBottomSheet(context, 'Respuesta incorrecta', 'Intenta de nuevo', false);
  }
  else
  {
    isCorrect = true;
    showSuccessBottomSheet(context, '¡Respuesta correcta!', 'Cargando siguiente problema...', false);
  }

  var responseData = {
    'scholarKey': arguments['scholarKey'],
    'problemId': problemData['uid'],
    'selectedAnswer': answerId,
    'isCorrect': isCorrect,
    'elapsedTime': {
      'minutes': _stopwatch.elapsed.inMinutes,
      'seconds': _stopwatch.elapsed.inSeconds
    },
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
}