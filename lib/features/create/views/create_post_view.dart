import 'dart:io';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/services/media_storage_service.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/scrollable_picker_sheet.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:eventosloop/features/create/services/user_communities_service.dart';
import 'package:eventosloop/features/posts/services/post_supabase_service.dart';
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
  final PostSupabaseService _postService = PostSupabaseService();
  final MediaStorageService _mediaService = MediaStorageService();
  final UserCommunitiesService _communitiesService = UserCommunitiesService();

  String? _selectedCommunityId;
  XFile? _selectedImage;
  List<UserCommunityOption> _communities = UserCommunitiesMock.participando;
  bool _loadingCommunities = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  static const String _personalCommunityId = 'personal';

  Future<void> _loadCommunities() async {
    final List<UserCommunityOption> items =
        await _communitiesService.fetchParticipando();
    if (!mounted) {
      return;
    }
    setState(() {
      _communities = items;
      _loadingCommunities = false;
    });
  }

  UserCommunityOption? get _selectedCommunity {
    if (_selectedCommunityId == _personalCommunityId) {
      return const UserCommunityOption(
        id: _personalCommunityId,
        name: 'Sin comunidad (publicacion personal)',
      );
    }
    return _communitiesService.findById(_communities, _selectedCommunityId);
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
    if (_loadingCommunities) {
      return;
    }
    final String? selected = await showScrollablePickerSheet<String>(
      context: context,
      title: 'Publicar en comunidad',
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person_outline, color: AppColors.primary),
          title: const Text('Sin comunidad (publicacion personal)'),
          onTap: () => Navigator.of(context).pop(_personalCommunityId),
        ),
        ..._communities.map(
          (UserCommunityOption community) => ListTile(
            leading:
                const Icon(Icons.groups_outlined, color: AppColors.primary),
            title: Text(community.name),
            onTap: () => Navigator.of(context).pop(community.id),
          ),
        ),
      ],
    );

    if (selected == null) {
      return;
    }
    setState(() {
      _selectedCommunityId = selected;
    });
  }

  Future<void> _publicar() async {
    if (_bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe algo antes de publicar')),
      );
      return;
    }
    if (!AppEnv.useSupabase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supabase no esta configurado')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final int? comunidadId = _selectedCommunityId == null ||
              _selectedCommunityId == _personalCommunityId
          ? null
          : int.tryParse(_selectedCommunityId!);

      String? urlMedia;
      if (_selectedImage != null) {
        urlMedia = await _mediaService.uploadImage(
          file: File(_selectedImage!.path),
          bucket: MediaBucket.posts,
        );
      }

      await _postService.crearPublicacion(
        titulo: _titleController.text,
        contenido: _bodyController.text,
        comunidadId: comunidadId,
        urlMedia: urlMedia,
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Publicacion creada. Desliza hacia abajo en el feed para verla.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo publicar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
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
                        onPressed: _submitting ? null : _publicar,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.send_outlined, size: 18),
                        label: Text(
                          _submitting ? 'Publicando...' : 'Crear publicacion',
                        ),
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
                    _loadingCommunities
                        ? 'Cargando comunidades...'
                        : (community?.name ?? 'Selecciona una comunidad'),
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
