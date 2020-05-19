import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
class ToolsPage extends StatefulWidget{

  ToolsPage({Key key,}) : super(key: key);
  @override
  State<StatefulWidget> createState() {


    return _ToolsPageState();
  }
  
}
class _ToolsPageState extends State<ToolsPage>{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("工具"),
      ),
//backgroundColor: Colors.black,
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:GridView.builder(
            itemCount: 50,
            padding: EdgeInsets.symmetric(horizontal: 0),
            physics:BouncingScrollPhysics() ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ), itemBuilder: (context,index){

          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(child: Text("item" + index.toString()),
            color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1.0),
            alignment: Alignment.center,
          ),);

        }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}