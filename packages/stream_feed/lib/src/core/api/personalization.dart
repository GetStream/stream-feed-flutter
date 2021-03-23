class PersonalizationApi {
  const PersonalizationApi(this.client);

  final HttpClient client;

  Future<Map> get(Token token, String userID, String resource, Map<String, Object> params) async {
       checkNotNull(resource, "Resource can't be empty");
    checkArgument(!resource.isEmpty(), "Resource can't be empty");
    checkNotNull(params, "Missing params");
    final result = await client.get(
      Routes.personalizationURL(resource),
      headers: {'Authorization': '$token'},
           queryParameters: params,
    );
    return result.data;
  }

  Future<void> post(Token token,  String userID,
      String resource, Map<String, Object> params,Map<String, Object> payload) {
  checkNotNull(resource, "Resource can't be empty");
    checkArgument(!resource.isEmpty(), "Resource can't be empty");
    checkNotNull(params, "Missing params");
    checkNotNull(params, "Missing payload");
     client.post(
      Routes.personalizationURL(resource),
      headers: {'Authorization': '$token'},
      queryParameters: params,
      data:  json.encode(payload)
    );
  }

  Future<void> delete(Token token,  String userID,
      String resource, Map<String, Object> params) {
      checkNotNull(resource, "Resource can't be empty");
    checkArgument(!resource.isEmpty(), "Resource can't be empty");
    checkNotNull(params, "Missing params");
     client.delete(
      Routes.personalizationURL(resource),
      headers: {'Authorization': '$token'},
      queryParameters: params,
    );
  }
}