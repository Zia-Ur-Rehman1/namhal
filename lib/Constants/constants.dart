
import 'package:flutter/material.dart';

const kPrimaryColor = Colors.blue;
const kSecondaryColor = Colors.white;
const kBgColor = Colors.white;
const btnColor =Color(0xFF01A0BA);

const kDefaultPadding = 16.0;
// Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('Complains').where("username",isEqualTo:context.read<Info>().user.name).snapshots();

LinearGradient  lg= const LinearGradient(
colors: [
Color(0xFF01A0BA),
Color(0xFF0076BE),
Color(0xFF845EC2),

],
begin: Alignment.topRight,
end: Alignment.bottomLeft,
);
const kSvg = "assets/icons/Documents.svg";
const TextStyle rcT=TextStyle(
  fontSize: 15,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
TextStyle rcST=TextStyle(
  fontSize: 15,
  color: Colors.white.withOpacity(0.95),
  fontWeight: FontWeight.normal,
);
