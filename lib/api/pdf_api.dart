import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:namhal/model/complaint.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:printing/printing.dart';

class PdfApi {
  static Future<File> generate(Complains complain, String id) async {
    final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final font = await PdfGoogleFonts.arimoRegular();
    final boldFont = await PdfGoogleFonts.arimoBold();
    final pdf = Document();


    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => <Widget>[
              Header(
                  child: Row(children: [
                Image(MemoryImage(
                  byteList,
                ),height: 50,width: 50,),
                SizedBox(width: 0.5 * PdfPageFormat.cm),
                Text("Complaint Report" , style: TextStyle (font: boldFont,fontSize: 15),),
              ])),
              buildCustomReport(complain, font, boldFont),
            ]));

    return saveDocument(name: id, pdf: pdf);
  }

  static  Widget buildCustomReport(Complains complain, Font font, Font bold )  =>  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRichText("Title: ", complain.title.toString()),
          Table(
            children: [
              TableRow(children: [
                buildRichText("Complained By: ", complain.username.toString()),
                buildRichText("Address ", complain.address.toString()),
              ]),
              TableRow(children: [
                buildRichText("Priority: ", complain.priority.toString()),
                buildRichText("Status: ", complain.status.toString()),
              ]),
              TableRow(children: [
                buildRichText("Worker: ", complain.worker.toString()),
                buildRichText("Service: ", complain.service.toString())
              ]),
              TableRow(children: [
                buildRichText("StartDate: ", complain.startDate.toString()),
                buildRichText("StartTime: ", complain.startTime.toString())
              ]),
              TableRow(children: [
                buildRichText("EndDate: ", complain.endDate==null?"---":complain.endDate.toString()),
                buildRichText("EndTime: ", complain.endTime==null?"---":complain.endDate.toString())
              ]),

            ],
          ),
          buildRichText("Managed By: ", complain.manager.toString()),
          Paragraph(
            margin: EdgeInsets.symmetric(vertical: 5),
            text: "Description ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,font: bold),
          ),
          Container(
            //add width in mm
            width: (PdfPageFormat.a4.width - 2 * PdfPageFormat.cm) * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: PdfColors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Paragraph(
              padding: EdgeInsets.all(5),
              text:complain.desc!=null?complain.desc.toString():"---",
              style: TextStyle(fontSize: 14, font: font),
            ),
          ),



          Paragraph(
            margin: EdgeInsets.symmetric(vertical: 5),

            text: "User Feedback ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Container(
            //add width in mm
            width: (PdfPageFormat.a4.width - 2 * PdfPageFormat.cm) * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: PdfColors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Paragraph(
              padding: EdgeInsets.all(5),
              text:complain.feedback!=null?complain.feedback.toString():"No Feedback",
              style: TextStyle(fontSize: 14, font: font),
            ),
          ),
          SizedBox(height: 10),
          Paragraph(
            margin: EdgeInsets.symmetric(vertical: 5),

            text: "Rating ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Paragraph(
            margin: EdgeInsets.symmetric(vertical: 5),
            text:complain.rating!=null?complain.rating.toString():"No Rating",
            style: TextStyle(fontSize: 14, font: font),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: complain.img != "No Image Attached"
                ? UrlLink(
                destination: complain.img.toString(),
                child: Text('Attached Image',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: PdfColors.blue,
                    )))
                : Text("No Image Attached",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: PdfColors.black,
                )),
          ),
        ],
      );
  static RichText buildRichText(String title, String subtitle)  {
    return RichText(
      text: TextSpan(
        text: title,

        children: [
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontSize: 15,
              color: PdfColors.black,
              fontWeight: FontWeight.values[0],

            ),
          ),
        ],
        style: TextStyle(
          fontSize: 15,
          color: PdfColors.black,
          fontWeight: FontWeight.values[1],

        ),
      ),
    );
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print("File Path: $url");
    await OpenFile.open(url);
  }
}
