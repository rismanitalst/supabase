import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';


final supabase = Supabase.instance.client;


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
    String? _publicImageUrl;
    bool _isUploading = false;

    Future<void> _pickAndUploadToPublicBucket() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) return;

      setState(() => _isUploading = true);

      try {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
        final filePath = 'uploads/$fileName';

        if (kIsWeb) {
        final bytes = await picked.readAsBytes();

        await supabase.storage
            .from('test-images')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/png',
              ),
            );
      } else {
        final file = File(picked.path);

        await supabase.storage
            .from('test-images')
            .upload(filePath, file);
      }


        final publicUrl = supabase.storage
            .from('test-images')
            .getPublicUrl(filePath);

        setState(() {
          _publicImageUrl = publicUrl;
        });
      } catch (e) {
        debugPrint('Error upload: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal upload: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
      }
    }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_isUploading) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isUploading ? null : _pickAndUploadToPublicBucket,
            child: const Text('Pilih & Upload Gambar'),
          ),
          const SizedBox(height: 24),

if (_publicImageUrl != null) ...[
  const Text(
    'Hasil Upload:',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  const SizedBox(height: 8),
  Image.network(
    _publicImageUrl!,
    height: 200,
    fit: BoxFit.cover,
  ),
],

        ],
      ),
    ),

    );
  }
}
