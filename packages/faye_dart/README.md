# faye_dart

Faye is a publish/subscribe messaging protocol that is built on the Bayeux protocol, a messaging system utilized for transporting asynchronous messages over HTTP.

## Getting Started

```dart
var client = FayeClient(url);
```


## Subscribing to channels

Clients receive data from other clients by subscribing to channels. Whenever any client sends a message to a channel you’re subscribed to, Faye will notify your client with the new message.

Channel names must be formatted as absolute path names whose segments may contain only letters, numbers, and the symbols -, _, !, ~, (, ), $ and @. Channel names may also end with wildcards:

    The * wildcard matches any channel segment. So /foo/* matches /foo/bar and /foo/thing but not /foo/bar/thing.
    The ** wildcard matches any channel name recursively. So /foo/** matches /foo/bar, /foo/thing and /foo/bar/thing.

So for example if you subscribe to /foo/* and someone sends a message to /foo/bar, you will receive that message.

Clients should subscribe to channels using the #subscribe() method:
```dart
var subscription = client.subscribe('/foo', (data)=> print(data));
```
The subscriber function will be invoked when anybody sends a message to /foo, and the message parameter will contain the sent message object. A client may bind multiple listeners to a channel, and the Faye client handles all the management of those listeners and makes sure the server sends it the right messages.

The subscribe() method returns a Subscription object, which you can cancel if you want to remove that listener from the channel.
```dart
subscription.cancel();
```