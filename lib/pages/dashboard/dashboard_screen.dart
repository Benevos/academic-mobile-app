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
                  child:  const Text('Seleccione una categoria para empezar', style: TextStyle(fontWeight: FontWeight.w700, fontSize:20), textAlign: TextAlign.center,),
                ),
            
                Column(
                  children: [
                    _buildCategoryButton(context, arguments, 10, 'elementary', 'Primaria', Colors.blue[600]),
                    _buildCategoryButton(context, arguments, 10, 'middle', 'Secundaria', Colors.blue[700]),
                    _buildCategoryButton(context, arguments, 10, 'high', 'Preparatoria', Colors.blue[800]),
                    _buildCategoryButton(context, arguments, 10, 'college', 'Universidad', Colors.blue[900]),
                    _buildCategoryButton(context, arguments, 0, 'high', 'Clave de acceso', Colors.orange[800]),
                  ]
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

  Widget _buildCategoryButton(BuildContext context, Map<dynamic, dynamic> arguments, double marginBottom, String category, String categoryUI, Color? color)
  {
    return Container(
      height: 50,
      width: 300,
      margin: EdgeInsets.fromLTRB(0, 0, 0, marginBottom),
      child: TextButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/dashboard/problems', arguments: {
            'scholarKey': arguments['scholarKey'],
            'category': category,
            'categoryUI': categoryUI 
            }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color),
        
        ),
        child: Text(categoryUI, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}