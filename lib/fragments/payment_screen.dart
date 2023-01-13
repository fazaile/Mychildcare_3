import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Uri _url = Uri.parse('https://buy.stripe.com/test_dR6cPM5xveqNg2kaEE');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/sideImg.png'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children: [
                  //   Text("06:22 AM", style: TextStyle(
                  //     fontSize: 30,
                  //     fontFamily: 'avenir',
                  //     fontWeight: FontWeight.w500
                  //   ),),
                  //   Expanded(
                  //     child: Container(),
                  //   ),
                  //   Container(
                  //     height: 20,
                  //     width: 20,
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: AssetImage('asset/images/cloud.png'),
                  //         fit: BoxFit.contain
                  //       )
                  //     ),
                  //   ),
                  //   SizedBox(width: 5,),
                  //   Text("34˚ C", style: TextStyle(
                  //     fontSize: 20,
                  //     fontFamily: 'avenir',
                  //     fontWeight: FontWeight.w800

                  //   ),)
                  // ],
                ),
                // Text("24th June, 2021 | Thursday", style: TextStyle(
                //   fontSize: 16,
                //   color: Colors.grey
                // ),),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/logo.jpg'),
                                  fit: BoxFit.contain)),
                        ),
                        Text(
                          "Mychildcare",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'ubuntu',
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Make an online payment \nfor your children fee.",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _launchUrl,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Make Payment Fee",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
// return Scaffold(
//         body: Center(
//       child: ElevatedButton(
//         onPressed: _launchUrl,
//         child: Text('Make a payment'),
//       ),
//     ));