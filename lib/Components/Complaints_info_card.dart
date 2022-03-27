import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ComplaintsModel.dart';
import '../Constants/constants.dart';

class ComplaintsInfoCard extends StatelessWidget {
  const ComplaintsInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final ComplaintsStorageInfo info;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(kDefaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    color: info.color,
                  ),
                ),
                // Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              style: TextStyle(color: Colors.white),

              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles} Files",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
