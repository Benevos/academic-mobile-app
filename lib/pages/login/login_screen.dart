import 'package:empty_app/services/firebase_service.dart';
import 'package:empty_app/utils/scripts/global_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget 
{
  const LoginScreen({
    //required Map<String, dynamic> colors, 
    super.key
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
{
  TextEditingController scholarKeyController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  bool validateScholarKey = false;
  bool validatePassword = false;
  
  String? scholarKeyErrorMessage = "";
  String? passwordErrorMessage = "";

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
        title: const Text('Iniciar sesión', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300
            )
          ,)
        ),
      body: SingleChildScrollView(
        child: Center(
          child:  Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 180,
                  //color: Colors.red,
                  child: Center(child: Image.asset('lib/assets/siglas-UAT.png'))
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const Text('Inicie una sesión con la clave de su insitución', textAlign: TextAlign.center,)
                ),
      
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    controller: scholarKeyController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Clave de escolar',
                      border: const OutlineInputBorder(),
                      errorText: validateScholarKey ? scholarKeyErrorMessage : null
                    ),
                  ),
                ),
      
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(),
                      errorText: validatePassword ? passwordErrorMessage : null,
                    ),
                  ),
                ),
      
                TextButton(
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/register');
                  }, 
                  child: const Text('¿Su institución no tiene cuenta? Registrela',
                    style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w800),
                  )
                ),
      
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: () async 
                    {
                      validateScholarKey = false;
                      validatePassword = false;
                      var validateForm = false;

                      setState(() {});

                      List<TextEditingController> contorllerList = [scholarKeyController, passwordController];

                      List<bool> emptyTextFieldValidators = evaluateEmptyTextFields(contorllerList);

                      validateScholarKey = emptyTextFieldValidators[0];
                      validatePassword = emptyTextFieldValidators[1];
                      validateForm = emptyTextFieldValidators[2];

                      scholarKeyErrorMessage = validateScholarKey ? 'No deje espacios vacios' : null;
                      passwordErrorMessage = validatePassword ? 'No deje espacios vacios' : null;

                      if(validateForm)
                      {
                        setState(() {});
                        return;
                      }

                      showProgressBottomSheet(context, 'Iniciando sesion');

                      List institutionData = await getSingleConditionQueriedCollection('institutions', 'scholarKey', '==', scholarKeyController.text.trim().toUpperCase());

                      if(institutionData.isEmpty)
                      {
                        setState(() {
                          validateScholarKey = true;
                          scholarKeyErrorMessage = 'Esta clave no existe';
                        });

                        Navigator.pop(context);

                        return;
                      }

                      if(institutionData[0]['password'] != passwordController.text)
                      {
                        setState(() {
                          validatePassword = true;
                          passwordErrorMessage = 'Contraseña incorrecta';
                        });

                        Navigator.pop(context);

                        return;
                      }

                      Navigator.pop(context);

                      Navigator.pushNamed(context, '/dashboard', arguments: {'scholarKey': scholarKeyController.text.trim().toUpperCase()});

                      scholarKeyController.clear();
                      passwordController.clear();                 
                    }, 

                    child: const Text('Ingresar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}

