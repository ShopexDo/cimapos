import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/model/response/config_model.dart';
import 'package:six_pos/data/model/response/bill_model.dart';
import 'package:six_pos/helper/date_converter.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:six_pos/util/app_constants.dart';

class PDFBillGenerator {
  static Future<void> generatePDF({
    ConfigModel configModel,
    Bill bill,
    int quoteId,
    double discountProduct,
    double total,
  }) async {

    final pdf = pw.Document();

    String baseUrl = await AppConstants.getSavedBaseUrl();
    var response = await http.get(Uri.parse('${baseUrl}/api/v1/get-logo'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String imageUrl = data['shop_logo'];
      var imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        final image = pw.MemoryImage(imageResponse.bodyBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Center(
                    child: pw.Image(image, width: 200, height: 100), // Adjust the width and height accordingly
                  ),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${configModel.businessInfo.shopAddress}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${configModel.businessInfo.shopPhone}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${configModel.businessInfo.shopEmail}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${configModel.businessInfo.vat}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ),
                  pw.Divider(thickness: 2),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${'quote'.tr.toUpperCase()} #${quoteId}'),
                      pw.Text('payment_method'.tr),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${DateConverter.dateTimeStringToMonthAndTime(bill.createdAt)}'),
                      pw.Text('${'paid_by'.tr} ${bill.account != null ? bill.account.account : 'customer_balance'.tr}'),
                    ],
                  ),
                  pw.Divider(thickness: 2),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('N°'),
                      pw.Text('product_info'.tr),
                      pw.Text('qty'.tr),
                      pw.Text('price'.tr),
                    ],
                  ),
                  pw.Divider(),
                  for (int i = 0; i < bill.details.length; i++)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('${i + 1}'),
                        pw.Text('${jsonDecode(bill.details[i].productDetails)['name']}'),
                        pw.Text('${bill.details[i].quantity.toString()}'),
                        pw.Text('${bill.details[i].price}'),
                      ],
                    ),
                  pw.Divider(thickness: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('subtotal'.tr),
                      pw.Text('${bill.quoteAmount}'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('product_discount'.tr),
                      pw.Text('${discountProduct}'),
                    ],
                  ),
                  // pw.Row(
                  //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     pw.Text('coupon_discount'.tr),
                  //     pw.Text('${bill.couponDiscountAmount}'),
                  //   ],
                  // ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('extra_discount'.tr),
                      pw.Text('${bill.extraDiscount}'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('tax'.tr),
                      pw.Text('${bill.totalTax}'),
                    ],
                  ),
                  pw.Divider(thickness: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('total'.tr),
                      pw.Text('${total - discountProduct}'),
                    ],
                  ),
                  // pw.Row(
                  //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     pw.Text('change'.tr),
                  //     pw.Text('${bill.collectedCash - total - discountProduct}'),
                  //   ],
                  // ),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Divider(thickness: 2),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('terms_and_condition'.tr, style: pw.TextStyle(fontSize: 15)),
                  ),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('terms_and_condition_details'.tr, style: pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('${'powered_by'.tr}: PrestaSoft', style: pw.TextStyle(fontSize: 10)),
                  ),
                  pw.Padding(padding: pw.EdgeInsets.all(10)),
                  // Rest of the code remains the same.
                ],
              );
            },
          ),
        );

        // Save the PDF document
        final output = await getTemporaryDirectory();
        final file = File("${output.path}/example.pdf");
        await file.writeAsBytes(await pdf.save());
      }
    } else {
      throw Exception('Failed to load image');
    }

    // Convert the PDF to a list of bytes
    // final pdfBytes = pdf.save();

    // // Show the PDF document
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdfBytes,
    // );

    // Convert the PDF to a list of bytes
    final Uint8List pdfBytes = await pdf.save();

    // Share the PDF document
    await Printing.sharePdf(bytes: pdfBytes, filename: 'COTIZACIÓN-${quoteId}.pdf');
  }
}