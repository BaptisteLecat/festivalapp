import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/layout/dotted_separator.dart';
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
            return SizedBox(
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18, top: 18),
                        child: SizedBox(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    .headline5!
                                    .copyWith(
                                        color: secondaryColorLessOpacity)),
                            const Divider(
                              thickness: 2,
                              color: Color(0xffD0D0D0),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: ClipPath(
                        clipper: InnerRoundedBorderDownClipper(),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Lieu",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  color:
                                                      secondaryColorLessOpacity)),
                                      Text("New York, Madison Square Garden",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: secondaryColor))
                                    ],
                                  )),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Date",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            secondaryColorLessOpacity)),
                                            Text("10-03-2022",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: secondaryColor))
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Place",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            secondaryColorLessOpacity)),
                                            Text("101",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: secondaryColor))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Prix",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            secondaryColorLessOpacity)),
                                            Text("346€",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: secondaryColor))
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Commande",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            secondaryColorLessOpacity)),
                                            Text("234656",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: secondaryColor))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                                ]),
                          ),
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        color: Colors.white,
                        child: const DottedSeparator(
                            color: Color(0xffD0D0D0), height: 2),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ClipPath(
                      clipper: InnerRoundedBorderUpClipper(),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Container(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemWidth: MediaQuery.of(context).size.width * 0.8,
          pagination: new SwiperPagination(),
          layout: SwiperLayout.STACK),
    );
  }
}

class InnerRoundedBorderUpClipper extends CustomClipper<Path> {
  var radius = 16.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));

    /*path.lineTo(0.0, size.height);
    path.arcToPoint(Offset(radius, size.height), clockwise: false);
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height), clockwise: false);*/

    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: false, radius: Radius.circular(20));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: false, radius: Radius.circular(20));

    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0.0),
        clockwise: true, radius: Radius.circular(radius));
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

class InnerRoundedBorderDownClipper extends CustomClipper<Path> {
  var radius = 16.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0.0);
    path.arcToPoint(Offset(0.0, size.height), clockwise: false);

    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width, 0.0), clockwise: false);
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
