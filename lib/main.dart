import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: KaKaoPayPage(),
  )
);

class KaKaoPayPage extends StatefulWidget {
  @override
  _KaKaoPayPageState createState() => _KaKaoPayPageState();
}

class _KaKaoPayPageState extends State<KaKaoPayPage> {
  final _URL = 'http://127.0.0.1:3000';
  final _ADMIN_KEY = 'a1a9e22984154bd8ca92bee9a5c0dd79';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async{
           var res = await http.post('https://kapi.kakao.com/v1/payment/ready',
             encoding: Encoding.getByName('utf8'),
             headers: {
              'Authorization' : 'KakaoAK $_ADMIN_KEY'
             },
             body: {
               'cid':'TC0ONETIME',
               'partner_order_id':'partner_order_id',
               'partner_user_id':'partner_user_id',
               'item_name' : '초코빠이',
               'quantity': '1',
               'total_amount':'22222',
               'vat_amount' : '2222',
               'tax_free_amount' : '0',
               'approval_url' : '$_URL/kakaopayment',
               'fail_url' : '$_URL/kakaopayment',
               'cancel_url': '$_URL/kakaopayment'
             }
           );
            Map<String, dynamic> result = json.decode(res.body);
            AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              data: result['next_redirect_mobile_url'],
              arguments: {'txn_id': result['tid']},
            );
            await intent.launch();
          },
          child: Text("Buy"),
        ),
      ),
    );
  }
}