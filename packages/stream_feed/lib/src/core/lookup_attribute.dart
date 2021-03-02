enum LookupAttribute {
  activityId,
  reactionId,
  userId,
}

extension LookupAttributeX on LookupAttribute {
  String get attr => {
        LookupAttribute.activityId: 'activity_id',
        LookupAttribute.reactionId: 'reaction_id',
        LookupAttribute.userId: 'user_id',
      }[this];
}
