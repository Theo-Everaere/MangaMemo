import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/main.dart';
import 'package:newscan/service/manga_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late MangaService mangaService;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    mangaService = MangaService();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    try {
      await mangaService.fetchLatestUploadedManga();

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } catch (e) {
      setState(() {
        error = "Loading error : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kMainBgColor),
      body: Center(
        child: isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'MangaMemo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(kTitleColor),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Color(kTitleColor)),
          ],
        )
            : error != null
            ? Center(child: Text(error!, style: TextStyle(color: Color(kTitleColor))))
            : Container(),
      ),
    );
  }
}
