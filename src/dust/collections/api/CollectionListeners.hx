package dust.collections.api;

import dust.entities.api.Entity;

interface CollectionListeners
{
    function onEntityAdded(entity:Entity):Void;
    function onEntityRemoved(entity:Entity):Void;
}
