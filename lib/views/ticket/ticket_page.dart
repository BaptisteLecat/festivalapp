import 'package:festivalapp/common/constants/colors.dart';
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Swiper(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "TomorrowLand",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: secondaryColor),
                            ),
                            Text("Montrez ce ticket à l'entrée",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        color: secondaryColorLessOpacity)),
                            Divider()
                          ],
                        )),
                      ),
                      Expanded(
                          child: Flex(direction: Axis.vertical, children: [
                        SizedBox(
                            child: Column(
                          children: [
                            Text("Lieu",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: secondaryColorLessOpacity)),
                            Text("New York, Madison Square Garden",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: secondaryColor))
                          ],
                        )),
                      ]))
                    ],
                  ),
                ));
          },
          itemWidth: MediaQuery.of(context).size.width * 0.8,
          pagination: new SwiperPagination(),
          layout: SwiperLayout.STACK),
    );
  }
}
