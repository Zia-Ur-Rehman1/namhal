import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/constants.dart';

class ComplaintsSummaryCard extends StatelessWidget {
  const ComplaintsSummaryCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.color,
    required this.numOfFiles,
  }) : super(key: key);

  final String title, svgSrc;
  final Color? color;
  final int numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kPrimaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(kDefaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              svgSrc,
              color: color,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: kSecondaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfFiles Files",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: kSecondaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
