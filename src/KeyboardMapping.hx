import haxe.ds.EnumValueMap;
import haxe.ds.IntMap;

enum Key {
	F1;
	F2;
}

enum KeyboardMapping {
	Mapping(key:Key, keyCode:Int, scanCode:Int);
}

class KBM extends IntMap<KeyboardMapping> {
	public function new() {
        super();
		this.set(120, Mapping(F1, 120, 0x3B));
	}
}
