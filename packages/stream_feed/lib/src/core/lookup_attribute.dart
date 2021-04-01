enum LookupAttribute {
  activityId,
  reactionId,
  userId,
}

/// Convenient class Extension on [LookupAttribute] enum
extension LookupAttributeX on LookupAttribute {
  /// Convenient method Extension to generate [attr] from [LookupAttribute] enum
  String? get attr => {
        LookupAttribute.activityId: 'activity_id',
        LookupAttribute.reactionId: 'reaction_id',
        LookupAttribute.userId: 'user_id',
      }[this];
}
