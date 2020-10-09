import sage.agi.AGIEvent;
import sage.agi.AGIEvent.KBM;
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

	override function init() {
		var stage = hxd.Window.getInstance();
		stage.resize(MAX_WIDTH, MAX_HEIGHT);

		hxd.Window.getInstance().addEventTarget(onEvent);
		Sys.setCwd("./build/hl");
		AGIInterpreter.instance.initialize();
		AGIInterpreter.instance.run(); // update via run so that CURRENT_PIC works
	}

	override function update(dt:Float) {
		AGIInterpreter.instance.run();

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

		var bitmap:Bitmap = new Bitmap(tile, s2d);
		bitmap.scale(scale);

		g.clear();
		g.drawTile(0, 0, bitmap.tile);
		g.endFill();
	}

	var scale:Float = 1;

	function onEvent(event:hxd.Event) {
		switch (event.kind) {
			case EKeyDown:
				trace(event.keyCode);
				AGIInterpreter.instance.KEYBOARD_BUFFER.push(new AGIKeyboardEvent(event.keyCode));

				// var stage = hxd.Window.getInstance();
				// if (event.keyCode == hxd.Key.UP) {
				// 	scale *= 2;
				// 	stage.resize(MAX_WIDTH * Std.int(scale), MAX_HEIGHT * Std.int(scale));
				// } else if (event.keyCode == hxd.Key.DOWN) {
				// 	if (scale != 1)
				// 		scale /= 2;
				// 	stage.resize(MAX_WIDTH * Std.int(scale), MAX_HEIGHT * Std.int(scale));
				// }
			case _:
				null;
		}
	}

	static function main() {
		new Main();
	}
}
