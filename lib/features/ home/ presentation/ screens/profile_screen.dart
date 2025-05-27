import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../application/auth_provider.dart' as app_auth;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String? photoUrl;
  bool isLoading = false;
  bool isSavingName = false;
  bool isSavingPhone = false;
  bool isSavingAddress = false;

  final ImagePicker picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchUserData() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              name = userDoc.data()?['name'] ?? 'Без имени';
              email = userDoc.data()?['email'] ?? 'Нет email';
              phone = userDoc.data()?['phone'] ?? '';
              address = userDoc.data()?['address'] ?? '';
              photoUrl = userDoc.data()?['photoUrl'];

              _nameController.text = name;
              _phoneController.text = phone;
              _addressController.text = address;
            });
          }
        } else {
          // Create user document if it doesn't exist
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'Без имени',
            'email': user.email ?? 'Нет email',
            'phone': '',
            'address': '',
            'photoUrl': user.photoURL,
          });
          await fetchUserData(); // Fetch again after creating
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки данных: $e')),
        );
      }
    }
  }

  Future<void> _saveField(String fieldName, String value) async {
    if (value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Поле "$fieldName" не может быть пустым')),
      );
      return;
    }

    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      if (fieldName == 'name') isSavingName = true;
      else if (fieldName == 'phone') isSavingPhone = true;
      else if (fieldName == 'address') isSavingAddress = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        fieldName: value.trim(),
      });

      setState(() {
        if (fieldName == 'name') name = value.trim();
        else if (fieldName == 'phone') phone = value.trim();
        else if (fieldName == 'address') address = value.trim();
      });

      await _animationController.forward();
      await Future.delayed(const Duration(seconds: 1));
      await _animationController.reverse();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Поле "$fieldName" успешно обновлено!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения "$fieldName": $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSavingName = false;
          isSavingPhone = false;
          isSavingAddress = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (pickedFile == null) return;

      setState(() {
        isLoading = true;
      });

      // Create the file
      File file = File(pickedFile.path);

      // Create a storage reference
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file
      final uploadTask = storageRef.putFile(file);

      // Get download URL after upload completes
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with new photo URL
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'photoUrl': downloadUrl,
      });

      if (mounted) {
        setState(() {
          photoUrl = downloadUrl;
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Фото успешно обновлено')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки фото: $e')),
        );
      }
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось открыть ссылку')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при открытии ссылки: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Профиль")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : const NetworkImage('https://i.imgur.com/fbYqD0z.png'),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: isLoading ? null : _pickAndUploadImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildEditableField(
              label: 'Имя',
              controller: _nameController,
              isSaving: isSavingName,
              onSave: () => _saveField('name', _nameController.text),
            ),

            _buildEditableField(
              label: 'Телефон',
              controller: _phoneController,
              isSaving: isSavingPhone,
              onSave: () => _saveField('phone', _phoneController.text),
              keyboardType: TextInputType.phone,
            ),

            _buildEditableField(
              label: 'Адрес',
              controller: _addressController,
              isSaving: isSavingAddress,
              onSave: () => _saveField('address', _addressController.text),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Instagram_logo_2022.svg/120px-Instagram_logo_2022.svg.png',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  iconSize: 40,
                  onPressed: () => _launchURL('https://www.instagram.com/ya_booblik/'),
                ),
                const SizedBox(width: 8),
                const Text('Перейти в Instagram', style: TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                context.read<app_auth.AuthProvider>().logout(context);
              },
              child: const Text("Выйти"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isSaving,
    required VoidCallback onSave,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: isSaving
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
              : FadeTransition(
            opacity: _fadeAnimation,
            child: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: onSave,
              tooltip: 'Сохранить $label',
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}



// Не забудь в pubspec.yaml добавить зависимости:
//   image_picker: ^0.8.7+4
//   firebase_storage: ^11.0.16
//   url_launcher: ^6.1.7
// Также в android/app/build.gradle:
//   implementation 'com.google.firebase:firebase-storage:20.0.1'

// И вверху файла импортировать firebase_storage:
// import 'package:firebase_storage/firebase_storage.dart';
// и url_launcher:
// import 'package:url_launcher/url_launcher.dart';

