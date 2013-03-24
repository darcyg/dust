package dust.text.control;

import nme.display.BitmapData;
import dust.text.data.BitmapFont;

class BitmapFontFactory
{
    @inject public var charFactory:BitmapFontCharFactory;

    public function make(definition:String, sources:Array<BitmapData>):BitmapFont
    {
        var font = new BitmapFont();

        var data = makeDataArray(definition);
        for (datum in data)
        {
            switch (datum.name)
            {
                case 'info':
                    applyInfo(font, datum.data);
                case 'common':
                    applyCommon(font, datum.data);
                case 'char':
                    addChar(font, datum.data, sources);
                case 'kerning':
                    addKerning(font, datum.data);
            }
        }

        return font;
    }

    function makeDataArray(data:String):Array<BitmapFontData>
    {
        var lines = data.split('\n');
        var array = new Array<BitmapFontData>();
        for (line in lines)
            array.push(makeData(line));
        return array;
    }

    function makeData(line:String):BitmapFontData
    {
        var pairs = line.split(" ");
        var name = pairs.shift();
        var hash = new Hash<Dynamic>();
        for (pair in pairs)
        {
            var keyvalue = pair.split("=");
            if (keyvalue.length > 1)
                hash.set(keyvalue[0], keyvalue[1]);
        }

        return {name:name, data:hash};
    }

    function applyInfo(font:BitmapFont, data:Hash<Dynamic>)
    {
        font.font = data.get('face');
        font.size = data.get('size');
        font.bold = data.get('bold') != 0;
        font.italic = data.get('italic') != 0;
    }

    function applyCommon(font:BitmapFont, data:Hash<Dynamic>)
    {
        font.lineHeight = data.get('lineHeight');
        font.base = data.get('base');
    }

    function addChar(font:BitmapFont, data:Hash<Dynamic>, sources:Array<BitmapData>)
        font.addChar(charFactory.make(data, sources))

    function addKerning(font:BitmapFont, data:Hash<Dynamic>)
    {
        var char = font.getChar(data.get('first'));
        if (char != null)
            char.addKerning(data.get('second'), data.get('amount'));
    }
}

typedef BitmapFontData = {name:String, data:Hash<Dynamic>}