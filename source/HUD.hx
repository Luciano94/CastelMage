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
	private var livesSprite:FlxSprite;
	private var ammo:FlxText;
	private var ammoSprite:FlxSprite;
	private var score:FlxText;
	
	public function new() 
	{
		super();
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, 32, FlxColor.BLACK);
		background.scrollFactor.set(0, 0);
		add(background);
		
		lives = new FlxText(FlxG.width / 2 - 16, 8, 0, "3", 11, true);
		lives.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		lives.scrollFactor.set(0, 0);
		add(lives);
		
		livesSprite = new FlxSprite(FlxG.width / 2 - 32, 8, AssetPaths.lives__png);
		livesSprite.scrollFactor.set(0, 0);
		add(livesSprite);
		
		ammo = new FlxText(FlxG.width / 2 + 16, 8, 0, "3", 11, true);
		ammo.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		ammo.scrollFactor.set(0, 0);
		add(ammo);
		
		
		
		score = new FlxText(FlxG.width - 96, 8, "Score: 0", 11, true);
		score.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		score.scrollFactor.set(0, 0);
		add(score);
		
	}
	
	public function updateHUD(l:Int, s:Int):Void
	{
		lives.text = Std.string(l);
		score.text = "Score: " + Std.string(s);
	}
}