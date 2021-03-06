package dust.console.ui;

import dust.app.data.App;
import nme.display.BlendMode;
import dust.signals.Signal;

import nme.display.Sprite;
import nme.events.KeyboardEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldType;

class ConsoleInput extends Sprite
{
    public var command:Signal<String>;

    var format:ConsoleFormat;
    var input:TextField;

    @inject
    public function new(app:App, format:ConsoleFormat)
    {
        super();
        this.format = format;
        this.input = makeInput(app);
        command = new Signal<String>();
    }

        function makeInput(app:App)
        {
            var input = new TextField();
            input.y = app.stageHeight - 20;
            input.width = app.stageWidth;
            input.height = 20;
            input.background = true;
            input.backgroundColor = 0x006600;
            input.defaultTextFormat = format;
            input.blendMode = BlendMode.LAYER;
            input.type = TextFieldType.INPUT;
            addChild(input);
            return input;
        }

    public function enable()
    {
        var stage = nme.Lib.current.stage;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.focus = input;
    }

    public function disable()
    {
        var stage = nme.Lib.current.stage;
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.focus = stage;
    }

        function onKeyDown(event:KeyboardEvent)
        {
            if (event.keyCode == 13)
            {
                var text = input.text;
                command.dispatch(text);
                input.text = "";
            }
        }
}
