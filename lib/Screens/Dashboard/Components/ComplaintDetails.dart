import 'package:flutter/material.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Responsive/responsive.dart';
import 'package:namhal/Screens/Add_Complain_Screen/add_Complain.dart';
import 'package:namhal/Screens/Dashboard/Components/ComplaintCardGridView.dart';
class ComplaintDetails extends StatelessWidget {

  const ComplaintDetails({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Complaints Detail",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical:
                  kDefaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddComplain()));

              },
              icon: Icon(Icons.add),
              label: Text("Add Complain"),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        Responsive(
          mobile: ComplaintsCardGridView(

            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: ComplaintsCardGridView(),
          desktop: ComplaintsCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}