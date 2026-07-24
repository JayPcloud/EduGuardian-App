import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/messaging_components.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mrs. Akunne', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer)),
            Text('Ebele\'s Teacher', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Sizes.paddingL),
              children: const [
                ChatBubble(
                  text: 'Oh, that is wonderful news! Thank you so much for the update, Mrs. Adebayo. She was practicing all night.',
                  time: 'Yesterday, 03:00 PM',
                  isSender: false,
                ),
                ChatBubble(
                  text: 'It really showed! She was very confident.',
                  time: 'Yesterday, 3:10 PM',
                  isSender: true,
                ),
                ChatBubble(
                  text: 'Oh, that is wonderful news! Thank you so much for the update, Mrs. Adebayo. She was practicing all night.',
                  time: 'Today, 03:00 PM',
                  isSender: false,
                ),
              ],
            ),
          ),
          
          // Modern Bottom Input Area
          Container(
            padding: const EdgeInsets.only(
              left: Sizes.paddingM,
              right: Sizes.paddingM,
              top: Sizes.paddingS,
              bottom: Sizes.paddingL, // Gives breathing room at the very bottom
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attachment Button (+)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap: () {
                        // TODO: Handle attachments
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        child: Icon(Icons.add, color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  
                  // Text Field
                  Expanded(
                    child: TextField(
                      maxLines: 4, // Auto-expands up to 4 lines
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outlineVariant,
                        ),
                        filled: true,
                        fillColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.paddingM, 
                          vertical: Sizes.paddingSm,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.radiusXL),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.radiusXL),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  
                  // Send Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap: () {
                        // TODO: Handle send message
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}