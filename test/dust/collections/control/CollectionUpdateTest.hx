package dust.collections.control;

import dust.entities.api.Entity;
import dust.collections.api.CollectionListeners;
import dust.components.MockComponentA;
import dust.systems.impl.Systems;
import dust.systems.SystemsConfig;
import nme.display.Sprite;
import dust.context.Context;
import dust.entities.api.Entities;

class CollectionUpdateTest
{
    var entities:Entities;
    var entity:Entity;
    var collectionMap:CollectionMap;
    var systems:Systems;

    @Before public function before()
    {
        var context = new Context()
            .configure(CollectionsConfig)
            .configure(SystemsConfig)
            .start(new Sprite());

        entities = context.injector.getInstance(Entities);
        entity = entities.require();
        collectionMap = context.injector.getInstance(CollectionMap);
        systems = context.injector.getInstance(Systems);

        MockListeners.isAdded = false;
        MockListeners.isRemoved = false;
        MockSelfRemovingListeners.isAdded = false;
        MockSelfRemovingListeners.isRemoved = false;
    }

        function mapListeners(listeners:Class<CollectionListeners>)
        {
            collectionMap.map([MockComponentA]).toListeners(listeners);
            collectionMap.instantiateAll();
        }

        function addComponent()
        {
            entity.add(new MockComponentA());
            systems.update();
        }

        function removeComponent()
        {
            entity.remove(MockComponentA);
            systems.update();
        }

    @Test public function collectionListenersOnAddedCalledWhenEntitySatisfiesCollection()
    {
        mapListeners(MockListeners);
        addComponent();
        Assert.isTrue(MockListeners.isAdded);
    }

    @Test public function collectionListenersOnRemoveCalledWhenEntityNoLongerSatisfiesCollection()
    {
        mapListeners(MockListeners);
        addComponent();
        removeComponent();
        Assert.isTrue(MockListeners.isRemoved);
    }

    @Test public function removeInSelfRemovingListenersWorks()
    {
        mapListeners(MockSelfRemovingListeners);
        addComponent();
        Assert.isFalse(entity.has(MockComponentA));
    }

    @Test public function selfRemovingListenersGetRemovedCall()
    {
        mapListeners(MockSelfRemovingListeners);
        addComponent();
        systems.update();
        Assert.isTrue(MockSelfRemovingListeners.isRemoved);
    }
}

class MockListeners implements CollectionListeners
{
    public static var isAdded:Bool;
    public static var isRemoved:Bool;

    public function new()
    {
        isAdded = false;
        isRemoved = false;
    }

    public function onEntityAdded(entity:Entity)
        isAdded = true

    public function onEntityRemoved(entity:Entity)
        isRemoved = true
}

class MockSelfRemovingListeners implements CollectionListeners
{
    public static var isAdded:Bool;
    public static var isRemoved:Bool;

    public function new()
    {
        isAdded = false;
        isRemoved = false;
    }

    public function onEntityAdded(entity:Entity)
    {
        isAdded = true;
        entity.remove(MockComponentA);
    }

    public function onEntityRemoved(entity:Entity)
    {
        isRemoved = true;
    }
}

