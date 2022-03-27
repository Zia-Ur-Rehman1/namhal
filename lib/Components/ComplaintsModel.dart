import '/Constants/constants.dart';
import 'package:flutter/material.dart';

class ComplaintsStorageInfo {
   String? svgSrc, title;
   int? numOfFiles;
   Color? color;
   String? value;

  ComplaintsStorageInfo({
    this.svgSrc,
    this.title,
    this.numOfFiles,
    this.color,
    required this.value,
  });
  //set num of files

}

List ComplaintsDetails = [
  ComplaintsStorageInfo(
    title: "Rejected",
    numOfFiles: 5,
    svgSrc: kSvg,
    color: Colors.red,
    value: "total",
  ),
  ComplaintsStorageInfo(
    title: "Pending",
    numOfFiles: 28,
    svgSrc: kSvg,
    color: Color(0xFFFFA113),
    value: "pending",
  ),
  ComplaintsStorageInfo(
    title: "Inprogress",
    numOfFiles: 78,
    svgSrc: kSvg,
    color: Colors.cyan,
    value: "inprogress",
  ),
  ComplaintsStorageInfo(
    title: "Completed",
    numOfFiles: 8,
    svgSrc: kSvg,
    color: Colors.green,
    value: "complete",
  ),
];
