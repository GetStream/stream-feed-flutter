## 0.4.0+1: 01/11/2021

- fix: support null values `extraData`'s map
- fix: utc date parsing with a `JsonConverter<DateTime,String>` and `intl`
- fix: unread/unseen count in `NotificationGroup` model
  
## 0.4.0: 29/10/2021

- breaking: `StreamFeedClient.connect` is now `StreamFeedClient` for better user session handling.
The connect verb was confusing, and made you think that it will perform the connection immediately. Also it doesn't infer the id anymore from the token anymore. You can now have to call `setUser` down the tree or before `runApp`
- breaking: `setUser` now takes a `User` (must contain id) and a token. Passing the userToken in client constructor was making the whole instance depend on a single user.
- new: we support generics
`EnrichedActivity` is now `GenericEnrichedActivity<A,Ob,T,Or>` in order to have a more flexible API surface. Those generic parameters can be as follows:
A = [actor]: can be an User, String
Ob = [object] can a String, or a CollectionEntry
T = [target] can be a String or an Activity
Or = [origin] can be a String or a Reaction or an User
- breaking: along with these changes we removed `EnrichableField` field from `EnrichedActivity` 
- new: there is a type definition `EnrichedActivity` to handle most use cases of `GenericEnrichedActivity` (User,String,String,String)
- fix: a time drift issue in token generation when using the low level client sever-side
- bump: dart sdk package constraints to 2.14 to make use of typedefs for non function types


## 0.3.0: 06/09/2021

- improvements: 
  - docs
  - better error handling and expose exeception type
  - const constructors when possible
- breaking: `UserClient user(String userId)` is now `StreamUser user(String userId)` for easier state management
- breaking: change type of `Reaction` model field `user` from  `Map<String,dynamic>` to `User`
- new: serverside methods for CRUD operations on User(getUser, createUser, updateUser, deleteUser)
- new: `CancelToken`, `OnSendProgress` named parameters to support cancelling an upload and tracking its progress
- new: logger options to allow choosing the Logger level
- fix: missing field `ownChildren` in `Reaction` model
- new: allow sending enrichment flags in `filter` mehod
- new: createReactionReference
  
## 0.2.3: 03/08/2021

- remove dead links in Readmes
  
## 0.2.2: 14/06/2021

- fix: RealTime message serialization issue
RealtimeMessage newActivities field now of type `List<EnrichedActivity>` instead of `List<Activity>`

## 0.2.1: 26/05/2021

- fix: missing model exports

## 0.2.0: 21/05/2021

- fix: Follow model
- new: FollowRelation 
- breaking: un/followMany batch methods now accept `Iterable<FollowRelation>` parameter instead of `Iterable<Follow>`

## 0.1.3: 17/05/2021

- fix: EnrichedActivity Not Returning Reactions 
- update links in readme

## 0.1.2: 07/05/2021

- update dependencies

## 0.1.1: 07/05/2021

- first beta version