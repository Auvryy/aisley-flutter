class ChatProductAttachment {
  final String productId;
  final String title;
  final double price;
  final String imageUrl;

  const ChatProductAttachment({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final bool isFromBuyer;
  final String text;
  final String timestamp;
  final ChatProductAttachment? attachment;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isFromBuyer,
    required this.text,
    required this.timestamp,
    this.attachment,
  });
}

class ChatThread {
  final String id;
  final String boutiqueName;
  final String boutiqueAvatar;
  final String location;
  final List<ChatMessage> messages;
  final int unreadCount;
  final String lastActive;

  const ChatThread({
    required this.id,
    required this.boutiqueName,
    required this.boutiqueAvatar,
    required this.location,
    required this.messages,
    this.unreadCount = 0,
    required this.lastActive,
  });
}
