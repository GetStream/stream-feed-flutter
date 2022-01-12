## 0.6.0: 12/01/2022

- BREAKING: bumped llc to 0.5.0, which is a breaking change. We no longer accept a token in the constructor. This change is inspired by Stream Chat, and allows for use cases like multi account management. It allows to instantiate `StreamFeedClient` at the top of your widget tree for example, and connecting the user later.
  
```diff
-  client = StreamFeedClient(apiKey, token: frontendToken);
+  client = StreamFeedClient(apiKey);
+
+  await client.setUser(
+    const User(
+      data: {
+        'name': 'John Doe',
+        'occupation': 'Software Engineer',
+        'gender': 'male'
+      },
+    ),
+    frontendToken,
+  );
```

## 0.5.0: 27/12/2021

- fix: the convenient typedefs on generic classes we provided was breaking autocomplete
- breaking: we renamed some methods
  - `followFlatFeed` -> `followFeed`
  - `unfollowFlatFeed` -> `unfollowFeed`
  - `isFollowingUser` -> `isFollowingFeed`
- fix: export MediaUri
- new: add scrollPhysics parameter to `ReactionListCore`
  
## 0.4.1: 22/12/2021

- new: UploadListCore and UploadController

## 0.4.0+1: 07/12/2021

- Use secure link in readme
- version bump llc

## 0.4.0: 29/10/2021

- first release
