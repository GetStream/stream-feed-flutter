import 'package:stream_feed_dart/src/models/user.dart';

abstract class UsersClient {
//public async Task<User> Add(string userID, IDictionary<string, object> data = null, bool getOrCreate = false)
//         {
//             var u = new User()
//             {
//                 ID = userID,
//                 Data = data,
//             };
//             var request = this._client.BuildJWTAppRequest("user/", HttpMethod.POST);
//
//             request.SetJsonBody(JsonConvert.SerializeObject(u));
//             request.AddQueryParameter("get_or_create", getOrCreate.ToString());
//
//             var response = await this._client.MakeRequest(request);
//
//             if (response.StatusCode == System.Net.HttpStatusCode.Created)
//                 return JsonConvert.DeserializeObject<User>(response.Content);
//
//             throw StreamException.FromResponse(response);
//         }

  Future<User> add(
    String userId,
    Map<String, Object> data, {
    bool getOrCreate = false,
  });

//         public async Task<User> Get(string userID)
//         {
//             var request = this._client.BuildJWTAppRequest($"user/{userID}/", HttpMethod.GET);
//
//             var response = await this._client.MakeRequest(request);
//
//             if (response.StatusCode == System.Net.HttpStatusCode.OK)
//                 return JsonConvert.DeserializeObject<User>(response.Content);
//
//             throw StreamException.FromResponse(response);
//         }

  Future<User> get(String id);

//         public async Task<User> Update(string userID, IDictionary<string, object> data)
//         {
//             var u = new User()
//             {
//                 Data = data,
//             };
//             var request = this._client.BuildJWTAppRequest($"user/{userID}/", HttpMethod.PUT);
//             request.SetJsonBody(JsonConvert.SerializeObject(u));
//
//             var response = await this._client.MakeRequest(request);
//
//             if (response.StatusCode == System.Net.HttpStatusCode.Created)
//                 return JsonConvert.DeserializeObject<User>(response.Content);
//
//             throw StreamException.FromResponse(response);
//         }

  Future<User> update(String id, Map<String, Object> data);

//         public async Task Delete(string userID)
//         {
//             var request = this._client.BuildJWTAppRequest($"user/{userID}/", HttpMethod.DELETE);
//
//             var response = await this._client.MakeRequest(request);
//
//             if (response.StatusCode != System.Net.HttpStatusCode.OK)
//                 throw StreamException.FromResponse(response);
//         }
//
//         public static string Ref(string userID)
//         {
//             return string.Format("SU:{0}", userID);
//         }
//
//         public static string Ref(User obj)
//         {
//             return Ref(obj.ID);
//         }
//     };

  Future<void> delete(String id);
}
