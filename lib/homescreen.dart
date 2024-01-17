import 'dart:io';

import 'package:abo_ali_halah/models/location_servise.dart';
import 'package:abo_ali_halah/models/widgets/DropDownButtonWidget.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:mgrs_dart/mgrs_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models/widgets/textfieldwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mgrs;
  double? y, x;
  List<String> department = [
    'قسم التقنيات والمعلوماتية بابل',
    'قسم استخبارات الحلة',
    'قسم استخبارات الكفل',
    'قسم استخبارات كوثى',
    'قسم استخبارات القاسم',
    'قسم استخبارات الهاشمية',
    'قسم استخبارات المحاويل',
    'قسم استخبارات  المسيب',
  ];
  @override
  void initState() {
    super.initState();
  }

  TextEditingController tradeName = TextEditingController();
  TextEditingController locationType = TextEditingController();
  TextEditingController nameOfTheSiteOwner = TextEditingController();
  TextEditingController cameraType = TextEditingController();
  TextEditingController numberOfCamera = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController nameOFTheInventoryHolder = TextEditingController();
  TextEditingController inventorySide = TextEditingController();
  TextEditingController locationXandY = TextEditingController();
  TextEditingController locationMGRS = TextEditingController();
  TextEditingController inventorydate = TextEditingController();
  TextEditingController note = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String date =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Text(
                    style: TextStyle(fontSize: 20, color: Colors.blue[700]),
                    'وكالة الوزارة لشؤون الاستخبارات/     مديرية التقنيات و المعلوماتية/              قسم التقنيات والمعلوماتيه بابل/ الاستخبارت المكانية GSI'),
              ),
              TextFieldWidget(
                hint: 'الاسم التجاري',
                controller: tradeName,
                readOnly: false,
                isNote: false,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                hint: 'نوع الموقع',
                isNote: false,
                controller: locationType,
                readOnly: false,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                hint: 'اسم صاحب الموقع',
                controller: nameOfTheSiteOwner,
                readOnly: false,
                isNote: false,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                isNote: false,
                hint: 'نوع الكامرات',
                controller: cameraType,
                readOnly: false,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                hint: 'عدد الكامرات',
                controller: numberOfCamera,
                isNote: false,
                readOnly: false,
                textInputType: TextInputType.number,
              ),
              TextFieldWidget(
                hint: 'رقم الموبايل',
                controller: mobileNumber,
                isNote: false,
                readOnly: false,
                textInputType: TextInputType.phone,
              ),
              TextFieldWidget(
                hint: 'اسم القائم بالجرد',
                controller: nameOFTheInventoryHolder,
                isNote: false,
                readOnly: false,
                textInputType: TextInputType.text,
              ),
              DropDownButtonWidget(
                list: department,
                hint: 'جهت الجرد',
              ),
              TextFieldWidget(
                hint: 'الاحداثي x=$x,y=$y',
                controller: locationXandY,
                isNote: false,
                readOnly: true,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                hint: 'الاحداثي MGRS=$mgrs',
                controller: locationMGRS,
                isNote: false,
                readOnly: true,
                textInputType: TextInputType.text,
              ),
              FilledButton(
                  onPressed: () {
                    getLocation();
                  },
                  child: const Text('جلب الموقع')),
              TextFieldWidget(
                hint: 'تاريخ الجرد   $date',
                controller: inventorydate,
                isNote: false,
                readOnly: true,
                textInputType: TextInputType.text,
              ),
              TextFieldWidget(
                hint: 'الملاحظات',
                controller: note,
                isNote: true,
                readOnly: false,
                textInputType: TextInputType.text,
              ),
              FilledButton(
                onPressed: () async {
                  if (note.text.isEmpty) {
                    note.text = 'لا يوجد';
                  }
                  int year = 2024, month = 6, day = 1;

                  if (tradeName.text.isEmpty ||
                      locationType.text.isEmpty ||
                      cameraType.text.isEmpty ||
                      numberOfCamera.text.isEmpty ||
                      mobileNumber.text.isEmpty ||
                      nameOFTheInventoryHolder.text.isEmpty ||
                      x == null ||
                      y == null ||
                      mgrs == null) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Icon(Icons.error),
                        content: Text('يرجى مراجعه الحقوول هنالك حقل فارغ'),
                      ),
                    );
                  } else if (DropDownButtonWidget.retvalue == null) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Icon(Icons.error),
                        content: Text('يرجى مراجعه الحقوول هنالك حقل فارغ'),
                      ),
                    );
                  } else {
                    if (year == selectedDate.year) {
                      print('السنه مطابقه');
                      if (month == selectedDate.month) {
                        print('الشهر مطابقه');

                        if (day > selectedDate.day) {
                          print(' ابقه');

                          await adddatafile(data: [
                            // الاسم التجاري
                            TextCellValue(tradeName.text),

                            //نوع الموقع
                            TextCellValue(locationType.text),
                            //اسم صاحب الموقع
                            TextCellValue(nameOfTheSiteOwner.text),
                            //نوع الكامرات
                            TextCellValue(cameraType.text),

                            //العدد
                            TextCellValue(numberOfCamera.text),

                            //رقم الموبايل
                            TextCellValue(mobileNumber.text),

                            //اسم القائم بالجرد
                            TextCellValue(nameOFTheInventoryHolder.text),

                            //جهة الجرد
                            TextCellValue(DropDownButtonWidget.retvalue),

                            //الاحداثي x,y
                            TextCellValue('x=$x,y=$y'),

                            //الاحداثي mgrs
                            TextCellValue(mgrs!),

                            //تاريخ الجرد
                            TextCellValue(date),

                            //الملاحظات
                            TextCellValue(note.text),
                          ]);
                          setState(() {
                            tradeName.clear();
                            locationType.clear();
                            cameraType.clear();

                            mobileNumber.clear();
                            nameOfTheSiteOwner.clear();
                            numberOfCamera.clear();
                            note.clear();
                            inventorySide.clear();
                          });

                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              icon: Icon(Icons.done),
                              title: Text('تمت اضافه البيانات بنجاح'),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Icon(Icons.error),
                              content: Text('يرجى مراجعه القسم للتحديث'),
                            ),
                          );
                        }
                      } else if (month > selectedDate.month) {
                        print('الشهر اصغر');

                        await adddatafile(data: [
                          // الاسم التجاري
                          TextCellValue(tradeName.text),

                          //نوع الموقع
                          TextCellValue(locationType.text),
                          //اسم صاحب الموقع
                          TextCellValue(nameOfTheSiteOwner.text),
                          //نوع الكامرات
                          TextCellValue(cameraType.text),

                          //العدد
                          TextCellValue(numberOfCamera.text),

                          //رقم الموبايل
                          TextCellValue(mobileNumber.text),

                          //اسم القائم بالجرد
                          TextCellValue(nameOFTheInventoryHolder.text),

                          //جهة الجرد
                          TextCellValue(DropDownButtonWidget.retvalue),
                          //الاحداثي x,y
                          TextCellValue('x=$x,y=$y'),

                          //الاحداثي mgrs
                          TextCellValue(mgrs!),

                          //تاريخ الجرد
                          TextCellValue(date),

                          //الملاحظات
                          TextCellValue(note.text),
                        ]);
                        setState(() {
                          cameraType.clear();

                          tradeName.clear();
                          locationType.clear();
                          mobileNumber.clear();
                          nameOfTheSiteOwner.clear();
                          numberOfCamera.clear();
                          note.clear();
                          inventorySide.clear();
                        });
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            icon: Icon(Icons.done),
                            title: Text('تمت اضافه البيانات بنجاح'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Icon(Icons.error),
                            content: Text('يرجى مراجعه القسم للتحديث'),
                          ),
                        );
                      }
                    } else if (year > selectedDate.year) {
                      print('السنه اصغر');
                      await adddatafile(data: [
                        // الاسم التجاري
                        TextCellValue(tradeName.text),

                        //نوع الموقع
                        TextCellValue(locationType.text),
                        //اسم صاحب الموقع
                        TextCellValue(nameOfTheSiteOwner.text),
                        //نوع الكامرات
                        TextCellValue(cameraType.text),

                        //العدد
                        TextCellValue(numberOfCamera.text),

                        //رقم الموبايل
                        TextCellValue(mobileNumber.text),

                        //اسم القائم بالجرد
                        TextCellValue(nameOFTheInventoryHolder.text),

                        //جهة الجرد
                        TextCellValue(DropDownButtonWidget.retvalue),

                        //الاحداثي x,y
                        TextCellValue('x=$x,y=$y'),

                        //الاحداثي mgrs
                        TextCellValue(mgrs!),

                        //تاريخ الجرد
                        TextCellValue(date),

                        //الملاحظات
                        TextCellValue(note.text),
                      ]);
                      setState(() {
                        cameraType.clear();
                        tradeName.clear();
                        locationType.clear();
                        mobileNumber.clear();
                        nameOfTheSiteOwner.clear();
                        numberOfCamera.clear();
                        note.clear();
                        inventorySide.clear();
                      });
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          icon: Icon(Icons.done),
                          title: Text('تمت اضافه البيانات بنجاح'),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Icon(Icons.error),
                          content: Text('يرجى مراجعه القسم للتحديث'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('حفظ البيانات'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> adddatafile({required List<CellValue> data}) async {
    Excel? excel;

    var directory = await getApplicationCacheDirectory();

    String path = '/storage/emulated/0/Download';
    String filePath = '$path/dat.xlsx';
    File file = File(filePath);
    if (await file.exists()) {
      // file.delete();
      List<int> bytes = await file.readAsBytes();
      excel = Excel.decodeBytes(bytes);
      print(excel.tables);
    } else {
      excel = Excel.createExcel();
    }

    Sheet sheetObject = excel['Sheet1'];

    sheetObject.isRTL = true;
    if (sheetObject.maxRows == 0) {
      List<CellValue> heders = [
        const TextCellValue('الاسم التجاري'),
        const TextCellValue('نوع الموقع'),
        const TextCellValue('اسم صاحب الموقع'),
        const TextCellValue('نوع الكامرات'),
        const TextCellValue('عدد الكامرات'),
        const TextCellValue('رقم الموبايل'),
        const TextCellValue('اسم القائم بالجرد'),
        const TextCellValue('جهة الجرد'),
        const TextCellValue('الاحداثي x,y'),
        const TextCellValue('الاحداثي mgrs'),
        const TextCellValue('تاريخ الجرد'),
        const TextCellValue('الملاحظات'),
      ];
      sheetObject.appendRow(heders);
    }
    sheetObject.appendRow(data);

    print(sheetObject.maxRows);

    var fileBytes = excel.save();

    File(join('$path/dat.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }

  void convertMGRS({required double x, required double y}) {
    var point = [
      x,
      y,
    ];
    var accuracy = 5;

    // LonLat to MGRS string (results String)
    mgrs = Mgrs.forward(point, accuracy);
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      setState(() {
        setXandY(locationData.latitude!, locationData.longitude!);
      });
    }
  }

  setXandY(double lat, double long) {
    x = long;
    y = lat;
    convertMGRS(x: x!, y: y!);
  }
}
