/// Returns a new collection reference string in the form SO:<collection>:<id>.
String createCollectionReference(String? collection, String? id) =>
    'SO:$collection:$id';

/// Returns a new user reference string in the form SU:<id>.
String createUserReference(String id) => 'SU:$id';

/// Returns a new collection reference string in the form SA:<id>.
String createActivityReference(String id) => 'SA:$id';

/// Returns a new reaction reference string in the form SR:<id>.
String createReactionReference(String id) => 'SR:$id';
