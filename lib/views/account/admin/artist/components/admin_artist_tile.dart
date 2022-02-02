import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';

class AdminArtistTile extends StatelessWidget {
  final Artist artist;
  final Function() onTap;
  const AdminArtistTile({Key? key, required this.artist, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                artist.name,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
