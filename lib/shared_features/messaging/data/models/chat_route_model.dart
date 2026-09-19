class ChatRouteArgs {
  final String id;
  final String recipientName;
  final String recipientRole;
  final int unreadCount;

  ChatRouteArgs({
    required this.id,
    required this.recipientName,
    required this.recipientRole,
    required this.unreadCount,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatRouteArgs && other.id == id;

  @override
  int get hashCode => id.hashCode;
}