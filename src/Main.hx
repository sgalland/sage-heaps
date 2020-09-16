import KeyboardMapping.KBM;
import hxd.Event.EventKind;
import h2d.Graphics;
import hxd.BitmapData;
import sage.agi.helpers.AGIColor;
import h2d.Bitmap;
import hxd.PixelFormat;
import hxd.Pixels;
import h2d.Tile;
import sage.agi.interpreter.AGIInterpreter;

class Main extends hxd.App {
	static final MAX_WIDTH:Int = 320;
	static final MAX_HEIGHT:Int = 200;
	var kbm:KBM = new KBM();

	override function init() {
		hxd.Window.getInstance().addEventTarget(onEvent);
		// Sys.setCwd("./build/hl");
		AGIInterpreter.instance.initialize();
		AGIInterpreter.instance.run(); // update via run so that CURRENT_PIC works

		var x:Int = 0;
		var y:Int = 0;
		var g = new Graphics(s2d);
		var picturePixels = AGIInterpreter.instance.CURRENT_PIC.getPicturePixels();
		var bmpdata:BitmapData = new BitmapData(320, 200);

		var index:Int = 0;
		for (y in 0...MAX_HEIGHT) {
			for (x in 0...MAX_WIDTH) {
				var pixel = picturePixels.get(index);
				var pixelColor = AGIColor.getColorByDosColor(pixel);
				var color = new h3d.Vector(pixelColor.r / 255, pixelColor.g / 255, pixelColor.b / 255, 1).toColor();
				bmpdata.setPixel(x, y, color);
				index++;
			}
		}

		var tile = Tile.fromBitmap(bmpdata);
		bmpdata.dispose();

		g.clear();
		g.drawTile(0, 0, tile);
		g.endFill();
	}

	override function update(dt:Float) {
		AGIInterpreter.instance.run();
	}

	function onEvent(event:hxd.Event) {
		switch (event.kind) {
			case EKeyDown: 
				var mapping = kbm.get(event.charCode);
				trace('char: ${mapping}');
			// case EKeyUp: trace(event.toString());
			case _: null;
		}
	}

	static function main() {
		new Main();
	}
}
