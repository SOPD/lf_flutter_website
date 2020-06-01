import 'package:flutter/material.dart';
import 'package:flutterwebtest/home/homeWidget.dart';
import 'package:flutterwebtest/kline/klinePage.dart';
import 'package:flutterwebtest/tools/toolsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

@override
Widget build(BuildContext context) {

  return MaterialApp(
   title: "main",
      debugShowCheckedModeBanner: false,
      onGenerateRoute:  onGenerateRoute,

  );
}
}
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  String routeName = settings.name;

  if (routeName.contains('/artical')) {
    String arg = "";
    if(routeName.length > 10){
      arg =  routeName.substring(9,routeName.length);
    }
    return MaterialPageRoute(builder: (context) { return HomeWidget(arguments: arg,); });
  } else if (routeName.contains('/tool')) {
    return MaterialPageRoute(builder: (context) { return ToolsPage(); });
  }else if (routeName.contains('/kline')) {
    return MaterialPageRoute(builder: (context) { return KlinePage(); });
  }else{
  return  MaterialPageRoute(builder: (context) { return HomeWidget(); });
  }
}
