import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/default_decoration.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchEditingController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: 260,
      height: 60,
      decoration: BoxDecoration(
          color: secondaryColor, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        SizedBox(
            height: 20, child: Image.asset("assets/icons/menu/search.png")),
        Expanded(
          child: TextField(
              controller: searchEditingController,
              textInputAction: TextInputAction.search,
              decoration:
                  DefaultDecoration.inputDecoration(hintText: "Search")),
        )
      ]),
    );
  }
}
