import 'package:flutter/material.dart';
import 'package:lfklinewidget/kLineParmManager.dart';
import 'package:lfklinewidget/kLinePrintController.dart';
import 'package:lfklinewidget/kLineColorConfig.dart';
import 'package:lfklinewidget/kLineDataManager.dart';
import 'package:lfklinewidget/kLineWidget.dart';
import 'package:lfklinewidget/kLineModel.dart';
import 'package:flutterwebtest/network/httpRequester.dart';
import 'dart:convert';

class KlinePage extends StatefulWidget {
  KlinePage({Key key}) : super(key: key);
  @override
  _KlinePageState createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage> {
  String title = "上证指数";
  String curReqYear = '2020';
      // static GlobalKey<_kLineWidgetState> key = GlobalKey();
      static List<KLineModel> dataList = [
      ];
      static KLineDataManager manager = KLineDataManager(dataList: dataList,parmManager: KlineParmManager(),printController: KlinePrintController());
      void _incrementCounter() {
        manager.caculateDataList();
        setState(() {
    });
  }
  Future<String> getDataList()async{
    dataList.clear();
    String res = await GlobalRequester.instance.requestKline(curReqYear,'0000001');
    final jsonMap = json.decode(res);

    final result = jsonMap['data'];
    title = jsonMap['name'];

    for(var i = 0 ; i < result.length;i++){
      final item = result[i];
      final KLineModel model =   KLineModel(time: item[0],open:item[1] ,close: item[2],top: item[3],bottom: item[4],vol: item[5] / 100000000 );
       dataList.add(model);
    }
    manager.completionAVG();
    manager.completionLastClose();
    manager.completionUpDown();
    return 'true';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
//backgroundColor: Colors.black,
      body:  FutureBuilder(
        future:getDataList(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:KLineWidget(drawRect:Rect.fromLTWH(50, 10, MediaQuery.of(context).size.width - 50 > 0?MediaQuery.of(context).size.width - 50 :0, MediaQuery.of(context).size.height - 400>0?MediaQuery.of(context).size.height - 400:0)  ,
                dataManager:manager,
                colorConfig: new KLineColorConfig(),
                onLeftScrollEnd: (){
                curReqYear = (int.parse(curReqYear) - 1).toString();
                  GlobalRequester.instance.requestKline(curReqYear,'0000001').then((res){
                    final jsonMap = json.decode(res);
                    final result = jsonMap['data'];
                    title = jsonMap['name'];
                    for(var i = 0 ; i < result.length;i++){
                      final item = result[i];
                      final KLineModel model =   KLineModel(time: item[0],open:item[1] ,close: item[2],top: item[3],bottom: item[4],vol: item[5] / 100000000 );
                      dataList.insert(i, model);
                    }
                    manager.completionAVG();
                    manager.completionLastClose();
                    manager.completionUpDown();
                    manager.caculateDataList();
                    manager.onAppendData(result.length);
                  });
                },
                onRightScrollEnd: (){
                  //右拉刷新

                }, ),
            );
          }else{
            return Center(
              child: Text("加载中..."),
            );
          }
        },
      ) ,floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
       child: Icon(Icons.add),
    ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
