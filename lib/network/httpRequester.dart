import 'dart:html' as html;
import 'package:flutterwebtest/tools/models.dart';
import 'dart:convert';
import 'package:lfklinewidget/kLineModel.dart';
class GlobalRequester {

//单例方法
  factory GlobalRequester() =>_getInstance();

  static GlobalRequester get instance => _getInstance();

  static GlobalRequester _instance;

  GlobalRequester._internal() {

    // 初始化
  }
  static GlobalRequester _getInstance() {

    if (_instance == null) {

      _instance = new GlobalRequester._internal();

    }
    return _instance;
  }

   String host =  'http://106.54.214.239/';


  Future<String> requestMarkdown(String filename) async {

    String resp = await html.HttpRequest.getString(host + filename);

    return resp;

  }

  Future<List<MarkdownListModel>> requestMarkdownList() async {
   final  List<MarkdownListModel> list = [];
    String resp = await html.HttpRequest.getString(host + 'api/filelist');

    final jsonList = json.decode(resp);
    for(var i = 0 ; i < jsonList.length;i++){
       list.add(MarkdownListModel(fileName: jsonList[i],description: "一串说明文字-----TEXT",title: jsonList[i]));
    }
    return list;
  }
  Future<List<KLineModel>> requestKline(String year,String code) async {

    final List<KLineModel> resultList = [];
    String resp = await html.HttpRequest.getString(host + 'klinedata/'+year + '/' + code + '.json');

    final jsonMap = json.decode(resp);
    final result = jsonMap['data'];
    for(var i = 0 ; i < result.length;i++){
      final item = result[i];
      final KLineModel model =   KLineModel(time: item[0],open:item[1] ,close: item[2],top: item[3],bottom: item[4],vol: item[5] / 100000000 );
      resultList.add(model);
    }
    return resultList;

  }
}