import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget {
  int value;
  ValueChanged<int> callback;
  int maxValue;
  int minValue;
  InputNumber(
      {Key? key,
      required this.value,
      required this.callback,
      this.maxValue = 100,
      this.minValue = 0})
      : super(key: key);

  @override
  _InputNumberState createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  void _decrement() {
    if (widget.value - 1 >= widget.minValue) {
      widget.value--;
      widget.callback(widget.value);
      setState(() {});
    }
  }

  void _increment() {
    if (widget.value + 1 <= widget.maxValue) {
      widget.value++;
      widget.callback(widget.value);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffEEEEEE),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1.5, color: const Color(0xffC5CCDA)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.value}",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black),
          ),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _increment();
                },
                child: Image.asset("assets/icons/ui/number_increment.png"),
              ),
              GestureDetector(
                onTap: () {
                  _decrement();
                },
                child: Image.asset("assets/icons/ui/number_decrement.png"),
              )
            ],
          )
        ],
      ),
    );
  }
}
