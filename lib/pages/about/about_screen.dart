import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 10, 16, 23),
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 16, 23),
        centerTitle: true,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Text('Contacto', 
          style: TextStyle(
            color: Colors.blue[500],
            fontSize: 30,
            fontWeight: FontWeight.w300
            )
          ,)
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.clipboard, color: Colors.white70,),
                  TextButton(
                    onPressed: () async
                    {
                      await Clipboard.setData(const ClipboardData(text: 'kevin_mendoza092@hotmail.com'));
                    },
                    child: const Text('kevin_mendoza092@hotmail.com', style: TextStyle(color: Colors.white),)
                  ),
                ],
              ),

              const Text('Hola, mi nombre es ', style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
              ),),

              Text('Kevin', style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue[500]
              ), ),

              Text('Fullstack Developer', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[200]
              ),),
                
              const SizedBox(height: 10,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[500],
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: IconButton(
                      onPressed: () async 
                      {
                        var uri = Uri.parse('https://www.linkedin.com/in/kevin-daniel-mendoza-hern%C3%A1ndez-68362623a/');
                    
                        await launchUrl(uri);
                      }, 
                      icon: const Icon(FontAwesomeIcons.linkedinIn, color: Colors.white, size: 37,)
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 33, 33, 33),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: IconButton(
                      onPressed: () async 
                      {
                        var uri = Uri.parse('https://github.com/benevos/');
                    
                        await launchUrl(uri);
                      }, 
                      icon: const Icon(FontAwesomeIcons.github, color: Colors.white, size: 37,)
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 94, 170),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: IconButton(
                      onPressed: () async 
                      {
                        var uri = Uri.parse('https://benevos.vercel.app/');
                    
                        await launchUrl(uri);
                      }, 
                      icon: const Icon(FontAwesomeIcons.briefcase, color: Colors.white, size: 37,)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}