# What function does `stream_feed_flutter` serve?

The UI SDK, `stream_feed_flutter`, contains official Flutter components for Stream Feed, a service for building social feed applications.

While the Stream Feed service provides the backend for messaging and the LLC (low-level client) provides an easy way to use it in your Flutter apps, we wanted to make sure that adding Feed functionality to your app was as quick as possible.

The UI package is built on top of the low-level client and the core package and allows you to build a full fledged application with the built-in components, modify existing components, or easily add widgets of your own to match your app's style better.

# Basic Concepts
In this section you will learn about "feeds" and "activities", the core concepts of Stream Feed

## Feeds
In Stream Feeds, an Activity Feed is a Stack (First In Last Out) of `activity` objects. There are three kinds of feeds:

1. Flat - the default feed type, and the **only** feed type you can follow
2. Aggregated - helpful for grouping activities
3. Notification - extend the "Aggregated Feed Group" concept with additional features that make them well suited to notification systems

Feeds are the most important building block for Stream Feeds, because your application will not work without them.

## Activities
In Stream Feeds, an item in a feed is called an `activity`. In its simplest form, an `activity` consists of an `actor`, a `verb`, and an `object`. It tells the story of a person performing an action on or with an object.

In its simplest form, adding an activity to a feed means passing an object with the following basic properties:
* `actor`
* `verb`
* `object`

It is also recommended to pass a foreign ID and the Time.

Let's take a look at the following example:

_“Erik is pinning Hawaii to his Places to Visit board.”_

We can identify the components of this activity as follows:
* The `actor` is "Eric" (User:1)
* The `verb` is "pin"
* The `object` is "Hawaii" (Place:42)
* The foreign ID is Eric's "Places to visit board"  (Activity:1)
* The time (for this example) would be `2017-07-01T20:30:45.123`

NOTE: As seen above, the timestamp does not contain any timezone data. However, all Stream timestamps are in UTC time.