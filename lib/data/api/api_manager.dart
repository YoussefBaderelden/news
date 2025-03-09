import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_app_c13/data/models/Error_response.dart';
import 'package:news_app_c13/data/models/article_dm.dart';
import 'package:news_app_c13/data/models/articles_response_dm.dart';
import 'package:news_app_c13/data/models/source_dm.dart';
import 'package:news_app_c13/data/models/source_respone_dm.dart';

/// Http - Dio - Retrofit
abstract class ApiManager {
  static const _baseUrl = "https://newsapi.org";
  static const _sourcesEndPoint = "/v2/top-headlines/sources";
  static const _apiKey = "3ffdc835b15a499d880a1519d8542bde";
  static const _articlesEndPoint = "/v2/everything";


  static Future<List<SourceDM>> getSources(String categoryId) async {
    Uri url = Uri.parse(
        "$_baseUrl$_sourcesEndPoint?category=$categoryId&apiKey=$_apiKey");
    var serverResponse = await get(url);
    var json = jsonDecode(serverResponse.body);

    if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
      var myResponse = SourceResponseDM.fromJson(json);
      return myResponse.sources!;
    } else {
      var myResponse = ErrorResponse.fromJson(json);
      throw myResponse.message ?? "Something went wrong, please try again later";
    }
  }


  static Future<List<ArticleDM>> getArticles(String sourceId) async {
    Uri url = Uri.parse(
        "$_baseUrl$_articlesEndPoint?apiKey=$_apiKey&sources=$sourceId");

    var serverResponse = await get(url);
    var json = jsonDecode(serverResponse.body);

    if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
      var myResponse = ArticlesResponseDm.fromJson(json);
      return myResponse.articles!;
    } else {
      var myResponse = ErrorResponse.fromJson(json);
      throw myResponse.message ?? "Something went wrong, please try again later";
    }
  }


  static Future<List<ArticleDM>> searchArticles(String query) async {
    Uri url = Uri.parse("$_baseUrl$_articlesEndPoint?apiKey=$_apiKey&q=$query");

    var serverResponse = await get(url);
    var json = jsonDecode(serverResponse.body);

    if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
      var myResponse = ArticlesResponseDm.fromJson(json);
      return myResponse.articles!;
    } else {
      var myResponse = ErrorResponse.fromJson(json);
      throw myResponse.message ?? "Something went wrong, please try again later";
    }
  }
}
