import 'package:calcula_uat/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
            title: Text("${arguments['academicLevelUI']}",
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
                  child:  const Text('Seleccione una categoria', style: TextStyle(fontWeight: FontWeight.w700, fontSize:20), textAlign: TextAlign.center,),
                ),

                FutureBuilder(
                  future: getSingleConditionQueriedCollection('categories', 'scholarKey', '==', arguments['scholarKey']), 
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot)
                  {
                    List<Widget> children = [];
                    
                    if(snapshot.hasData)
                    {
                      for(var category in snapshot.data!)
                      {
                        children.add(
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text('${category['name']}', 
                              style: TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize:20,
                                color: Colors.blue[600]
                              ), 
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );

                        int color = 900;
                        bool isDecreasingColor = true;
                        for(var i = 0; i < category['subcategories'].length; i++)
                        {
                          double marginBottom = 5;
                        
                          if(i == category['subcategories'].length - 1)  marginBottom = 20; 

                          children.add(
                            _buildCategoryButton(
                              context, 
                              arguments, 
                              marginBottom, 
                              category['name'], 
                              category['subcategories'][i], 
                              i == 0 ? Colors.orange[800] : Colors.blue[color])
                          );

                          if(i == 0) continue;

                          if(color > 300 && isDecreasingColor)
                          {
                            color -= 100;
                            continue;
                          }
                          
                          isDecreasingColor = false;
                          
                          if(color <= 900)
                          {
                            color += 100;
                            continue;
                          }

                          isDecreasingColor = true;
                          
                          
                         
                        }
                      }
                    }

                    return Column(children: children,);
                  }
                )
              ]
            )
          )
        ),
      )
    );
  }

  Widget _buildCategoryButton(BuildContext context, Map<dynamic, dynamic> arguments, double marginBottom, String category, String subcategory, Color? color)
  {
    return Container(
      height: 50,
      width: 300,
      margin: EdgeInsets.fromLTRB(0, 0, 0, marginBottom),
      child: TextButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/dashboard/categories/difficulty', arguments: {
            'scholarKey': arguments['scholarKey'],
            'academicLevel': arguments['academicLevel'],
            'academicLevelUI': arguments['academicLevelUI'],
            'difficulty': arguments['difficulty'],
            'category': category,
            'subcategory': subcategory 
            }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color),
        ),
        child: Text(
          subcategory == 'all' ? 'Cualquiera' : subcategory, 
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          )
        ),
      ),
    );
  }
}
