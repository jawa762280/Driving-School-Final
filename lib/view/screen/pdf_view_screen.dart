import 'package:driving_school/controller/pdf_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewScreen extends StatefulWidget {
  final String url;
  final String fileName;

  const PdfViewScreen({super.key, required this.url, required this.fileName});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late PdfController controller;
  int pages = 0;
  int currentPage = 0;
  bool errorLoading = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PdfController());
    _loadPdf();
  }

  void _loadPdf() {
    errorLoading = false;
    controller.downloadPdf(widget.url, widget.fileName).catchError((_) {
      setState(() {
        errorLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () =>
              controller.downloadCertificate(context, widget.fileName),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.download, color: Colors.white),
              SizedBox(width: 8),
              Text('تحميل الشهادة'),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'عرض الشهادة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        foregroundColor: Colors.white,
        actions: [
          if (pages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text('${currentPage + 1} / $pages'),
              ),
            )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (errorLoading) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('حدث خطأ أثناء تحميل الملف'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorLoading = false;
                      _loadPdf();
                    });
                  },
                  child: const Text('إعادة المحاولة'),
                )
              ],
            ),
          );
        }
        if (controller.localPath == null) {
          return const Center(child: Text('لم يتم تحميل الملف'));
        }
        return PDFView(
          filePath: controller.localPath!,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: true,
          pageFling: true,
          onRender: (pagesCount) {
            setState(() {
              pages = pagesCount ?? 0;
            });
          },
          onViewCreated: (pdfViewController) {
            // ممكن تخزن pdfViewController إذا تحتاجه للتحكم بالصفحات
          },
          onPageChanged: (page, total) {
            setState(() {
              currentPage = page ?? 0;
            });
          },
          onError: (error) {
            // ignore: avoid_print
            print('PDFView error: $error');
            setState(() {
              errorLoading = true;
            });
          },
          onPageError: (page, error) {
            // ignore: avoid_print
            print('Error on page $page: $error');
          },
        );
      }),
    );
  }
}
