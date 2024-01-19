import 'package:empty_app/services/firebase_service.dart';
import 'package:empty_app/utils/scripts/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget 
{
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    //String scholarKey = arguments['scholarKey'];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Dashboard',
            style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300
            ),
          ),
          centerTitle: true,
          leading: _buildLogoutButton(context)
        ),
        body: Center(
          child: SingleChildScrollView(
        
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child:  const Text('Seleccione una categoia', style: TextStyle(fontWeight: FontWeight.w700, fontSize:20), textAlign: TextAlign.center,),
                ),

                FutureBuilder(
                  future: getSingleConditionQueriedCollection('institutions', 'scholarKey', '==', arguments['scholarKey']), 
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot)
                  {
                    List<Widget> children = [];
                    
                    if(snapshot.hasData)
                    {
                      snapshot.data![0]['academicLevel'][0] == 'college' ? children.add(_buildCategoryButton(context, arguments, 15, 'college', 'Universidad', Colors.blue[600])) : '';
                      snapshot.data![0]['academicLevel'][1] == 'high' ? children.add(_buildCategoryButton(context, arguments, 15, 'high', 'Preparatoria', Colors.blue[700])) : '';
                      snapshot.data![0]['academicLevel'][2] == 'middle' ? children.add(_buildCategoryButton(context, arguments, 15, 'middle', 'Secundaria', Colors.blue[800])) : '';
                      snapshot.data![0]['academicLevel'][3] == 'elementary' ? children.add(_buildCategoryButton(context, arguments, 0, 'elementary', 'Primaria', Colors.blue[900])) : '';
                    }

                    return Column(children: children,);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }  

  Widget _buildLogoutButton(BuildContext context)
  {
    return IconButton(
      onPressed: ()
      {
        showDialog(
          context: context, 
          builder: (BuildContext context) 
          {
            return CupertinoAlertDialog(
              title: const Text('¿Cerrar sesión?'),
              content: TextButton(
                onPressed: ()
                {   
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, 
                child: SizedBox(
                  child: TextButton(
                    onPressed: ()
                    {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)
                    ),
                    child: const SizedBox(
                    
                      child: Text("Confirmar", style: TextStyle(color: Colors.white))
                    ), 
                  ),
                )
              ),
            );
          }
        );
        //Navigator.pop(context);
      }, 
      icon: const Icon(Icons.logout, color: Colors.red, size: 30,) 
    );
  }

  Widget _buildCategoryButton(BuildContext context, Map<dynamic, dynamic> arguments, double marginBottom, String academicLevel, String academicLevelUI, Color? color)
  {
    return Container(
      height: 50,
      width: 300,
      margin: EdgeInsets.fromLTRB(0, 0, 0, marginBottom),
      child: TextButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/dashboard/categories', arguments: {
            'scholarKey': arguments['scholarKey'],
            'academicLevel': academicLevel,
            'academicLevelUI': academicLevelUI 
            }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color),
        
        ),
        child: Text(academicLevelUI, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}