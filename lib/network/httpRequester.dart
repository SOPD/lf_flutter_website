import 'dart:html' as html;
import 'package:flutterwebtest/tools/models.dart';
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

   // String resp = await html.HttpRequest.getString(host + filename);
   List<MarkdownListModel> list= [MarkdownListModel(fileName: "Test.md",description: "一串说明文字-----TEXT",title: "测试_kline文章"),
                                  MarkdownListModel(fileName: "test2.md",description: "一串说明文字-----TEXT",title: "测试_ios_金仕达...")];
    return list;

  }
  Future<String> requestKline(String year,String code) async {

    String resp = await html.HttpRequest.getString(host + 'klinedata/'+year + '/' + code + '.json');

    return resp;

  }
}