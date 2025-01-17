import 'dart:ui' as ui;
import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/providers/category_provider.dart';
import 'package:bookbeauty_desktop/providers/product_provider.dart';
import 'package:bookbeauty_desktop/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey _chartKey = GlobalKey();
  late List<Product> _registeredProducts = [];
  late List<Category> _registeredCategories = [];
  CategoryProvider categoryProvider = CategoryProvider();
  ProductProvider productProvider = ProductProvider();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
  }

  Future<void> _fetchCategories() async {
    try {
      var result = await categoryProvider.get();
      setState(() {
        _registeredCategories = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      var result = await productProvider.get();
      setState(() {
        _registeredProducts = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List> _captureChartImage() async {
    RenderRepaintBoundary boundary =
        _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _showPdfDialog(Uint8List imageBytes) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(imageBytes),
              width: 400,
              height: 300,
            ),
          );
        },
      ),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('PDF Preview'),
          content: SizedBox(
            width: 500,
            height: 700,
            child: PdfPreview(
              build: (format) => pdf.save(),
              allowSharing: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Izvjestaj"),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                RepaintBoundary(
                  key: _chartKey,
                  child: Chart(
                    products: _registeredProducts,
                    categories: _registeredCategories,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Capture chart and show PDF in modal dialog
                          Uint8List chartImage = await _captureChartImage();
                          await _showPdfDialog(chartImage);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color.fromARGB(255, 102, 102, 102);
                              }
                              return const Color.fromARGB(255, 146, 146, 146);
                            },
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 245, 245, 245)),
                        ),
                        child: const Text('Pregled izvjestaja'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
    );
  }
}
