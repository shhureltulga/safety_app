import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../config/api_config.dart'; // BASE_URL эндээс авна
import '../widgets/training_test_modal.dart'; // ⬅️ modal импортоо зөв нэмэхээ мартаарай!

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final int instructionId;
  final int totalPages;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.instructionId,
    required this.totalPages,
  }) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final storage = GetStorage();
  late final Dio _dio;
  bool watchedFully = false;
  bool modalShown = false;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)); // BASE_URL энд автоматаар орно
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 PDF үзэх'),
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        controller: _pdfViewerController,
        onPageChanged: (PdfPageChangedDetails details) {
          int currentPage = details.newPageNumber;

          if (currentPage == widget.totalPages && !watchedFully) {
            watchedFully = true;
            saveProgress(widget.instructionId, true);
          }
        },
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }

  Future<void> saveProgress(int instructionId, bool watchedFully) async {
    final token = storage.read('token');
    if (token == null) {
      print('❌ Token not found');
      return;
    }

    try {
      await _dio.patch(
        '/training-progress/$instructionId', // зөв path
        data: {
          'watchedFully': watchedFully,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('✅ Progress saved successfully');

      // 🎯 Прогресс хадгалсны дараа Test Modal нээх
      if (!modalShown) {
        modalShown = true;
        showTrainingTestModal(
          context,
          instructionId,
          onSuccess: () {
            Navigator.pop(context, true); // success болбол буцаана
          },
        );
      }
    } catch (e) {
      print('❌ Error saving progress: $e');
    }
  }
}
