import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Publicacion con bloque de imagen a sangre completa (sin bordes redondeados).
class FullBleedPublicationCard extends StatelessWidget {
  const FullBleedPublicationCard({
    super.key,
    required this.userLabel,
    required this.contextLabel,
    required this.onOpen,
    this.imageLabel,
    this.imageColorHex,
    this.caption,
    this.likes = 0,
    this.comments = 0,
    this.title,
    this.body,
    this.replies,
  });

  final String userLabel;
  final String contextLabel;
  final VoidCallback onOpen;
  final String? imageLabel;
  final String? imageColorHex;
  final String? caption;
  final int likes;
  final int comments;
  final String? title;
  final String? body;
  final int? replies;

  bool get _hasMedia => imageLabel != null && imageLabel!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.inputBackground,
                    child: Icon(Icons.person, color: AppColors.primary, size: 19),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userLabel,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          contextLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            if (body != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(
                  body!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.34,
                  ),
                ),
              ),
            if (_hasMedia)
              SizedBox(
                width: double.infinity,
                height: 210,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        _parseHex(imageColorHex),
                        AppColors.primaryDark.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      imageLabel!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.favorite_border,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text('$likes'),
                  const SizedBox(width: 18),
                  const Icon(Icons.mode_comment_outlined,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text('${replies ?? comments}'),
                  const Spacer(),
                  const Icon(Icons.send_outlined, color: AppColors.primary),
                ],
              ),
            ),
            if (caption != null && caption!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.32,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$userLabel ',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      TextSpan(text: caption),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(height: 14),
            const Divider(height: 8, thickness: 8, color: Color(0xFFEAF4FC)),
          ],
        ),
      ),
    );
  }

  Color _parseHex(String? value) {
    final String clean = (value ?? '#D9EAF5').replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}
