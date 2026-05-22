import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/content_options_sheet.dart';
import 'package:eventosloop/features/create/views/edit_post_view.dart';
import 'package:eventosloop/features/posts/models/post_comment_model.dart';
import 'package:eventosloop/features/posts/services/post_detail_mock_service.dart';
import 'package:eventosloop/features/report/models/report_content_model.dart';
import 'package:eventosloop/features/report/views/report_content_view.dart';
import 'package:flutter/material.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key, required this.postId});

  final int postId;

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final PostDetailMockService _service = PostDetailMockService();
  final TextEditingController _commentController = TextEditingController();

  PostDetailModel? _post;
  bool _loading = true;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final PostDetailModel? post = await _service.fetchById(widget.postId);
    if (!mounted) {
      return;
    }
    setState(() {
      _post = post;
      _liked = post?.likedByMe ?? false;
      _loading = false;
    });
  }

  void _openOptions(PostDetailModel post) {
    final List<ContentOptionItem> options = <ContentOptionItem>[
      if (post.isOwnedByMe)
        ContentOptionItem(
          icon: Icons.edit_outlined,
          label: 'Editar publicación',
          subtitle: 'Modifica título, texto o imagen de tu publicación.',
          onTap: () async {
            final bool? updated = await Navigator.of(context).push<bool>(
              MaterialPageRoute<bool>(
                builder: (_) => EditPostView(postId: post.id),
              ),
            );
            if (updated == true) {
              await _load();
            }
          },
        ),
      ContentOptionItem(
        icon: Icons.flag_outlined,
        label: 'Reportar contenido',
        subtitle: 'Informa spam, acoso o contenido que incumple las normas.',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportContentView(
                contentType: ReportContentType.post,
                contentId: post.id,
                contentTitle: post.title ?? post.body,
              ),
            ),
          );
        },
      ),
    ];

    showContentOptionsSheet(
      context,
      title: 'Opciones de publicación',
      options: options,
    );
  }

  Color _parseHex(String? value) {
    final String clean = (value ?? '#D9EAF5').replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD8EAF7), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _post == null
                  ? _NotFound(onBack: () => Navigator.pop(context))
                  : Column(
                      children: <Widget>[
                        _TopBar(
                          onBack: () => Navigator.pop(context),
                          onOptions: () => _openOptions(_post!),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                            children: <Widget>[
                              _AuthorHeader(post: _post!),
                              const SizedBox(height: 12),
                              _ContentCard(post: _post!, parseHex: _parseHex),
                              const SizedBox(height: 14),
                              _ActionsBar(
                                liked: _liked,
                                likesCount: _post!.likesCount,
                                commentsCount: _post!.commentsCount,
                                onLike: () {
                                  setState(() {
                                    _liked = !_liked;
                                  });
                                },
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Comentarios',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ..._post!.comments.map(
                                (PostCommentModel comment) =>
                                    _CommentTile(comment: comment),
                              ),
                            ],
                          ),
                        ),
                        _CommentInput(controller: _commentController),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onOptions});

  final VoidCallback onBack;
  final VoidCallback onOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          const Expanded(
            child: Text(
              'LOOP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: onOptions,
            icon: const Icon(Icons.more_vert),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}

class _AuthorHeader extends StatelessWidget {
  const _AuthorHeader({required this.post});

  final PostDetailModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.16),
            child: Text(
              post.authorInitials,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.authorName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  post.publishedLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (post.isActive)
            Row(
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Activo',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.post,
    required this.parseHex,
  });

  final PostDetailModel post;
  final Color Function(String?) parseHex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (post.title != null) ...<Widget>[
            Text(
              post.title!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            post.body,
            style: const TextStyle(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          if (post.hashtags.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.hashtags
                  .map(
                    (String tag) => Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (post.mediaLabel != null) ...<Widget>[
            const SizedBox(height: 14),
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    parseHex(post.mediaColorHex),
                    AppColors.primaryDark.withValues(alpha: 0.92),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  post.mediaLabel!,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({
    required this.liked,
    required this.likesCount,
    required this.commentsCount,
    required this.onLike,
  });

  final bool liked;
  final int likesCount;
  final int commentsCount;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          TextButton.icon(
            onPressed: onLike,
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? AppColors.error : AppColors.textSecondary,
              size: 18,
            ),
            label: Text(
              '$likesCount',
              style: TextStyle(
                color: liked ? AppColors.error : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined, size: 18),
            label: Text(
              '$commentsCount',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
            color: AppColors.primary,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final PostCommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.16),
                child: Text(
                  comment.authorInitials,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      comment.publishedLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.body,
            style: const TextStyle(
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('Me gusta'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Responder'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Agregar comentario...',
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Publicar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TopBar(onBack: onBack, onOptions: () {}),
        const Expanded(
          child: Center(
            child: Text(
              'Publicacion no encontrada',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
