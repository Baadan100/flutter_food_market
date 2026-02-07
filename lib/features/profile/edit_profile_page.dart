import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../auth/application/auth_controller.dart';
import '../../l10n/app_localizations.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        if (mounted) {
          setState(() {
            _pickedImage = picked;
            _pickedImageBytes = bytes;
            _errorMessage = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'فشل اختيار الصورة: $e');
      }
    }
  }

  Future<String?> _uploadPhoto(String userId) async {
    final bytes = _pickedImageBytes ??
        (_pickedImage != null ? await _pickedImage!.readAsBytes() : null);
    if (bytes == null || bytes.isEmpty) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(userId)
          .child('profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await storageRef.getDownloadURL();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'فشل رفع الصورة: $e');
      }
      return null;
    }
  }

  Future<void> _save() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? photoUrl;
      if (_pickedImage != null) {
        photoUrl = await _uploadPhoto(user.id);
        if (photoUrl == null) {
          setState(() => _isLoading = false);
          return;
        }
      }

      await ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            photoUrl: photoUrl,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).tr('profile_updated'))),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final t = AppLocalizations.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.tr('edit_profile'))),
        body: Center(child: Text(t.tr('sign_in_required'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('edit_profile')),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(t.tr('save')),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: _pickedImageBytes != null
                        ? ClipOval(
                            child: Image.memory(
                              _pickedImageBytes!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          )
                        : user.photoUrl != null && user.photoUrl!.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.photoUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (_, __, ___) => ClipOval(
                                    child: Image.asset(
                                      'logo.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.asset(
                                  'logo.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.tr('change_photo'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: t.tr('full_name'),
                hintText: user.name ?? user.email,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: const Icon(Icons.save),
                label: Text(t.tr('save')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
