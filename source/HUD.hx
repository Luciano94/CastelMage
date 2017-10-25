package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxBasic;
import flixel.text.FlxText;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var background:FlxSprite;
	private var lives:FlxText;
	
	public function new() 
	{
		super();
		background = new FlxSprite(30, 240);
		background.makeGraphic(FlxG.width, 30, FlxColor.BLACK);
		background.scrollFactor.set(0, 0);
		add(background);
		
		lives = new FlxText(0, 250, 0, "x 3", 12, true);
		lives.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		lives.alignment = FlxTextAlign.RIGHT;
		lives.scrollFactor.set(0, 0);
		add(lives);
		
	}
	
}