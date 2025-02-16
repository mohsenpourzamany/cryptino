class CryptoData {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  CryptoData(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );
  factory CryptoData.fromMapJson(Map<String, dynamic> jsonMapObject) {
    return CryptoData(
      jsonMapObject['id'],
      jsonMapObject['name'],
      jsonMapObject['symbol'],
      double.parse(
        jsonMapObject['changePercent24hr'],
      ),
      double.parse(
        jsonMapObject['priceUsd'],
      ),
      double.parse(
        jsonMapObject['marketCapUsd'],
      ),
      int.parse(
        jsonMapObject['rank'],
      ),
    );
  }
}
