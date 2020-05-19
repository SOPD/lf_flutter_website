import 'package:flutter/material.dart';
import 'package:flutterwebtest/network/httpRequester.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../tools/models.dart';
import 'package:flutterwebtest/kline/klinePage.dart';
import 'package:flutterwebtest/tools/toolsPage.dart';

class HomeWidget extends StatefulWidget{
  final arguments;
  HomeWidget({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _HomeWidgetState();
  }

}
class _HomeWidgetState extends State<HomeWidget>{
   bool isShowList = true;
   String filePath = "";
   String currentFileTitle = "目录";

@override
  Widget build(BuildContext context) {

  double mainWith = 800;
  double minListWith = 200;
  double screenW =  MediaQuery.of(context).size.width;
  double wLeft = 0;
  double wRight = 0;
  if(isShowList){
    wRight = 0;
    wLeft = screenW > mainWith?mainWith:screenW;

  }else{
    wRight = screenW > mainWith?mainWith:screenW;
    if(screenW > mainWith + minListWith * 2){
      wLeft = screenW - mainWith > 600?300:(screenW - mainWith) / 2;
    }else{
      wLeft = 0;
    }
  }
  print(widget.arguments.toString());
   return Scaffold(
     appBar: AppBar(
       title: Text(currentFileTitle,style: TextStyle(fontSize: 25),),
       backgroundColor: Color(0x00000000),
       textTheme:Typography.blackHelsinki ,
       brightness: Brightness.light,
       bottomOpacity: 10,
       leading: IconButton(icon: Icon(Icons.format_list_bulleted),color: Colors.black, onPressed: onListBtnClick),
       actions: <Widget>[IconButton(icon: Icon(Icons.apps),color: Colors.blueAccent, onPressed: onMoreToolsClick),IconButton(icon: Image.asset("quote.png"),color: Colors.red, onPressed: onMoneyClick)],
       centerTitle: true,
     ),
     body:Flex(
  direction: Axis.horizontal,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
      Container(width:wLeft,color: Colors.black12,child: FileList(onSelectModel:onSelectModel ,isSimpleStyle: !isShowList,),),
      Container(width:wRight,color: Colors.white,child: FlutterMarkdown(filePath: filePath,),),
      Container(width:isShowList?0:wLeft,),
      // FlutterMarkdown(filePath:"Test.md",)
  ]),
   );
  }
  //左侧目录按钮
  void onListBtnClick(){
    setState(() {
    isShowList = true;
    if(isShowList) currentFileTitle = "目录";
   });
  }
   void onMoreToolsClick(){
    //进入工具页面

     Navigator.push(context, MaterialPageRoute(builder: (context){return ToolsPage();}));

   }
   void onMoneyClick(){
     //进入K线
     Navigator.push(context, MaterialPageRoute(builder: (context){return KlinePage();}));
   }
   void onSelectModel(MarkdownListModel model){
     setState(() {
      filePath = model.fileName;
      isShowList = false;
      currentFileTitle = model.title;
     });
   }
}


class FlutterMarkdown extends StatelessWidget {
  final String filePath;
  const FlutterMarkdown({Key key,this.filePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return  FutureBuilder(
            future:GlobalRequester.instance.requestMarkdown(this.filePath),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return Markdown(data: snapshot.data,
                                      selectable: true,
                                      styleSheetTheme:MarkdownStyleSheetBaseTheme.cupertino ,
                                      physics: BouncingScrollPhysics() ,
                                             );
              }else{
                return Center(
                  child: Text("加载中..."),
                );
              }
            },
          );
}
}
class FileList extends StatelessWidget {
  final Function (MarkdownListModel)onSelectModel;
  final isSimpleStyle;
  const FileList({Key key,this.onSelectModel,this.isSimpleStyle}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return  FutureBuilder(
      future:GlobalRequester.instance.requestMarkdownList(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          List<MarkdownListModel> list = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics() ,
            itemBuilder:(BuildContext context, int index){
              return  Container(
                  width: 200,
                  height: isSimpleStyle?50:150,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: isSimpleStyle?2:5, color: Color(0xffffffff)))
                  ),
                  child:FlatButton(
                      onPressed: () => onSelectModel(list[index]),

                      child:Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          list[index].title,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      )
              )
              );},
            itemCount: list.length,
          );
        }else{
          return Center(
            child: Text("加载中..."),
          );
        }
      },
    );
  }
}