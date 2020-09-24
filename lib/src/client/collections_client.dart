import 'package:stream_feed_dart/src/models/collection_data.dart';

abstract class CollectionsClient {
  ///**
//    * get item from collection
//    * @method get
//    * @memberof Collections.prototype
//    * @param  {string}   collection  collection name
//    * @param  {string}   itemId  id for this entry
//    * @return {Promise<CollectionEntry<CollectionType>>}
//    * @example collection.get("food", "0c7db91c-67f9-11e8-bcd9-fe00a9219401")
//    */
//   async get(collection: string, itemId: string) {
//     const response = await this.client.get<CollectionAPIResponse<CollectionType>>({
//       url: this.buildURL(collection, itemId),
//       signature: this.token,
//     });
//
//     const entry = this.entry(response.collection, response.id, response.data);
//     entry.full = response;
//     return entry;
//   }

  Future<CollectionData> get(String collection, String itemId);

//   /**
//    * Add item to collection
//    * @method add
//    * @memberof Collections.prototype
//    * @param  {string}   collection  collection name
//    * @param  {string}   itemId  entry id
//    * @param  {CollectionType}   itemData  ObjectStore data
//    * @return {Promise<CollectionEntry<CollectionType>>}
//    * @example collection.add("food", "cheese101", {"name": "cheese burger","toppings": "cheese"})
//    */
//   async add(collection: string, itemId: string, itemData: CollectionType) {
//     const response = await this.client.post<CollectionAPIResponse<CollectionType>>({
//       url: this.buildURL(collection),
//       body: {
//         id: itemId === null ? undefined : itemId,
//         data: itemData,
//       },
//       signature: this.token,
//     });
//
//     const entry = this.entry(response.collection, response.id, response.data);
//     entry.full = response;
//     return entry;
//   }

  Future<CollectionData> add(String collection, String itemId,
      CollectionData data);

//   /**
//    * Update entry in the collection
//    * @method update
//    * @memberof Collections.prototype
//    * @param  {string}   collection  collection name
//    * @param  {string}   entryId  Collection object id
//    * @param  {CollectionType}   data  ObjectStore data
//    * @return {Promise<CollectionEntry<CollectionType>>}
//    * @example store.update("0c7db91c-67f9-11e8-bcd9-fe00a9219401", {"name": "cheese burger","toppings": "cheese"})
//    * @example store.update("food", "cheese101", {"name": "cheese burger","toppings": "cheese"})
//    */
//   async update(collection: string, entryId: string, data: CollectionType) {
//     const response = await this.client.put<CollectionAPIResponse<CollectionType>>({
//       url: this.buildURL(collection, entryId),
//       body: { data },
//       signature: this.token,
//     });
//
//     const entry = this.entry(response.collection, response.id, response.data);
//     entry.full = response;
//     return entry;
//   }

  Future<CollectionData> update(String collection, String entryId,
      CollectionData data);

//   /**
//    * Delete entry from collection
//    * @method delete
//    * @memberof Collections.prototype
//    * @param  {string}   collection  collection name
//    * @param  {string}   entryId  Collection entry id
//    * @return {Promise<APIResponse>} Promise object
//    * @example collection.delete("food", "cheese101")
//    */
//   delete(collection: string, entryId: string) {
//     return this.client.delete({
//       url: this.buildURL(collection, entryId),
//       signature: this.token,
//     });
//   }

  Future<void> delete(String collection, String entryId);

//   /**
//    * Upsert one or more items within a collection.
//    *
//    * @method upsert
//    * @memberof Collections.prototype
//    * @param  {string}   collection  collection name
//    * @param {NewCollectionEntry<CollectionType> | NewCollectionEntry<CollectionType>[]} data - A single json object or an array of objects
//    * @return {Promise<UpsertCollectionAPIResponse<CollectionType>>}
//    */
//   upsert(collection: string, data: NewCollectionEntry<CollectionType> | NewCollectionEntry<CollectionType>[]) {
//     if (!this.client.usingApiSecret) {
//       throw new SiteError('This method can only be used server-side using your API Secret');
//     }
//
//     if (!Array.isArray(data)) data = [data];
//
//     return this.client.post<UpsertCollectionAPIResponse<CollectionType>>({
//       url: 'collections/',
//       serviceName: 'api',
//       body: { data: { [collection]: data } },
//       signature: this.client.getCollectionsToken(),
//     });
//   }

  Future<void> upsert(String collection, Iterable<CollectionData> data);

//   /**
//    * Select all objects with ids from the collection.
//    *
//    * @method select
//    * @memberof Collections.prototype
//    * @param {string} collection  collection name
//    * @param {string | string[]} ids - A single object id or an array of ids
//    * @return {Promise<SelectCollectionAPIResponse<CollectionType>>}
//    */
//   select(collection: string, ids: string | string[]) {
//     if (!this.client.usingApiSecret) {
//       throw new SiteError('This method can only be used server-side using your API Secret');
//     }
//
//     if (!Array.isArray(ids)) ids = [ids];
//
//     return this.client.get<SelectCollectionAPIResponse<CollectionType>>({
//       url: 'collections/',
//       serviceName: 'api',
//       qs: { foreign_ids: ids.map((id) => `${collection}:${id}`).join(',') },
//       signature: this.client.getCollectionsToken(),
//     });
//   }

  Future<List<CollectionData>> select(String collection, Iterable<String> ids);

//   /**
//    * Remove all objects by id from the collection.
//    *
//    * @method delete
//    * @memberof Collections.prototype
//    * @param {string} collection  collection name
//    * @param {string | string[]} ids - A single object id or an array of ids
//    * @return {Promise<APIResponse>}
//    */
//   deleteMany(collection: string, ids: string | string[]) {
//     if (!this.client.usingApiSecret) {
//       throw new SiteError('This method can only be used server-side using your API Secret');
//     }
//
//     if (!Array.isArray(ids)) ids = [ids];
//
//     const params = {
//       collection_name: collection,
//       ids: ids.map((id) => id.toString()).join(','),
//     };
//
//     return this.client.delete({
//       url: 'collections/',
//       serviceName: 'api',
//       qs: params,
//       signature: this.client.getCollectionsToken(),
//     });
//   }

  Future<void> deleteMany(String collection, Iterable<String> ids);
}
