import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

Future<bool> existsInternet() async
{
  try
  {
    final result = await InternetAddress
        .lookup('firestore.googleapis.com')
        .timeout(const Duration(seconds: 3));

    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  }
  on SocketException catch (_)
  {
    return false;
  }
  on TimeoutException catch (_)
  {
    return false;
  }
}

List<bool> evaluateEmptyTextFields(List<TextEditingController> contorllerList)
{
  List<bool> textFieldEvaluators = [];
  bool badForm = false;

  for (var controller in contorllerList) 
  {
    if (controller.text.trim() == "") 
    {
      textFieldEvaluators.add(true);
      badForm = true;
      continue;
    }

    textFieldEvaluators.add(false);
  }

  textFieldEvaluators.add(badForm);

  return textFieldEvaluators;
}

bool evalauteNotCoincidentPasswords(TextEditingController passwordController, TextEditingController confirmedPasswordController)
{
  bool notEqualPasswords = false;

    if(passwordController.text != confirmedPasswordController.text)
    {
      notEqualPasswords = true;
    }

  return notEqualPasswords;
}

void showFailureBottomSheet(BuildContext context, String title, String message, [bool? isDismissible = true])
{
  showModalBottomSheet<void>(
    isDismissible: isDismissible!,
    context: context, 
    backgroundColor: const Color.fromARGB(255, 255, 211, 207),
    builder: (BuildContext context)
    {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 15),
                Text(message, textAlign: TextAlign.center ,style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 15),
                const Icon(Icons.error, size: 60, color: Colors.red) 
              ]),
          ),
        ),
      );
    }
  );
}

void showSuccessBottomSheet(BuildContext context, String title, String message, [bool? isDismissible = true])
{
  showModalBottomSheet<void>(
    isDismissible: isDismissible!,
    backgroundColor: const Color.fromARGB(255, 183, 233, 184),
    context: context, 
    builder: (BuildContext context)
    {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 15),
                Text(message, textAlign: TextAlign.center ,style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 15),
                const Icon(Icons.check_circle, size: 60, color: Colors.green)  
              ]),
          ),
        ),
      );
    }
  );
}

/* backgroundColor: Color.fromARGB(255, 183, 233, 184),
    context: context, 
    builder: (BuildContext context)
    {
      return SizedBox(
        height: 200,
        child: Center
        (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              const Icon(Icons.check_circle, size: 60, color: Colors.green) 
            ]),
        ),
      );
    }
  ); */

void showWarningBottomSheet(BuildContext context, String title, String message, [bool? isDismissible = true])
{
  showModalBottomSheet<void>(
    isDismissible: isDismissible!,
    backgroundColor: const Color.fromARGB(255, 250, 233, 197),
    context: context, 
    builder: (BuildContext context)
    {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 15),
                Text(message, textAlign: TextAlign.center ,style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 15),
                const Icon(Icons.dangerous, size: 60, color: Color.fromARGB(255, 255, 193, 59)) 
              ]),
          ),
        ),
      );
    }
  );
}

void showProgressBottomSheet(BuildContext context, String message)
{
  showModalBottomSheet<void>(
    context: context, 
    isDismissible: false,
    builder: (BuildContext context)
    {
      return WillPopScope(
        onWillPop: () async => false,
        child: SizedBox(
          height: 200,
          child: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const CircularProgressIndicator() //const Icon(Icons.error, size: 60, color: Colors.red) 
              ]),
          ),
        ),
      );
    }
  );
}
