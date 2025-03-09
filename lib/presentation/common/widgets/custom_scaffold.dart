import 'package:flutter/material.dart';
import 'package:news_app_c13/presentation/category_screen/category_screen.dart';
import 'package:news_app_c13/presentation/providers/theme_provider.dart';
import 'package:news_app_c13/data/api/api_manager.dart';
import 'package:news_app_c13/data/models/article_dm.dart';
import 'package:news_app_c13/presentation/news_screen/widgets/article_item_widget.dart';
import 'package:provider/provider.dart';

import '../../resourses/color_manger.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key, required this.title, this.actions, this.body});
  final String title;
  final List<Widget>? actions;
  final Widget? body;

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<ArticleDM> _searchResults = [];
  bool _isLoading = false;

  void _searchArticles(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }
    setState(() => _isLoading = true);
    try {
      List<ArticleDM> results = await ApiManager.searchArticles(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults.clear();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: _isSearching ? null : Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Text('News App')),
            ListTile(
              title: Text('Go to Home'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, CategoryScreen.routeName);
              },
            ),
            ListTile(
              title: Text(''),
              leading: Icon(themeProvider.isDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              onTap: () {
                themeProvider.setThemeModeProvider(
                    themeProvider.isDarkTheme ? ThemeMode.light : ThemeMode.dark);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: _isSearching
            ? null
            : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: _isSearching
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorManger.white),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: ColorManger.white),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchArticles,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: ColorManger.white),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: ColorManger.white),
                  autofocus: true,
                ),
              ),
            ],
          ),
        )
            : Text(widget.title),
        centerTitle: true,
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.close, color: ColorManger.white),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchResults.clear();
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ...?widget.actions,
        ],
      ),
      body: _isSearching && _searchController.text.isNotEmpty
          ? _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? Center(child: Text("No results found", style: TextStyle(color: ColorManger.white)))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var article = _searchResults[index];
          return ArticleItemWidget(
            image: article.urlToImage ?? '',
            title: article.title ?? '',
            author: article.author ?? '',
            date: article.publishedAt ?? "",
            brief: article.description ?? '',
            url: article.url ?? '',
          );
        },
      )
          : widget.body,
    );
  }
}
