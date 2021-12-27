import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/layout/dotted_separator.dart';
import 'package:festivalapp/model/barcode.dart';
import 'package:festivalapp/views/ticket/components/inner_rounded_border.dart';
import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  final Barcode barcode;
  const Ticket({Key? key, required this.barcode}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.barcode.event.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: secondaryColor),
                    ),
                    Text("Montrez ce ticket à l'entrée",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: secondaryColorLessOpacity)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                                color:
                                                    secondaryColorLessOpacity)),
                                    Text(widget.barcode.event.getDateOfEvent(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: secondaryColor))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .copyWith(color: secondaryColor))
                                  ],
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .copyWith(color: secondaryColor))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .copyWith(color: secondaryColor))
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
                child:
                    const DottedSeparator(color: Color(0xffD0D0D0), height: 2),
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
  }
}
