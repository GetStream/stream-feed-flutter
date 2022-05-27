## [0.1.1+2] - (27-05-2022)
- nothing new / lints
  
## [0.1.1+1] - (25-02-2022)

- fix: implement Equatable on `FayeClient`. With this change, if you fetch your client from an `InheritedWidget` for example, `updateShouldNotify` doesn't trigger every time.


## [0.1.1] - (25-02-2022)

- new: expose connexion status stream `Stream<FayeClientState>` via the `Subscription` class to check if the Faye client is unconnected, connecting, connected or disconnected, and act accordingly.


## [0.1.0] - (07-05-2021)

* Initial release.
