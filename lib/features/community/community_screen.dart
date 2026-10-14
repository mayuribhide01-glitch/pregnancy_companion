import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../shell/main_shell.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final posts = state.posts;
    return Column(
      children: [
        PageHeader(
          title: 'Community',
          onBack: () => MainShell.goTo(context, MainShell.home),
        ),
        const _Composer(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
                16, 10, 16, MainShell.contentBottomInset),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _PostCard(
              post: posts[i],
              onLike: () => state.toggleLike(posts[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.color, this.bg});

  final String initials;
  final Color color;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg ?? color.withAlpha(0x21),
        border: Border.all(color: color),
      ),
      child: Text(initials,
          style: AppText.l(13.3, weight: FontWeight.w700, color: color)),
    );
  }
}

class _Composer extends StatefulWidget {
  const _Composer();

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _post() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    AppStateScope.of(context).addPost(text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.lavenderBorder)),
      ),
      child: Row(
        children: [
          const _Avatar(
            initials: 'ME',
            color: AppColors.pink400,
            bg: AppColors.pink50,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _post(),
                style: AppText.l(14, color: AppColors.gray900),
                cursorColor: AppColors.pink500,
                decoration: InputDecoration(
                  hintText: 'Write something...',
                  hintStyle: AppText.l(14, color: AppColors.gray400),
                  filled: true,
                  fillColor: AppColors.gray100,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, v, _) => v.text.trim().isEmpty
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: _post,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.send_rounded,
                                  size: 18, color: AppColors.pink500),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onLike});

  final CommunityPost post;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final count = AppText.l(13, weight: FontWeight.w600, color: AppColors.gray400);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lavenderBorder),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(initials: post.initials, color: post.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.author,
                        style: AppText.l(16,
                            weight: FontWeight.w700, color: AppColors.gray900)),
                    Text(post.timeAgo,
                        style: AppText.l(11, color: AppColors.gray400)),
                  ],
                ),
              ),
              Text('···', style: AppText.o(18, color: AppColors.gray400)),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.text,
              style: AppText.l(14, color: AppColors.gray600, height: 1.5)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.gray100),
          Row(
            children: [
              TextButton.icon(
                onPressed: onLike,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  post.liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color: post.liked ? AppColors.pink500 : AppColors.gray400,
                ),
                label: Text('${post.likes}', style: count),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline_rounded,
                  size: 16, color: AppColors.gray400),
              const SizedBox(width: 6),
              Text('${post.comments}', style: count),
              const Spacer(),
              IconButton(
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.share_outlined,
                    size: 16, color: AppColors.gray400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
