import 'package:cryptino/data/constant/constants.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: blackColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Spacer(),
                Image(
                    width: 170,
                    image: AssetImage('assets/images/cryptino-logo.png')),
                Spacer(),
                SpinKitWave(
                  size: 70,
                  color: greenColor,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
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
