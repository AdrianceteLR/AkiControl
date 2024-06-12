// ignore_for_file: depend_on_referenced_packages, unnecessary_to_list_in_spreads

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ReportPdfScreen extends StatelessWidget {
  static String routeName = 'Report';

  const ReportPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientsService = Provider.of<StoresService>(context);
    final productsService = Provider.of<ProductsService>(context);
    final tasksService = Provider.of<TasksService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
            backgroundColor: const Color(0xFFFFF5EE),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_headerDrawer(context), const MenuDrawer()],
              ),
            )),
        appBar: AppBar(
          title: const Text('Generar PDF',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 235, 182, 122),
            dividerColor: Colors.black,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            overlayColor:
                MaterialStatePropertyAll(Color.fromARGB(68, 235, 182, 122)),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: 'Almacenes',
              ),
              Tab(text: 'Productos'),
              Tab(text: 'Tareas'),
            ],
          ),
        ),
        body: Stack(
          children: [
            const HomeBackground(),
            SafeArea(
              child: TabBarView(
                children: [
                  _buildList(context, clientsService),
                  _buildList(context, productsService),
                  _buildList(context, tasksService),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _generatePdf(context),
          child: const Icon(Icons.picture_as_pdf),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, dynamic service) {
    final isLoading = service.isLoading;
    final List<dynamic> items = service is StoresService
        ? service.stores
        : service is ProductsService
            ? service.products
            : service.tasks;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final name = item is Store
            ? item.name
            : item is Product
                ? item.name
                : item is Task
                    ? item.title
                    : '';

        final subtitle = item is Store
            ? item.country
            : item is Product
                ? item.category
                : item is Task
                    ? item.description
                    : '';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListReport(
            name: name,
            subtitle: subtitle,
          ),
        );
      },
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final clientsService = Provider.of<StoresService>(context, listen: false);
    final productsService =
        Provider.of<ProductsService>(context, listen: false);
    final tasksService = Provider.of<TasksService>(context, listen: false);

    final pdf = pw.Document();

    final ByteData imageData =
        await rootBundle.load('assets/images/ic_launcher.png');
    final pdfImage = pw.MemoryImage(Uint8List.view(imageData.buffer));

    final ByteData regularFontData =
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final Uint8List regularFontUint8List = regularFontData.buffer.asUint8List();
    final pw.Font regularFont =
        pw.Font.ttf(regularFontUint8List.buffer.asByteData());

    final ByteData boldFontData =
        await rootBundle.load('assets/fonts/OpenSans-Bold.ttf');
    final Uint8List boldFontUint8List = boldFontData.buffer.asUint8List();
    final pw.Font boldFont = pw.Font.ttf(boldFontUint8List.buffer.asByteData());

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'AkiControl',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Image(pdfImage, width: 60),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(color: PdfColors.grey),
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          _buildSection(
            title: 'Almacenes',
            items: clientsService.stores.map((store) => store.name).toList(),
            total: clientsService.stores.length,
          ),
          _buildSection(
            title: 'Productos',
            items: productsService.products
                .map((product) => product.name)
                .toList(),
            total: productsService.products.length,
          ),
          _buildSection(
            title: 'Tareas',
            items: tasksService.tasks.map((task) => task.title).toList(),
            total: tasksService.tasks.length,
          ),
        ],
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildSection({
    required String title,
    required List<String> items,
    required int total,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        ...items
            .map((item) =>
                pw.Text(item, style: const pw.TextStyle(fontSize: 18)))
            .toList(),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Text(
            'Total $title: $total',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  Material _headerDrawer(BuildContext context) {
    return Material(
      color: const Color(0xFFE76F51),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: 25),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                'AkiControl',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
