/// Session data structure for user sessions
/// 
/// Note: For caching, this should be converted to a SerializableModel
/// or stored in database. Current implementation uses JSON serialization.
class SessionData {
  /// User ID associated with this session
  final String userId;
  
  /// Unique session identifier
  final String sessionId;
  
  /// When the session was created
  final DateTime createdAt;
  
  /// Last time the session was accessed
  final DateTime lastAccessedAt;
  
  /// When the session expires (null if no expiration)
  final DateTime? expiresAt;
  
  /// Additional metadata stored with the session
  final Map<String, dynamic> metadata;

  SessionData({
    required this.userId,
    required this.sessionId,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    this.expiresAt,
    Map<String, dynamic>? metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastAccessedAt = lastAccessedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  /// Create a copy with updated fields
  SessionData copyWith({
    String? userId,
    String? sessionId,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) {
    return SessionData(
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if session is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from JSON map
  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
    );
  }

}
