import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/home/tagFilter/components/tag.dart';
import 'package:flutter/material.dart';

class TagFilter extends StatefulWidget {
  final ValueChanged<MusicGender> updateMusicGender;
  const TagFilter({Key? key, required this.updateMusicGender})
      : super(key: key);

  @override
  _TagFilterState createState() => _TagFilterState();
}

class _TagFilterState extends State<TagFilter> {
  int _selectedIndex = 0;
  late Future<List<MusicGender>> _tagsData;
  List<MusicGender> listTags = [];
  bool startInit = true;

  @override
  void initState() {
    _tagsData = MusicGenderFetcher().getMusicGenderList();
    super.initState();
  }

  void selectTag(int index) {
    print(index);
    _selectedIndex = index;
    widget.updateMusicGender(listTags[_selectedIndex]);
  }

  bool _isSelected(index) {
    return index == _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder(
          future: _tagsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            } else {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                print(snapshot.error);
                return const Center(
                  child: Text("Une erreur est survenue."),
                );
              } else {
                listTags = snapshot.data as List<MusicGender>;
                if (this.startInit) {
                  listTags.insert(0, MusicGender(id: null, label: "Tout"));
                  this.startInit = false;
                }
                return ListView.builder(
                    itemCount: listTags.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Tag(
                        content: listTags[index].label,
                        isSelected: this._isSelected(index),
                        itemIndex: index,
                        selectedCategoryCallBack: this.selectTag,
                      );
                    });
              }
            }
          }),
    );
  }
}
