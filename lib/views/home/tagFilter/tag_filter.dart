import 'package:festivalapp/views/home/tagFilter/components/tag.dart';
import 'package:flutter/material.dart';

class TagFilter extends StatefulWidget {
  const TagFilter({Key? key}) : super(key: key);

  @override
  _TagFilterState createState() => _TagFilterState();
}

class _TagFilterState extends State<TagFilter> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
          itemCount: 12,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Tag(content: "Mon superbe tag", isSelected: false);
          }),
    );
  }
}
