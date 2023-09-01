import 'package:empty_app/utils/scripts/global_functions.dart';
import 'package:empty_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget 
{
  const RegisterScreen({
    //required Map<String, dynamic> colors, 
    super.key
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> 
{
  TextEditingController scholarKeyController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController institutionNameController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmedPasswordController = TextEditingController(text: "");

  bool validateScholarKey = false;
  bool validateEmail = false;
  bool validateInsitutionName = false;
  bool validatePassword = false;
  bool validateConfirmedPassword = false;

  String? scholarKeyErrorMessage = "";
  String? emailErrorMessage = "";
  String? insitutionNameErrorMessage= "";
  String? passwordErrorMessage = "";
  String? confirmedPasswordErrorMessage = "";

  String statusModalMessage = "";
  bool modalErorr = false;

  @override void initState() 
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      void asyncFunction() async 
      {
        if(!await existsInternet())
        {
          showWarningBottomSheet(context, 'Advertencia', 'Debe estar conectado a internet para registrar una institución');
        }
      }

      asyncFunction();
    });
  }

  @override
  void dispose()
  {
    scholarKeyController.dispose();
    emailController.dispose();
    institutionNameController.dispose();
    passwordController.dispose();
    confirmedPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registrarse', 
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
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Correo electronico',
                      border: const OutlineInputBorder(),
                      errorText: validateEmail ? emailErrorMessage : null
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    controller: institutionNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la institución',
                      border: const OutlineInputBorder(),
                      errorText: validateInsitutionName ? insitutionNameErrorMessage : null
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
                
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: TextField(
                    controller: confirmedPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      border: const OutlineInputBorder(),
                      errorText: validateConfirmedPassword ? confirmedPasswordErrorMessage : null
                    ),
                  ),
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
                      bool isInternet = await existsInternet();

                      if(!isInternet)
                      {
                        showFailureBottomSheet(context, "¡Error!",'Debe estar conectado a internet para registrarse');
                        return;
                      }
                      
                      validateInsitutionName = false;
                      validateEmail = false;
                      validatePassword = false;
                      validateScholarKey = false;
                      validateConfirmedPassword = false;
                      var validateForm = false;

                      setState(() {});

                      List<TextEditingController> contorllerList = [scholarKeyController, emailController, institutionNameController, passwordController, confirmedPasswordController];

                      List<bool> emptyTextFieldValidators = evaluateEmptyTextFields(contorllerList);

                      validateScholarKey = emptyTextFieldValidators[0];
                      validateEmail = emptyTextFieldValidators[1];
                      validateInsitutionName = emptyTextFieldValidators[2];
                      validatePassword = emptyTextFieldValidators[3];
                      validateConfirmedPassword = emptyTextFieldValidators[4];
                      validateForm = emptyTextFieldValidators[5];
                      
                      scholarKeyErrorMessage = validateScholarKey ? 'No deje espacios vacios' : null;
                      emailErrorMessage = validateEmail ? 'No deje espacios vacios' : null;
                      insitutionNameErrorMessage = validateInsitutionName ? 'No deje espacios vacios' : null;
                      passwordErrorMessage = validatePassword ? 'No deje espacios vacios' : null;
                      confirmedPasswordErrorMessage = validateConfirmedPassword ? 'No deje espacios vacios' : null;
                      
                      if(confirmedPasswordController.text != "")
                      {
                        validateConfirmedPassword = evalauteNotCoincidentPasswords(passwordController, confirmedPasswordController);

                        if(validateConfirmedPassword)
                        {
                          confirmedPasswordErrorMessage = validateConfirmedPassword ? 'Las contraseñas no coinciden' : null;
                          validateForm = true;
                          setState(() {});
                        }
                      }

                      List scholarKeys = await getSingleConditionQueriedCollection('institutions', 'scholarKey', '==', scholarKeyController.text.trim());

                      if(scholarKeys.isNotEmpty)
                      {
                        validateForm = true;
                        setState(() {
                          scholarKeyErrorMessage = "Clave ya existente";
                          validateScholarKey = true;
                        });
                        return;
                      }

                      if(validateForm)
                      {
                        setState(() {});
                        return;
                      }
                      
                      final insitutionData = {
                        'scholarKey': scholarKeyController.text.toUpperCase(),
                        'email': emailController.text.toLowerCase(),
                        'insitutionName': institutionNameController.text,
                        'password': passwordController.text
                      };
                      
                      showProgressBottomSheet(context, 'Registrando...');

                      try
                      {    
                        await uploadDocument('institutions', insitutionData);
                          
                        Navigator.pop(context);

                        showSuccessBottomSheet(context, '¡Éxito!', 'Se ha registrado su institución exitosamente, ahora puede ir a la web a crear sus problemas personalizados');

                        scholarKeyController.clear();
                        emailController.clear();
                        institutionNameController.clear();
                        passwordController.clear();
                        confirmedPasswordController.clear();
                      }
                      catch(e)
                      {
                        Navigator.pop(context);
                        
                        showFailureBottomSheet(context, "¡Error!", "Registro fallido");
                      }
                    }, 

                    child: const Text('Registrar',
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

