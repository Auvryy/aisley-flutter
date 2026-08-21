import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/data/mock_buyer_data.dart';
import '../../core/models/chat.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_image.dart';
import '../../state/buyer_state.dart';

class BuyerChatView extends StatefulWidget {
  const BuyerChatView({super.key});

  @override
  State<BuyerChatView> createState() => _BuyerChatViewState();
}

class _BuyerChatViewState extends State<BuyerChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInThreadView = true;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuyerState state, String text) {
    if (text.trim().isEmpty) return;
    state.sendMessage(text.trim());
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final threads = state.chatThreads;
    final activeThread = state.activeThread;

    if (!_isInThreadView || activeThread == null) {
      // Thread List View
      return Scaffold(
        appBar: AppBar(
          title: const Text('Boutique Concierge'),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: threads.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final thread = threads[index];
            final lastMsg = thread.messages.isNotEmpty ? thread.messages.last.text : 'No messages yet';

            return InkWell(
              onTap: () {
                state.selectChatThread(thread.id);
                setState(() => _isInThreadView = true);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    AisleyNetworkImage(
                      imageUrl: thread.boutiqueAvatar,
                      width: 48,
                      height: 48,
                      borderRadius: BorderRadius.circular(24),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                thread.boutiqueName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                thread.lastActive,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            thread.location,
                            style: const TextStyle(fontSize: 10, color: AisleyColors.accentPink),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (thread.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AisleyColors.accentPink,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${thread.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // Active Chat Conversation Screen
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => _isInThreadView = false),
        ),
        title: Row(
          children: [
            AisleyNetworkImage(
              imageUrl: activeThread.boutiqueAvatar,
              width: 36,
              height: 36,
              borderRadius: BorderRadius.circular(18),
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeThread.boutiqueName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    activeThread.location,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages Stream
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: activeThread.messages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final msg = activeThread.messages[index];
                return _buildMessageBubble(msg, isDark);
              },
            ),
          ),

          // Canned Inquiries Bar
          Container(
            height: 38,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: CANNED_INQUIRIES.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = CANNED_INQUIRIES[index];
                return ActionChip(
                  label: Text(prompt, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  backgroundColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                  side: BorderSide(
                    color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                  ),
                  onPressed: () => _sendMessage(state, prompt),
                );
              },
            ),
          ),

          // Sticky Bottom Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: isDark ? AisleyColors.obsidianSurface : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, size: 20, color: AisleyColors.accentPink),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Boutique catalog attachment selected.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message to the concierge...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (val) => _sendMessage(state, val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AisleyColors.accentPink,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                      onPressed: () => _sendMessage(state, _messageController.text),
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

  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    final isMe = msg.isFromBuyer;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? AisleyColors.accentPink
                    : (isDark ? AisleyColors.obsidianCard : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.attachment != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          AisleyNetworkImage(
                            imageUrl: msg.attachment!.imageUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.attachment!.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AisleyColors.textDarkPrimary,
                                  ),
                                ),
                                Text(
                                  AisleyFormatters.formatPhp(msg.attachment!.price),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AisleyColors.accentPink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: isMe ? Colors.white : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              msg.timestamp,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
