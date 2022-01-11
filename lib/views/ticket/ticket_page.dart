import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/layout/dotted_separator.dart';
import 'package:festivalapp/model/barcode.dart';
import 'package:festivalapp/services/Api/repositories/barcode/barcode_fetcher.dart';
import 'package:festivalapp/views/ticket/components/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder(
            future: BarcodeFetcher().getBarcodeList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Barcode> listBarcode = snapshot.data as List<Barcode>;
                return Swiper(
                    itemCount: listBarcode.length,
                    itemBuilder: (BuildContext context, int index) {
                      Barcode barcode = listBarcode[index];
                      return Ticket(
                        barcode: barcode,
                      );
                    },
                    itemWidth: MediaQuery.of(context).size.width * 0.8,
                    pagination: new SwiperPagination(),
                    layout: SwiperLayout.STACK);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                print(snapshot.error);
                return const Center(
                  child: Text("Une erreur est survenue."),
                );
              }
            }),
      ),
    );
  }
}
