import 'package:calcula_uat/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {

    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
          ),
            title: Text("${arguments['category']}: ${arguments['subcategory'] == 'all' ? 'Cualquiera' : arguments['subcategory']}",
              style: const TextStyle(
              
              color: Colors.white,
              fontSize: 25,
              ),
            ),
            centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child:  const Text('Seleccione una dificultad', style: TextStyle(fontWeight: FontWeight.w700, fontSize:20), textAlign: TextAlign.center,),
                ),

                _buildCategoryButton(context, arguments, 15, 'all', 'Cualquiera', Colors.blue[500]),
                _buildCategoryButton(context, arguments, 15, 'easy', 'Fácil', Colors.green[500]),
                _buildCategoryButton(context, arguments, 15, 'normal', 'Medio', Colors.yellow[800]),
                _buildCategoryButton(context, arguments, 15, 'hard', 'Díficil', Colors.red[500]),
                _buildCategoryButton(context, arguments, 15, 'expert', 'Experto', Colors.red[900]),
              ],
            )
          )
        ),
      )
    );
  }

  Widget _buildCategoryButton(BuildContext context, Map<dynamic, dynamic> arguments, double marginBottom, String difficulty, String difficultyUI, Color? color)
  {
    return Container(
      height: 50,
      width: 300,
      margin: EdgeInsets.fromLTRB(0, 0, 0, marginBottom),
      child: TextButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/dashboard/categories/difficulty/problems', arguments: {
            'scholarKey': arguments['scholarKey'],
            'academicLevel': arguments['academicLevel'],
            'academicLevelUI': arguments['academicLevelUI'],
            'category': arguments['category'],
            'subcategory': arguments['subcategory'],
            'difficulty': difficulty, 
            }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color),
        
        ),
        child: Text(difficultyUI, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
