import 'dart:html' as html;
import 'package:flutterwebtest/Common/models.dart';
import 'dart:convert';
import 'package:lfklinewidget/kLineModel.dart';
import 'dart:io';
import 'package:dio/dio.dart';
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

  bool isWeb(){

    if(Platform.isIOS || Platform.isAndroid){
      return false;
    }else{
      return true;

    }
  }

 final  String host =  'http://106.54.214.239/';

  Future<String> requestMarkdown(String filename) async {

   Response res =  await Dio().getUri(Uri.parse(host + filename));

   return res.data;
  }


  Future<List<MarkdownListModel>> requestMarkdownModels()async{

    String resp=await html.HttpRequest.getString(host + 'api/filelist');
    List<MarkdownListModel> list = [];
    var jsonList = json.decode(resp);
    for(var i = 0 ; i < jsonList.length;i++){
      list.add(MarkdownListModel(fileName: jsonList[i],description: "一串说明文字-----TEXT",title: jsonList[i]));
    }
    return list;
  }

   Future<String> requestMarkdownList() async {
     Response res =  await Dio().getUri(Uri.parse(host + 'api/filelist'));
     return res.data.toString();
  }
  Future<List<KLineModel>> requestKline(String year,String code) async {

    Response response =   await Dio().getUri(Uri.parse(host + 'klinedata/'+year + '/' + code + '.json'));
    String resp =  response.toString();
    List<KLineModel> resultList = [];
    var jsonMap = json.decode(resp);
    var result = jsonMap['data'];
    for(var i = 0 ; i < result.length;i++){
      var item = result[i];
      KLineModel model =   KLineModel(time: item[0],open:item[1] ,close: item[2],top: item[3],bottom: item[4],vol: item[5] / 100000000 );
      resultList.add(model);
    }
    return resultList;

  }
}