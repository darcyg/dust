package dust.text.eg;

import dust.canvas.data.BitmapPainter;
import dust.canvas.data.NoScaleBitmapPainter;
import dust.camera.data.Camera;
import dust.camera.CameraConfig;
import dust.camera.CameraConfig;
import dust.canvas.data.PrioritizedPainter;
import dust.math.MathConfig;
import nme.display.Bitmap;
import dust.text.control.BitmapTextFactory;
import nme.Assets;
import dust.text.control.BitmapFontFactory;
import dust.geom.data.Position;
import dust.entities.api.Entities;
import dust.text.BitmapTextConfig;
import dust.canvas.PrioritizedPaintersConfig;
import dust.context.Config;
import dust.context.DependentConfig;

class BitmapTextExample implements DependentConfig
{
    @inject public var entities:Entities;
    @inject public var fontFactory:BitmapFontFactory;
    @inject public var bitmapFactory:BitmapTextFactory;
    @inject public var camera:Camera;

    public function dependencies():Array<Class<Config>>
        return [CameraConfig, MathConfig, BitmapTextConfig, PrioritizedPaintersConfig]

    public function configure()
    {
        var fontDefinition = Assets.getText('assets/michroma-24-white.fnt');
        var fontBitmap = Assets.getBitmapData('assets/michroma-24-white.png');
        var font = fontFactory.make(fontDefinition, [fontBitmap]);
        var bitmap = bitmapFactory.make(font, "Hello World!");
        var painter = new BitmapPainter(bitmap);
        var priority = new PrioritizedPainter(painter, 1);

        var entity = entities.require();
        entity.add(new Position(0, 0));
        entity.add(priority);
        entity.add(camera);
    }
}
