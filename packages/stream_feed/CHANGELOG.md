## 0.3.0: 03/09/2021

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
  
- ## 0.2.3: 03/08/2021

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