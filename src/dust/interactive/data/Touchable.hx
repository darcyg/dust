package dust.interactive.data;

import dust.entities.api.Entity;
import dust.components.Component;

class Touchable extends Component
{
    public var execute:Entity->Void;

    public function new(execute:Entity->Void)
        this.execute = execute
}
