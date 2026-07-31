import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class ChatListItem extends StatelessWidget {
  final String image;
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.image,
    required this.name,
    required this.preview,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      radius: 5,
      borderRadius: BorderRadius.circular(Sizes.radiusXL),
      child: Container(
        margin: const EdgeInsets.only(bottom: Sizes.spaceM),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.8)),
          borderRadius: BorderRadius.circular(Sizes.radiusXL), // Pill shape from design
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)
                  ),
                ],
              ),
            ),
            const SizedBox(width: Sizes.spaceS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: Sizes.spaceXS),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryContainer, // Dark Navy
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- CHAT BUBBLE (For Chat Detail Screen) ---
class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isSender;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceL),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(Sizes.paddingM),
            decoration: BoxDecoration(
              color: isSender ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.surface,
              border: isSender ? null : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(Sizes.radiusXL),
                bottomRight: const Radius.circular(Sizes.radiusXL),
                topLeft: Radius.circular(isSender ? Sizes.radiusXL : 0),
                topRight: Radius.circular(isSender ? 0 : Sizes.radiusXL),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSender ? Colors.white : theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceXS),
          Text(
            time,
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant),
          ),
        ],
      ),
    );
  }
}