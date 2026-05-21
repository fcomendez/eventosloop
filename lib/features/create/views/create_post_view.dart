import 'dart:io';

import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedCommunityId;
  XFile? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  UserCommunityOption? get _selectedCommunity {
    if (_selectedCommunityId == null) {
      return null;
    }
    for (final UserCommunityOption community in UserCommunitiesMock.participando) {
      if (community.id == _selectedCommunityId) {
        return community;
      }
    }
    return null;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (!mounted || image == null) {
        return;
      }
      setState(() {
        _selectedImage = image;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la galeria del telefono'),
        ),
      );
    }
  }

  Future<void> _openCommunityPicker() async {
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tus comunidades',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              ...UserCommunitiesMock.participando.map(
                (UserCommunityOption community) => ListTile(
                  leading: const Icon(Icons.groups_outlined, color: AppColors.primary),
                  title: Text(community.name),
                  onTap: () => Navigator.of(context).pop(community.id),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }
    setState(() {
      _selectedCommunityId = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserCommunityOption? community = _selectedCommunity;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD8EAF7), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _topBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: <Widget>[
                    _communitySelector(community),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Titulo de tu publicacion',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Divider(height: 8),
                          TextField(
                            controller: _bodyController,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              hintText:
                                  'Comparte lo que viviste, una recomendacion o una idea para la comunidad...',
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _mediaPlaceholder(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Publicacion guardada localmente por ahora',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_outlined, size: 18),
                        label: const Text('Crear publicacion'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          const Text(
            'Crear publicacion',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _communitySelector(UserCommunityOption? community) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _openCommunityPicker,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.inputBackground,
              child: Icon(Icons.groups_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Publicar en comunidad',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    community?.name ?? 'Selecciona una comunidad',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _mediaPlaceholder() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _pickImageFromGallery,
      child: Container(
        height: _selectedImage == null ? 96 : 180,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
          image: _selectedImage == null
              ? null
              : DecorationImage(
                  image: FileImage(File(_selectedImage!.path)),
                  fit: BoxFit.cover,
                ),
        ),
        child: _selectedImage == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.image_outlined, color: AppColors.primary),
                    SizedBox(height: 4),
                    Text(
                      'Agregar imagen opcional',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
