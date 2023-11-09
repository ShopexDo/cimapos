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



class BillPrintScreen extends StatefulWidget {
  final Bill bill;
  final ConfigModel configModel;
  final int quoteId;
  final double discountProduct;
  final double total;
  const BillPrintScreen({Key key, this.bill, this.configModel, this.quoteId, this.discountProduct, this.total}) : super(key: key);

  @override
  State<BillPrintScreen> createState() => _BillPrintScreenState();
}

class _BillPrintScreenState extends State<BillPrintScreen> {
  var defaultPrinterType = PrinterType.bluetooth;
  var _isBle = false;
  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice> _subscription;
  StreamSubscription<BTStatus> _subscriptionBtStatus;
  BTStatus _currentStatus = BTStatus.none;
  List<int> pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  BluetoothPrinter selectedPrinter;

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus = PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;

      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask);
            pendingTask = null;
          });
        } else if (Platform.isIOS) {
          PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask);
          pendingTask = null;
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() {
    devices.clear();
    _subscription = printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      devices.add(BluetoothPrinter(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
      setState(() {});
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter.address) || (device.typePrinter == PrinterType.usb && selectedPrinter.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(type: selectedPrinter.typePrinter);
      }
    }

    selectedPrinter = device;
    setState(() {});
  }


  Future _printReceiveTest() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('${widget.configModel.businessInfo.shopName}',
        styles: const PosStyles(align: PosAlign.center,bold: true, height: PosTextSize.size3));
    bytes += generator.text('${widget.configModel.businessInfo.shopAddress}',
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text('${widget.configModel.businessInfo.shopPhone}',
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text('${widget.configModel.businessInfo.shopEmail}',
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text('${widget.configModel.businessInfo.vat}',
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(' ', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: '${'quote'.tr.toUpperCase()}#${widget.quoteId}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: true, height: PosTextSize.size3),
      ),

      PosColumn(
        text: 'payment_method'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: true, height: PosTextSize.size3),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: '${DateConverter.dateTimeStringToMonthAndTime(widget.bill.createdAt)}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: 'Cash',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: '${'sl'.tr.toUpperCase()}',
        width: 2,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: 'product_info'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),
      PosColumn(
        text: 'qty'.tr,
        width: 1,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
      PosColumn(
        text: 'price'.tr,
        width: 3,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    for(int i =0; i< widget.bill.details.length; i++){
      bytes += generator.row([
        PosColumn(
          text: '${i+1}',
          width: 1,
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
        ),

        PosColumn(
          text: '${jsonDecode(widget.bill.details[i].productDetails)['name']}',
          width: 7,
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
        ),
        PosColumn(
          text: '${widget.bill.details[i].quantity.toString()}',
          width: 1,
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
        ),
        PosColumn(
          text: '${widget.bill.details[i].price}',
          width: 3,
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
        ),
      ]);
    }



    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'subtotal'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.bill.quoteAmount}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'product_discount'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.discountProduct}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    // bytes += generator.row([
    //   PosColumn(
    //     text: 'coupon_discount'.tr,
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
    //   ),

    //   PosColumn(
    //     text: '${widget.bill.couponDiscountAmount}',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
    //   ),
    // ]);
    bytes += generator.row([
      PosColumn(
        text: 'extra_discount'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.bill.extraDiscount}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'tax'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.bill.totalTax}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'total'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.total - widget.discountProduct}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'change'.tr,
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size3),
      ),

      PosColumn(
        text: '${widget.bill.collectedCash - widget.total - widget.discountProduct}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);




    bytes += generator.text(' ', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('terms_and_condition'.tr, styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text(' ',);
    bytes += generator.text('terms_and_condition_details'.tr, styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text(' ',);
    bytes += generator.text('${'powered_by'.tr} : ${widget.configModel.businessInfo.shopName}', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text('${'shop_online'.tr} : ${widget.configModel.businessInfo.shopName}', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
    bytes += generator.text(' ',);

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(name: bluetoothPrinter.deviceName, productId: bluetoothPrinter.productId, vendorId: bluetoothPrinter.vendorId));
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model:
            BluetoothPrinterInput(name: bluetoothPrinter.deviceName, address: bluetoothPrinter.address, isBle: bluetoothPrinter.isBle ?? false));
        pendingTask = null;
        if (Platform.isIOS || Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(type: bluetoothPrinter.typePrinter, model: TcpPrinterInput(ipAddress: bluetoothPrinter.address));
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Column(
                    children: devices.map((device) => ListTile(
                      title: Text('${device.deviceName}'),
                      subtitle: Platform.isAndroid && defaultPrinterType == PrinterType.usb
                          ? null
                          : Visibility(visible: !Platform.isWindows, child: Text("${device.address}")),
                      onTap: () {selectDevice(device);},
                      leading: selectedPrinter != null &&
                          ((device.typePrinter == PrinterType.usb && Platform.isWindows
                              ? device.deviceName == selectedPrinter.deviceName
                              : device.vendorId != null && selectedPrinter.vendorId == device.vendorId) ||
                              (device.address != null && selectedPrinter.address == device.address))
                          ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      ) : null,
                      trailing: OutlinedButton(
                        onPressed: selectedPrinter == null || device.deviceName != selectedPrinter?.deviceName
                            ? null : () async {
                          _printReceiveTest();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                          child: Text("print_quote".tr, textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    )
                        .toList()),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _ipController,
                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                      decoration: const InputDecoration(
                        label: Text("Ip Address"),
                        prefixIcon: Icon(Icons.wifi, size: 24),
                      ),
                      onChanged: setIpAddress,
                    ),
                  ),
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _portController,
                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                      decoration: const InputDecoration(
                        label: Text("Port"),
                        prefixIcon: Icon(Icons.numbers_outlined, size: 24),
                      ),
                      onChanged: setPort,
                    ),
                  ),
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_ipController.text.isNotEmpty) setIpAddress(_ipController.text);
                        _printReceiveTest();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                        child: Text("print_bill".tr, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BluetoothPrinter {
  int id;
  String deviceName;
  String address;
  String port;
  String vendorId;
  String productId;
  bool isBle;

  PrinterType typePrinter;
  bool state;

  BluetoothPrinter(
      {this.deviceName,
        this.address,
        this.port,
        this.state,
        this.vendorId,
        this.productId,
        this.typePrinter = PrinterType.bluetooth,
        this.isBle = false});
}