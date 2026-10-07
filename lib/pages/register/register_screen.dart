import 'package:calcula_uat/utils/scripts/global_functions.dart';
import 'package:calcula_uat/services/firebase_service.dart';
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

  bool collegeChecked = false;
  bool highSchoolChecked = false;
  bool middleSchoolChecked = false;
  bool elementarySchoolChecked = false;

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
                  child: Center(child: Image.asset('lib/assets/uat.jpeg'))
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

                Center(
                  child: Text('Nivel academico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange[800])),
                ),
                
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Checkbox(value: collegeChecked, 
                      onChanged: (bool? value)
                      {
                        collegeChecked = !collegeChecked;
                        setState(() {
                          
                        });
                      }),
                      Text('Universidad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]))
                    ],
                  )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Checkbox(value: highSchoolChecked, 
                      onChanged: (bool? value)
                      {
                        highSchoolChecked = !highSchoolChecked;
                        setState(() {
                          
                        });
                      }),
                      Text('Preparatoria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]))
                    ],
                  )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Checkbox(value: middleSchoolChecked, 
                      onChanged: (bool? value)
                      {
                        middleSchoolChecked = !middleSchoolChecked;
                        setState(() {
                          
                        });
                      }),
                      Text('Secundaria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]))
                    ],
                  )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Row(
                    children: [
                      Checkbox(value: elementarySchoolChecked, 
                      onChanged: (bool? value)
                      {
                        elementarySchoolChecked = !elementarySchoolChecked;
                        setState(() {
                          
                        });
                      }),
                      Text('Primaria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]))
                    ],
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

                      int checkboxesChecked = 0;

                      if(collegeChecked) checkboxesChecked++;
                      if(highSchoolChecked) checkboxesChecked++;
                      if(middleSchoolChecked) checkboxesChecked++;
                      if(elementarySchoolChecked) checkboxesChecked++;

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

                      if(checkboxesChecked <= 0)
                      {
                        showFailureBottomSheet(context, 'Error', "Seleccione al menos un nivel acádemico");
                        validateForm = true;
                      }

                      if(validateForm)
                      {
                        setState(() {});
                        return;
                      }

                      final academicLevels = [
                        collegeChecked ? 'college' : null,
                        highSchoolChecked ? 'high' : null,
                        middleSchoolChecked ? 'middle' : null,
                        elementarySchoolChecked ? 'elementary' : null
                      ];
                      
                      final insitutionData = {
                        'scholarKey': scholarKeyController.text.toUpperCase(),
                        'email': emailController.text.toLowerCase(),
                        'institutionName': institutionNameController.text,
                        'password': passwordController.text,
                        'academicLevel': academicLevels
                      };
                      
                      showProgressBottomSheet(context, 'Registrando...');

                      try
                      {    
                        await uploadDocument('institutions', insitutionData);
                          
                        Navigator.pop(context);

                        showSuccessBottomSheet(context, '¡Éxito!', 'Se ha registrado su institución exitosamente, ahora puede ir a la web a crear sus problemas personalizados en https://www.academic-web-app-v2.vercel.app');

                        collegeChecked = false;
                        highSchoolChecked = false;
                        middleSchoolChecked = false;
                        elementarySchoolChecked = false;
                        
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

