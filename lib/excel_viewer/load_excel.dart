import 'dart:async';
import 'dart:math';

import 'package:excel/excel.dart' as excelLib;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadExcel extends StatefulWidget {
  const LoadExcel({super.key});

  @override
  State<LoadExcel> createState() => _LoadExcelState();
}

class _LoadExcelState extends State<LoadExcel> {
  late excelLib.Excel excel;

  late final future = loadData();

  Future<bool> loadData() async {
    try {
      ByteData data =
          await rootBundle.load('assets/docs/flutter_cook_book.xlsx');
      excel = await compute(_loadDataIsolate, data);
      return true;
    } catch (e, s) {
      debugPrint('$e\n$s');
    }
    return false;
  }

  int get maxRows => excel.tables[excel.tables.keys.first]?.maxRows ?? 0;

  int get maxCols => excel.tables[excel.tables.keys.first]?.maxCols ?? 0;

  List<List<excelLib.Data?>> get rows =>
      excel.tables[excel.tables.keys.first]?.rows ?? [];

  List<excelLib.Data?>? colLabelAt(int index) =>
      excel.tables[excel.tables.keys.first]?.row(index);

  List<excelLib.Data?> rowAt(int index) => rows[index];

  late int numberOfRow = min(50, maxRows);

  late final int additionalCol =
      (MediaQuery.of(context).size.width / 100).ceil().toInt();

  late final int additionalRow =
      (MediaQuery.of(context).size.height / 50).ceil().toInt();

  late final List<TableRow> rowsWidget = [
    for (var i = 0; i < numberOfRow; i++) buildTableRow(i, rowAt(i))
  ];

  late final numberOfRowNotifierValue = ValueNotifier(numberOfRow);

  final verticalScroll = ScrollController();
  final horizontal = ScrollController();

  @override
  void initState() {
    super.initState();
    verticalScroll.addListener(_listenScroll);
  }

  @override
  void dispose() {
    verticalScroll.removeListener(_listenScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load excel'),
        actions: [
          IconButton(
              onPressed: () {
                excel.save(fileName: 'flutter_cook_book.xlsx');
              },
              icon: const Icon(Icons.save_alt))
        ],
      ),
      body: FutureBuilder<bool>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Theme.of(context).colorScheme.error,
                ),
              );
            }

            // return SizedBox();
            return Scrollbar(
              controller: verticalScroll,
              scrollbarOrientation: ScrollbarOrientation.right,
              interactive: true,
              child: ListView(
                controller: verticalScroll,
                children: [
                  Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.top,
                    controller: horizontal,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: horizontal,
                      scrollDirection: Axis.horizontal,
                      child: ValueListenableBuilder(
                        valueListenable: numberOfRowNotifierValue,
                        builder: (context, value, _) => Table(
                          border: TableBorder.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                              width: 0.5),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                border: Border.all(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              children: [
                                const TableCell(
                                  child: Text(''),
                                ),
                                for (var j = 0;
                                    j < maxCols + additionalCol;
                                    j++)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '$j',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            ...rowsWidget
                          ],
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: numberOfRowNotifierValue,
                    builder: (context, value, child) =>
                        value < maxRows ? child! : const SizedBox(),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            // return SizedBox();
          }),
    );
  }

  TableRow buildTableRow(int index, List<excelLib.Data?>? row) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(8.0),
            child: Align(
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
        ...List.generate(maxCols, (j) {
          excelLib.CellStyle? cellStyle = row?[j]?.cellStyle;
          String? backgroundColor =
              _cellTypeStringValue(cellStyle?.backgroundColor);
          String? fontColor = _cellTypeStringValue(cellStyle?.fontColor);
          return TableCell(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: backgroundColor != null
                    ? Color(int.parse(backgroundColor, radix: 16) + 0xFF000000)
                    : Colors.transparent,
              ),
              child: buildConstrainedBox(
                context,
                SelectableText(
                  row?[j]?.value.toString() ?? "",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: fontColor != null
                            ? Color(
                                int.parse(fontColor, radix: 16) + 0xFF000000)
                            : null,
                        fontSize: cellStyle?.fontSize != null
                            ? cellStyle!.fontSize!.toDouble() + 1
                            : null,
                        fontWeight:
                            cellStyle?.isBold == true ? FontWeight.bold : null,
                        fontStyle: cellStyle?.isItalic == true
                            ? FontStyle.italic
                            : null,
                      ),
                ),
              ),
            ),
          );
        }),
        ...List.generate(
          additionalCol,
          (index) => const TableCell(
            child: SizedBox(width: 100),
          ),
        )
      ],
    );
  }

  String? _cellTypeStringValue(String? value) {
    if (value == 'none' || value == 'null') {
      return null;
    }
    return value;
  }

  final random = Random();

  static excelLib.Excel _loadDataIsolate(ByteData data) {
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return excelLib.Excel.decodeBytes(bytes);
  }

  Future<void> _listenScroll() async {
    if (verticalScroll.offset >= verticalScroll.position.maxScrollExtent) {
      if (numberOfRow < maxRows) {
        numberOfRow = min(numberOfRow + 50, maxRows);
        rowsWidget.addAll([
          for (var i = numberOfRow - 50; i < numberOfRow; i++)
            buildTableRow(i, rowAt(i))
        ]);
        if (numberOfRow < maxRows) {
          await Future.delayed(const Duration(milliseconds: 300));
        } else {
          // numberOfRowNotifierValue.value = numberOfRowNotifier;
          numberOfRow += additionalRow;
          rowsWidget.addAll([
            for (var i = numberOfRow - additionalRow; i < numberOfRow; i++)
              buildTableRow(i, null)
          ]);
        }
        numberOfRowNotifierValue.value = numberOfRow;
      }
    }
  }

  ConstrainedBox buildConstrainedBox(BuildContext context, Widget child) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
          maxWidth: min(MediaQuery.of(context).size.width, 400),
          maxHeight: double.infinity),
      child: child,
    );
  }
}
