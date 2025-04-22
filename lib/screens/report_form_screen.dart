import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../api/violation_api.dart';

class ReportFormScreen extends StatefulWidget {
  @override
  _ReportFormScreenState createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final List<Map<String, dynamic>> _reports = [];
  final TextEditingController _descriptionController = TextEditingController();
  final storage = GetStorage();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadViolations();
  }

  Future<void> _loadViolations() async {
    try {
      final items = await ViolationApi().getAll();
      setState(() {
        _reports.clear();
        _reports.addAll(items);
      });
    } catch (e) {
      print('Failed to load violations: $e');
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submitReport() async {
    final token = storage.read('token');
    if (_imageFile == null || token == null) return;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _imageFile!.path,
        filename: _imageFile!.path.split('/').last,
      ),
      'description': _descriptionController.text,
      'source': 'MOBILE',
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final res = await dio.post(
        '/violations',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (res.statusCode == 201) {
        setState(() {
          _reports.insert(0, res.data);
          _imageFile = null;
          _descriptionController.clear();
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error uploading: $e');
    }
  }

  void _openReportModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 4, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 10),
              _imageFile != null ? Image.file(_imageFile!, height: 150) : Text('📷 Зураг аваагүй байна'),
              TextButton.icon(onPressed: _pickImage, icon: Icon(Icons.camera_alt), label: Text('Зураг авах')),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Тайлбар'),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: _submitReport, child: Text('Илгээх'))),
                  SizedBox(width: 10),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Хаах')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Зөрчлийн жагсаалт')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _reports.length > 10 ? 10 : _reports.length,
        itemBuilder: (context, index) {
          final item = _reports[index];
          final imageUrl = item['imageUrl'].toString();
final fullUrl = imageUrl.startsWith('http')
    ? imageUrl
    : '${ApiConfig.baseUrl}$imageUrl';

print('🖼️ Зураг дуудаж байна: $fullUrl');

return Card(
  margin: const EdgeInsets.only(bottom: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: ListTile(
    leading: imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              fullUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Image алдаа: $error');
                return Icon(Icons.broken_image);
              },
            ),
          )
        : Icon(Icons.image_not_supported),
    title: Text(item['description'] ?? 'No description'),
    subtitle: Text('🕒 ${item['createdAt']?.toString().substring(0, 16) ?? ''}'),
  ),
);

         
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openReportModal,
        label: Text('Зөрчил бүртгэх'),
        icon: Icon(Icons.add),
      ),
    );
  }
}