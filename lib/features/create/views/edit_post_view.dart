import 'dart:io';

import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/scrollable_picker_sheet.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:eventosloop/features/posts/models/post_comment_model.dart';
import 'package:eventosloop/features/posts/services/post_detail_mock_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({super.key, required this.postId});

  final int postId;

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final PostDetailMockService _service = PostDetailMockService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedCommunityId;
  XFile? _selectedImage;
  bool _loading = true;
  bool _saving = false;
  String? _existingMediaLabel;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final PostDetailModel? post = await _service.fetchById(widget.postId);
    if (!mounted) {
      return;
    }
    if (post == null) {
      setState(() => _loading = false);
      return;
    }
    _titleController.text = post.title ?? '';
    _bodyController.text = post.body;
    _existingMediaLabel = post.mediaLabel;
    _selectedCommunityId =
        post.communityId ?? UserCommunitiesMock.participando.first.id;
    setState(() => _loading = false);
  }

  UserCommunityOption? get _selectedCommunity {
    if (_selectedCommunityId == null) {
      return null;
    }
    for (final UserCommunityOption community
        in UserCommunitiesMock.participando) {
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
      setState(() => _selectedImage = image);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se pudo abrir la galeria del telefono')),
      );
    }
  }

  Future<void> _openCommunityPicker() async {
    final String? selected = await showScrollablePickerSheet<String>(
      context: context,
      title: 'Comunidad de la publicacion',
      children: UserCommunitiesMock.participando
          .map(
            (UserCommunityOption community) => ListTile(
              leading:
                  const Icon(Icons.groups_outlined, color: AppColors.primary),
              title: Text(community.name),
              onTap: () => Navigator.of(context).pop(community.id),
            ),
          )
          .toList(),
    );
    if (selected == null) {
      return;
    }
    setState(() => _selectedCommunityId = selected);
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega un titulo para tu publicacion')),
      );
      return;
    }
    if (_bodyController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El contenido debe tener al menos 10 caracteres'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    await _service.updatePost(
      postId: widget.postId,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      communityId: _selectedCommunityId,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publicacion actualizada correctamente')),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Eliminar publicacion'),
          content: const Text(
            'Esta accion no se puede deshacer. La publicacion dejara de ser visible para la comunidad.',
            style: TextStyle(height: 1.35),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await _service.deletePost(widget.postId);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publicacion eliminada')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  children: <Widget>[
                    const Text(
                      'Editar publicacion',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Actualiza el titulo, el texto o la imagen. Los cambios seran visibles de inmediato para tu comunidad.',
                      style: TextStyle(
                          color: AppColors.textSecondary, height: 1.35),
                    ),
                    const SizedBox(height: 16),
                    _communitySelector(community),
                    const SizedBox(height: 14),
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
                                  'Escribe el contenido de tu publicacion...',
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _mediaSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 18),
                        label:
                            Text(_saving ? 'Guardando...' : 'Guardar cambios'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                      label: const Text(
                        'Eliminar publicacion',
                        style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w800),
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
            'Editar publicacion',
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
                    'Comunidad',
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
            const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _mediaSection() {
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
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.image_outlined, color: AppColors.primary),
                    const SizedBox(height: 4),
                    Text(
                      _existingMediaLabel == null
                          ? 'Agregar o cambiar imagen'
                          : 'Imagen actual: $_existingMediaLabel',
                      style: const TextStyle(
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
