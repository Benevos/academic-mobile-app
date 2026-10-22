import 'package:calcula_uat/services/firebase_service.dart';
import 'package:calcula_uat/utils/scripts/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  final TextEditingController scholarKeyController =
      TextEditingController(text: '');

  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool validateScholarKey = false;
  bool validatePassword = false;

  String? scholarKeyErrorMessage = '';
  String? passwordErrorMessage = '';

  @override
  void dispose()
  {
    scholarKeyController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Iniciar sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),

            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    20,
                    0,
                    20,
                  ),
                  width: 180,
                  child: Center(
                    child: Image.asset(
                      'lib/assets/uat.jpeg',
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: const Text(
                    'Inicie una sesión con la clave de su institución',
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller: scholarKeyController,
                    keyboardType: TextInputType.text,
                    textCapitalization:
                        TextCapitalization.characters,

                    decoration: InputDecoration(
                      labelText: 'Clave escolar',
                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validateScholarKey
                              ? scholarKeyErrorMessage
                              : null,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller: passwordController,
                    obscureText: true,

                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validatePassword
                              ? passwordErrorMessage
                              : null,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: ()
                  {
                    Navigator.pushNamed(
                      context,
                      '/register',
                    );
                  },

                  child: const Text(
                    '¿Su institución no tiene cuenta? Regístrela',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  width: 250,

                  child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(
                        Colors.blue,
                      ),
                    ),

                    onPressed: () async
                    {
                      validateScholarKey = false;
                      validatePassword = false;

                      var validateForm = false;

                      setState(() {});

                      final List<TextEditingController>
                          controllerList = [
                        scholarKeyController,
                        passwordController,
                      ];

                      final List<bool>
                          emptyTextFieldValidators =
                          evaluateEmptyTextFields(
                        controllerList,
                      );

                      validateScholarKey =
                          emptyTextFieldValidators[0];

                      validatePassword =
                          emptyTextFieldValidators[1];

                      validateForm =
                          emptyTextFieldValidators[2];

                      scholarKeyErrorMessage =
                          validateScholarKey
                              ? 'No deje espacios vacíos'
                              : null;

                      passwordErrorMessage =
                          validatePassword
                              ? 'No deje espacios vacíos'
                              : null;

                      if(validateForm)
                      {
                        setState(() {});
                        return;
                      }

                      showProgressBottomSheet(
                        context,
                        'Iniciando sesión',
                      );

                      final List institutionData =
                          await getSingleConditionQueriedCollection(
                        'institutions',
                        'scholarKey',
                        '==',
                        scholarKeyController.text
                            .trim()
                            .toUpperCase(),
                      );

                      /*
                       * The widget may have been removed
                       * while Firestore was responding.
                       */
                      if(!mounted)
                      {
                        return;
                      }

                      if(institutionData.isEmpty)
                      {
                        setState(()
                        {
                          validateScholarKey = true;

                          scholarKeyErrorMessage =
                              'Esta clave no existe';
                        });

                        Navigator.pop(context);

                        return;
                      }

                      if(
                        institutionData[0]['password'] !=
                            passwordController.text
                      )
                      {
                        setState(()
                        {
                          validatePassword = true;

                          passwordErrorMessage =
                              'Contraseña incorrecta';
                        });

                        Navigator.pop(context);

                        return;
                      }

                      Navigator.pop(context);

                      Navigator.pushNamed(
                        context,
                        '/dashboard',

                        arguments: {
                          'scholarKey':
                              scholarKeyController.text
                                  .trim()
                                  .toUpperCase(),
                        },
                      );

                      scholarKeyController.clear();
                      passwordController.clear();
                    },

                    child: const Text(
                      'Ingresar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: ()
                  {
                    Navigator.pushNamed(
                      context,
                      '/about',
                    );
                  },

                  child: const Text(
                    'Contacto del desarrollador',
                  ),
                ),

                TextButton(
                  onPressed: () async
                  {
                    final Uri uri = Uri.parse(
                      'https://academic-web-app-v2.vercel.app/privacy',
                    );

                    await launchUrl(uri);
                  },

                  child: const Text(
                    'Aviso de privacidad',
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
