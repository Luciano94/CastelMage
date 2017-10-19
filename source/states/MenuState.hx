package source.states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var playButton:FlxButton;
	
	override public function create():Void
	{
		super.create();
		
		title = new FlxText(0, FlxG.height / 4, 0, "Castlevania", 12, true);
		title.screenCenter(X);
		add(title);
		
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.screenCenter();
		add(playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}