package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.MenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(256, 240, MenuState, 1, 60, 60, true, true));
	}
}