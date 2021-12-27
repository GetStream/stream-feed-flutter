/// {@template lookupAttribute}
/// Lookup objects based on attributes
/// {@endtemplate}
enum LookupAttribute {
  /// The id of the activity you want to lookup
  activityId,

  /// The id of the reaction you want to lookup
  reactionId,

  /// The id of the user you want to lookup
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
