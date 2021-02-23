enum LookupAttribute {
  activity_id,
  reaction_id,
  user_id,
}

extension LookupAttributeX on LookupAttribute {
  String get attr => {
        LookupAttribute.activity_id: 'activity_id',
        LookupAttribute.reaction_id: 'reaction_id',
        LookupAttribute.user_id: 'user_id',
      }[this];
}
