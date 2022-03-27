import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:namhal/model/complaint.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
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
                Text("Complaint Report"),
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
                buildRichText("From ", complain.address.toString()),
              ]),
              TableRow(children: [
                buildRichText("Priority: ", complain.priority.toString()),
                buildRichText("Status: ", complain.status.toString()),
              ]),
              TableRow(children: [
                buildRichText("Worker: ", complain.worker.toString()),
                buildRichText("Service: ", complain.worker.toString())
              ]),
              TableRow(children: [
                buildRichText("StartTime: ", complain.startDate.toString()),
                buildRichText("StartDate: ", complain.startTime.toString())
              ]),
              TableRow(children: [
                buildRichText("EndTime: ", complain.endTime.toString()),
                buildRichText("EndDate: ", complain.endDate.toString())
              ]),

            ],

          ),
          buildRichText("Managed By: ", complain.manager.toString()),

          Paragraph(
            text: "Description ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,font: bold),
          ),
          Paragraph(
            text: complain.desc.toString(),
            style: TextStyle(fontSize: 14, font: font),

          ),
          Align(
            alignment: Alignment.centerLeft,
            child: complain.img != null
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

          Paragraph(
            text: "Feedback ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Paragraph(

            text: complain.feedback.toString(),
          ),
        ],
      );
  static RichText buildRichText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: PdfColors.black,
        ),
        children: [
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontSize: 15,
              color: PdfColors.black,
            ),
          ),
        ],
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

    await OpenFile.open(url);
  }
}
