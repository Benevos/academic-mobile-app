import 'package:calcula_uat/services/firebase_service.dart';
import 'package:calcula_uat/utils/scripts/global_functions.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget
{
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen>
{
  final TextEditingController scholarKeyController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController institutionNameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmedPasswordController =
      TextEditingController();

  bool validateScholarKey = false;
  bool validateEmail = false;
  bool validateInstitutionName = false;
  bool validatePassword = false;
  bool validateConfirmedPassword = false;

  String? scholarKeyErrorMessage;
  String? emailErrorMessage;
  String? institutionNameErrorMessage;
  String? passwordErrorMessage;
  String? confirmedPasswordErrorMessage;

  bool collegeChecked = false;
  bool highSchoolChecked = false;
  bool middleSchoolChecked = false;
  bool elementarySchoolChecked = false;

  @override
  void initState()
  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_)
      {
        _checkInternetOnStart();
      },
    );
  }

  Future<void> _checkInternetOnStart() async
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
        'Advertencia',
        'Debe estar conectado a internet para registrar una institución',
      );
    }
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

  void _resetValidation()
  {
    validateScholarKey = false;
    validateEmail = false;
    validateInstitutionName = false;
    validatePassword = false;
    validateConfirmedPassword = false;

    scholarKeyErrorMessage = null;
    emailErrorMessage = null;
    institutionNameErrorMessage = null;
    passwordErrorMessage = null;
    confirmedPasswordErrorMessage = null;
  }

  void _clearForm()
  {
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

  Future<void> _registerInstitution() async
  {
    final bool internetAvailable =
        await existsInternet();

    if(!mounted)
    {
      return;
    }

    if(!internetAvailable)
    {
      showFailureBottomSheet(
        context,
        '¡Error!',
        'Debe estar conectado a internet para registrarse',
      );

      return;
    }

    _resetValidation();

    final List<TextEditingController> controllerList = [
      scholarKeyController,
      emailController,
      institutionNameController,
      passwordController,
      confirmedPasswordController,
    ];

    final List<bool> emptyTextFieldValidators =
        evaluateEmptyTextFields(
      controllerList,
    );

    validateScholarKey =
        emptyTextFieldValidators[0];

    validateEmail =
        emptyTextFieldValidators[1];

    validateInstitutionName =
        emptyTextFieldValidators[2];

    validatePassword =
        emptyTextFieldValidators[3];

    validateConfirmedPassword =
        emptyTextFieldValidators[4];

    bool validateForm =
        emptyTextFieldValidators[5];

    scholarKeyErrorMessage =
        validateScholarKey
            ? 'No deje espacios vacíos'
            : null;

    emailErrorMessage =
        validateEmail
            ? 'No deje espacios vacíos'
            : null;

    institutionNameErrorMessage =
        validateInstitutionName
            ? 'No deje espacios vacíos'
            : null;

    passwordErrorMessage =
        validatePassword
            ? 'No deje espacios vacíos'
            : null;

    confirmedPasswordErrorMessage =
        validateConfirmedPassword
            ? 'No deje espacios vacíos'
            : null;

    if(
      confirmedPasswordController.text.isNotEmpty
    )
    {
      validateConfirmedPassword =
          evalauteNotCoincidentPasswords(
        passwordController,
        confirmedPasswordController,
      );

      if(validateConfirmedPassword)
      {
        confirmedPasswordErrorMessage =
            'Las contraseñas no coinciden';

        validateForm = true;
      }
    }

    final int checkedLevels = [
      collegeChecked,
      highSchoolChecked,
      middleSchoolChecked,
      elementarySchoolChecked,
    ].where(
      (checked) => checked,
    ).length;

    if(checkedLevels == 0)
    {
      validateForm = true;
    }

    if(mounted)
    {
      setState(() {});
    }

    if(validateForm)
    {
      if(
        checkedLevels == 0 &&
        mounted
      )
      {
        showFailureBottomSheet(
          context,
          'Error',
          'Seleccione al menos un nivel académico',
        );
      }

      return;
    }

    final String scholarKey =
        scholarKeyController.text
            .trim()
            .toUpperCase();

    final List scholarKeys =
        await getSingleConditionQueriedCollection(
      'institutions',
      'scholarKey',
      '==',
      scholarKey,
    );

    if(!mounted)
    {
      return;
    }

    if(scholarKeys.isNotEmpty)
    {
      setState(()
      {
        scholarKeyErrorMessage =
            'Clave ya existente';

        validateScholarKey = true;
      });

      return;
    }

    final List<String?> academicLevels = [
      collegeChecked
          ? 'college'
          : null,

      highSchoolChecked
          ? 'high'
          : null,

      middleSchoolChecked
          ? 'middle'
          : null,

      elementarySchoolChecked
          ? 'elementary'
          : null,
    ];

    final Map<String, dynamic>
        institutionData = {
      'scholarKey':
          scholarKey,

      'email':
          emailController.text
              .trim()
              .toLowerCase(),

      'institutionName':
          institutionNameController.text
              .trim(),

      'password':
          passwordController.text,

      'academicLevel':
          academicLevels,
    };

    showProgressBottomSheet(
      context,
      'Registrando...',
    );

    try
    {
      await uploadDocument(
        'institutions',
        institutionData,
      );

      if(!mounted)
      {
        return;
      }

      Navigator.pop(context);

      showSuccessBottomSheet(
        context,
        '¡Éxito!',
        'Se ha registrado su institución exitosamente. '
        'Ahora puede utilizar la aplicación web de Calcula UAT '
        'para crear sus problemas personalizados.',
      );

      setState(()
      {
        _clearForm();
        _resetValidation();
      });
    }
    catch(error)
    {
      if(!mounted)
      {
        return;
      }

      Navigator.pop(context);

      showFailureBottomSheet(
        context,
        '¡Error!',
        'Registro fallido',
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          'Registrarse',

          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight:
                FontWeight.w300,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.all(15),

            child: Column(
              children: [

                Container(
                  padding:
                      const EdgeInsets.fromLTRB(
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
                  margin:
                      const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller:
                        scholarKeyController,

                    keyboardType:
                        TextInputType.text,

                    textCapitalization:
                        TextCapitalization
                            .characters,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Clave escolar',

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
                  margin:
                      const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller:
                        emailController,

                    keyboardType:
                        TextInputType
                            .emailAddress,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Correo electrónico',

                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validateEmail
                              ? emailErrorMessage
                              : null,
                    ),
                  ),
                ),

                Container(
                  margin:
                      const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller:
                        institutionNameController,

                    keyboardType:
                        TextInputType.text,

                    textCapitalization:
                        TextCapitalization
                            .words,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Nombre de la institución',

                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validateInstitutionName
                              ? institutionNameErrorMessage
                              : null,
                    ),
                  ),
                ),

                Container(
                  margin:
                      const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    10,
                  ),

                  child: TextField(
                    controller:
                        passwordController,

                    obscureText: true,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Contraseña',

                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validatePassword
                              ? passwordErrorMessage
                              : null,
                    ),
                  ),
                ),

                Container(
                  margin:
                      const EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    30,
                  ),

                  child: TextField(
                    controller:
                        confirmedPasswordController,

                    obscureText: true,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Confirmar contraseña',

                      border:
                          const OutlineInputBorder(),

                      errorText:
                          validateConfirmedPassword
                              ? confirmedPasswordErrorMessage
                              : null,
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    'Nivel académico',

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.orange[800],
                    ),
                  ),
                ),

                Row(
                  children: [
                    Checkbox(
                      value:
                          collegeChecked,

                      onChanged:
                          (bool? value)
                      {
                        setState(()
                        {
                          collegeChecked =
                              value ?? false;
                        });
                      },
                    ),

                    Text(
                      'Universidad',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.blue[600],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value:
                          highSchoolChecked,

                      onChanged:
                          (bool? value)
                      {
                        setState(()
                        {
                          highSchoolChecked =
                              value ?? false;
                        });
                      },
                    ),

                    Text(
                      'Preparatoria',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.blue[700],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value:
                          middleSchoolChecked,

                      onChanged:
                          (bool? value)
                      {
                        setState(()
                        {
                          middleSchoolChecked =
                              value ?? false;
                        });
                      },
                    ),

                    Text(
                      'Secundaria',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.blue[800],
                      ),
                    ),
                  ],
                ),

                Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 30,
                  ),

                  child: Row(
                    children: [
                      Checkbox(
                        value:
                            elementarySchoolChecked,

                        onChanged:
                            (bool? value)
                        {
                          setState(()
                          {
                            elementarySchoolChecked =
                                value ?? false;
                          });
                        },
                      ),

                      Text(
                        'Primaria',

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 50,
                  width: 250,

                  child: TextButton(
                    style:
                        const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(
                        Colors.blue,
                      ),
                    ),

                    onPressed:
                        _registerInstitution,

                    child: const Text(
                      'Registrar',

                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 20,
                      ),
                    ),
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
