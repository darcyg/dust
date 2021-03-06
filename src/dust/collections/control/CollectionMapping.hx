package dust.collections.control;

import dust.collections.data.CollectionList;
import dust.collections.api.Collection;
import dust.collections.api.CollectionListeners;
import dust.commands.Command;
import dust.components.Bitfield;
import dust.components.Component;
import dust.entities.api.Entity;
import dust.entities.api.Entities;
import dust.entities.impl.EntityList;
import dust.lists.LinkedList;
import dust.lists.SimpleList;

import dust.Injector;

class CollectionMapping
{
    function emptyMethod(entity:Entity) {}

    public var injector:Injector;
    var bitfield:Bitfield;
    var collectionList:CollectionList;
    var subscriber:CollectionSubscriber;
    var listenersMap:CollectionListenersMap;

    var instance:Collection;
    var components:Array<Class<Component>>;

    public function new(parent:Injector, bitfield:Bitfield, collectionList:CollectionList, subscriber:CollectionSubscriber)
    {
        injector = new Injector(parent);

        this.bitfield = bitfield;
        this.collectionList = collectionList;
        this.subscriber = subscriber;
        this.listenersMap = new CollectionListenersMap(injector);

        injector.mapValue(CollectionListenersMap, listenersMap);
    }

    public function setComponents(components:Array<Class<Component>>):CollectionMapping
    {
        this.components = components;
        return this;
    }

    public function toListeners(listener:Class<CollectionListeners>):CollectionMapping
    {
        listenersMap.addListener(listener);
        return this;
    }

    public function getCollection():Collection
    {
        if (instance == null)
            instance = makeAndPopulateCollection();
        return instance;
    }

        function makeAndPopulateCollection():Collection
        {
            var collection = makeCollection();
            collectionList.append(collection);
            populateCollection(collection);
            return collection;
        }

            function makeCollection():Collection
            {
                var list = new EntityList(new SimpleList<Entity>());
                var listeners = listenersMap.make();
                return new Collection(bitfield, list, listeners.onEntityAdded, listeners.onEntityRemoved);
            }

        function populateCollection(collection:Collection)
            subscriber.updateCollection(collection)
}