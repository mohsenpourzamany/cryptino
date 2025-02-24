import 'package:cryptino/data/constant/constants.dart';
import 'package:cryptino/data/model/crypto_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptoList});
  List<CryptoData>? cryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<CryptoData>? cryptoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: const Text(
          'کریپتینو',
          style: TextStyle(color: greyColor, fontFamily: 'me', fontSize: 24),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          TextField(
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: ' Crypto Name ',
              hintStyle: const TextStyle(
                fontFamily: 'vazir',
                color: blackColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: greenColor,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: greenColor,
              color: blackColor,
              onRefresh: () async {
                // List<CryptoData> freshData = await _getData();
                // setState(() {
                //   cryptoList = freshData;
                // });
              },
              child: ListView.builder(
                itemCount: cryptoList!.length,
                itemBuilder: (context, index) {
                  return _getListTile(cryptoList![index]);
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _getListTile(CryptoData crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: const TextStyle(color: greenColor, fontSize: 17),
      ),
      subtitle: Text(
        crypto.symbol,
        style: const TextStyle(
          color: greyColor,
        ),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: const TextStyle(
              color: greyColor,
              fontSize: 15,
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: const TextStyle(color: greyColor, fontSize: 17),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getColorChangeText(crypto.changePercent24hr)),
                )
              ],
            ),
            SizedBox(
              width: 50,
              child: _getIconChangePercent(crypto.changePercent24hr),
            )
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? const Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : const Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  Color _getColorChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<void>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<CryptoData> cryptoList = response.data['data']
        .map<CryptoData>(
            (jsonMapObject) => CryptoData.fromMapJson(jsonMapObject))
        .toList();

    return cryptoList;
  }
}
