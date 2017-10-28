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
		
		ammo = new FlxText(FlxG.width / 2 + 16, 8, 0, "10", 11, true);
		ammo.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		ammo.scrollFactor.set(0, 0);
		add(ammo);
		
		ammoSprite = new FlxSprite(FlxG.width / 2, 8, AssetPaths.weapons__png);
		ammoSprite.loadGraphic(AssetPaths.weapons__png, true, 16, 16);
		ammoSprite.animation.add("thunder", [0], 12, false);
		ammoSprite.animation.add("spear", [1], 12, false);
		ammoSprite.animation.add("shuriken", [2], 12, false);
		ammoSprite.scrollFactor.set(0, 0);
		add(ammoSprite);
		
		score = new FlxText(FlxG.width - 80, 8, "Score: 0", 11, true);
		score.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		score.scrollFactor.set(0, 0);
		add(score);
		
	}
	
	public function updateHUD(Lives:Int, Weapon:String, Ammo:Int, Score:Int):Void
	{
		lives.text = Std.string(Lives);
		if (Lives <= 1)
			lives.color = FlxColor.RED;
		ammo.text = Std.string(Ammo);
		score.text = "Score: " + Std.string(Score);
		switch (Weapon)
		{
			case "SINWEA":
				ammoSprite.animation.play("thunder");
			case "WEASPEAR":
				ammoSprite.animation.play("spear");
			case "WEASHURIKEN":
				ammoSprite.animation.play("shuriken");
		}
	}
}