package dust.gui.data;

import dust.components.Component;

class Alignment extends Component
{
    inline public static function DEFAULT():Alignment
        return new Alignment(HAlign.LEFT, VAlign.TOP)

    public var vAlign:VAlign;
    public var hAlign:HAlign;

    public function new(hAlign:HAlign, vAlign:VAlign)
    {
        this.vAlign = vAlign;
        this.hAlign = hAlign;
    }
}
