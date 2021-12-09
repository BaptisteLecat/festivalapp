import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
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
      child: FutureBuilder(
          future: MusicGenderFetcher().getMusicGenderList(),
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
                List<MusicGender> listMusicGenders =
                    snapshot.data as List<MusicGender>;
                return ListView.builder(
                    itemCount: listMusicGenders.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Tag(
                          content: listMusicGenders[index].label,
                          isSelected: false);
                    });
              }
            }
          }),
    );
  }
}
