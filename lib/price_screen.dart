import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:bitcoin/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? selectedCurrency = "AUD";
String? left;
double? bitcoinUSD;
String? Bitcoinusd;

const apiKey = "F5852709-0D6B-426D-8AFF-45C970686A2C";

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
  //_PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  @override
  void initState() {
    super.initState();
    GetData();
  }

  void GetData() async {
    http.Response response = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=$apiKey"));
    // print(response.statusCode);
    // print(response.body);
    var data = jsonDecode(response.body);
    //print(data);
    double rate = data["rate"];
    print(rate);

    if (response.statusCode == 200) {
      try {
        setState(() {
          bitcoinUSD = rate;
        });
      } catch (e) {
        print(e);
      }
    } else {
      print(response.statusCode);
    }
  }

  CupertinoPicker ios() {
    List<Widget> cupertinoItem = [];
    for (String currency in currenciesList) {
      var item = Text(currency);
      cupertinoItem.add(item);
    }

    return CupertinoPicker(
        itemExtent: 30,
        onSelectedItemChanged: (value) {
          selectedCurrency = value as String?;
          GetData();
          // print(value);
        },
        children: cupertinoItem);
  }

  DropdownButton<String> android() {
    List<DropdownMenuItem<String>> dropdownbuttons = [];
    for (String currency in currenciesList) {
      var Newitem = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownbuttons.add(Newitem);
    }

    return DropdownButton<String>(
      icon: Icon(Icons.arrow_downward),
      value: selectedCurrency,
      items: dropdownbuttons,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          GetData();
        });
      },
    );
  }

  Widget build(BuildContext context) {
    Bitcoinusd = bitcoinUSD?.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UseCard(
            left: "BTC",
          ),
          UseCard(
            left: "ETH",
          ),
          UseCard(
            left: "LTC",
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isAndroid ? android() : ios()),
        ],
      ),
    );
  }
}

class UseCard extends StatelessWidget {
  UseCard({required this.left});
  String left;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18, 18, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $left = $Bitcoinusd $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
