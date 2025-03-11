import 'package:cryptino/data/constant/constants.dart';
import 'package:cryptino/data/model/crypto_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptoList});
  List<CryptoData>? cryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<CryptoData>? cryptoList;

  bool isSearchLoadingVisible = false;

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.settings,
                color: greenColor,
                size: 30,
              ),
              Text(
                'Cryptino',
                style: TextStyle(
                    color: purpleColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w800),
              ),
              Icon(
                Icons.message,
                color: greenColor,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                _filterList(value);
              },
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
            Visibility(
              visible: isSearchLoadingVisible,
              child: const Text(
                'Update crypto',
                style: TextStyle(color: greenColor, fontSize: 15),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: greenColor,
                color: blackColor,
                onRefresh: () async {
                  // List<CryptoData> fereshData = await _getData();
                  // setState(() {
                  //   cryptoList = fereshData;
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
            Container(
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 130,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: purpleColor, // background
                        foregroundColor: greenColor, // foreground
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: greenColor, // background
                        foregroundColor: purpleColor,

                        // foreground
                      ),
                      onPressed: () {},
                      child: const Text(
                        'sell',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
                  crypto.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getColorChangeText(crypto.changePercent24Hr)),
                )
              ],
            ),
            SizedBox(
              width: 50,
              child: _getIconChangePercent(crypto.changePercent24Hr),
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

  Future<void> _filterList(String enteredKeyword) async {
    List<CryptoData> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result.cast<CryptoData>();
        isSearchLoadingVisible = false;
      });
      return;
    }
    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
