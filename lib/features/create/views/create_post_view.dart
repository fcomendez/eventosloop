import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _communitySelector(),
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
                    const SizedBox(height: 16),
                    _toolBar(),
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

  Widget _communitySelector() {
    return Container(
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Publicar en comunidad',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Selecciona una comunidad',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _mediaPlaceholder() {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
      ),
      child: const Center(
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
      ),
    );
  }

  Widget _toolBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          Icon(Icons.image_outlined, color: AppColors.textSecondary),
          Icon(Icons.link, color: AppColors.textSecondary),
          Icon(Icons.format_list_bulleted, color: AppColors.textSecondary),
          Icon(Icons.alternate_email, color: AppColors.textSecondary),
          Icon(Icons.tag, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
