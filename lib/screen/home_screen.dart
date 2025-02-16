import 'package:cryptino/data/model/crypto_data.dart';
import 'package:cryptino/screen/coin_list_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
          backgroundColor: Color(0xffc1c1c1),
          body: SafeArea(
            child: Center(
              child: SpinKitFadingCube(
                size: 100,
                color: Color(0xffffffff),
              ),
            ),
          ),
        ));
  }

  void getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<CryptoData> cryptoList = response.data['data']
        .map<CryptoData>(
            (jsonMapObject) => CryptoData.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
