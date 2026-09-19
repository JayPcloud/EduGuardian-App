import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
              // backgroundImage: AssetImage(image),
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
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outlineVariant,
                      fontWeight: time.isEmpty?FontWeight.normal:null,
                      fontStyle: time.isEmpty?FontStyle.italic:null
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(width: Sizes.spaceS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: theme.textTheme.labelSmall?.copyWith(
                  color: unreadCount > 0? theme.colorScheme.primary: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
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

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Column(
        children: List.generate(6, (index) => Padding(
          padding: const EdgeInsets.only(bottom: Sizes.spaceL),
          child: Row(
            children: [
              Container(width: 48, height: 48, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              const SizedBox(width: Sizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 150, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 12, width: double.infinity, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(width: Sizes.spaceM),
              Container(height: 12, width: 40, color: Colors.white),
            ],
          ),
        )),
      ),
    );
  }
}

// --- CHAT BUBBLE (For Chat Detail Screen) ---
class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isSender;
  final bool isRead;
  final bool hasReceived;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isSender,
    this.isRead = false,
    this.hasReceived = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Tick color logic (Assuming sender bubble is a dark primary color, we use light colors for contrast)
    final tickColor = isRead ? const Color(0xFF4FC3F7) : Colors.white60; // Light blue if read, transparent white if not

    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceL),
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSender ? colorScheme.onPrimaryContainer : colorScheme.surfaceContainer.withValues(alpha: 0.5),
          border: isSender ? null : Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(Sizes.radiusXL),
            bottomRight: const Radius.circular(Sizes.radiusXL),
            topLeft: Radius.circular(isSender ? Sizes.radiusXL : 0),
            topRight: Radius.circular(isSender ? 0 : Sizes.radiusXL),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Message Body
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSender ? Colors.white : colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            
            // Time and Ticks Row
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: isSender ? Colors.white70 : colorScheme.outlineVariant,
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead || hasReceived ? Icons.done_all : Icons.check, // Double tick if read/received, single if just sent
                    size: Sizes.iconXS,
                    color: tickColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class UnreadMessagesBanner extends StatelessWidget {
  final int count;
  const UnreadMessagesBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.spaceM),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count UNREAD MESSAGE${count > 1 ? 'S' : ''}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class ChatDetailShimmer extends StatelessWidget {
  const ChatDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(Sizes.paddingL),
        itemCount: 6,
        itemBuilder: (context, index) {
          final isSender = index % 2 == 0; // Alternate sides for realism
          return Align(
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: Sizes.spaceM),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
            ),
          );
        },
      ),
    );
  }
}


class ModernChatLoader extends StatelessWidget {
  const ModernChatLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Sizes.paddingL),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Loading older messages...',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}