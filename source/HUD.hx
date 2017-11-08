package;

import entities.Player;
import entities.enemies.Boss;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxBasic;
import flixel.text.FlxText;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var background:FlxSprite;
	private var backgroundFill:FlxSprite;
	private var lives:FlxText;
	private var livesSprite:FlxSprite;
	private var ammo:FlxText;
	private var ammoSprite:FlxSprite;
	private var score:FlxText;
	private var pause:FlxText;
	private var playerHealth:FlxBar;
	private var bossHealth:FlxBar;
	
	public function new(player:Player, boss:Boss)
	{
		super();
		
		backgroundSetUp();
		playerHealthBarSetUp(player);
		bossHealthBarSetUp(boss);
		livesSetUp();	
		ammoSetUp();
		scoreSetUp();
		pauseSetUp();
	}
	
	public function updateHUD(Lives:Int, Weapon:String, Ammo:Int, Score:Int, Paused:Bool):Void
	{
		lives.text = Std.string(Lives);
		if (Lives <= 1)
			lives.color = FlxColor.RED;
		else
			lives.color = FlxColor.WHITE;
		
		ammo.text = Std.string(Ammo);
		if (Ammo < 4)
		{
			if (Ammo == 0)
				ammo.visible = false;
			else
				ammo.color = FlxColor.RED;
		}
		else
			ammo.color = FlxColor.WHITE;
		if (Ammo > 0)
			ammo.visible = true;
		
		score.text = "Score: " + Std.string(Score);
		
		switch (Weapon)
		{
			case "SINWEA":
				ammoSprite.animation.play("noWeapon");
			case "WEASPEAR":
				ammoSprite.animation.play("spear");
			case "WEASHURIKEN":
				ammoSprite.animation.play("shuriken");
			case "WEAPOTION":
				ammoSprite.animation.play("poison");
		}
		
		if (Paused)
			pause.visible = true;
		else
			pause.visible = false;
		
		//if (Reg.bossFight)
			//bossHealth.visible = true;
		//else
			//bossHealth.visible = false;
	}
	
	private function backgroundSetUp():Void 
	{
		background = new FlxSprite(0, 0);
		backgroundFill = new FlxSprite();
		backgroundFill.makeGraphic(FlxG.width - 2, 30, FlxColor.BLACK);
		background.makeGraphic(FlxG.width, 32, FlxColor.WHITE);
		background.stamp(backgroundFill, 1, 1);
		background.scrollFactor.set(0, 0);
		add(background);
	}
	
	private function livesSetUp():Void 
	{
		lives = new FlxText(FlxG.width / 2 - 16, 8, 0, "3", 11, true);
		lives.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		lives.scrollFactor.set(0, 0);
		add(lives);
		
		livesSprite = new FlxSprite(FlxG.width / 2 - 32, 8, AssetPaths.livesHUD__png);
		livesSprite.scrollFactor.set(0, 0);
		add(livesSprite);
	}
	
	private function ammoSetUp():Void 
	{
		ammo = new FlxText(FlxG.width / 2 + 16, 8, 0, "10", 11, true);
		ammo.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		ammo.scrollFactor.set(0, 0);
		add(ammo);
		
		ammoSprite = new FlxSprite(FlxG.width / 2, 8, AssetPaths.weaponsHUD__png);
		ammoSprite.loadGraphic(AssetPaths.weaponsHUD__png, true, 16, 16);
		ammoSprite.animation.add("noWeapon", [0], 12, false);
		ammoSprite.animation.add("spear", [1], 12, false);
		ammoSprite.animation.add("shuriken", [2], 12, false);
		ammoSprite.animation.add("poison", [3], 12, false);
		ammoSprite.scrollFactor.set(0, 0);
		add(ammoSprite);
	}
	
	private function scoreSetUp():Void 
	{
		score = new FlxText(FlxG.width - 80, 8, 0, "Score: 0", 11, true);
		score.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		score.scrollFactor.set(0, 0);
		add(score);
	}
	
	private function pauseSetUp():Void 
	{	
		pause = new FlxText(0, FlxG.height / 2, FlxG.width, "Paused", 14, true);
		pause.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		pause.alignment = FlxTextAlign.CENTER;
		pause.scrollFactor.set(0, 0);
		pause.visible = false;
		add(pause);
	}
	
	private function playerHealthBarSetUp(player:Player):Void
	{
		playerHealth = new FlxBar(10, 10, FlxBarFillDirection.LEFT_TO_RIGHT, 68, 12, player, "hp", 0, 100, true);
		playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
	}
	
	private function bossHealthBarSetUp(boss:Boss):Void
	{
		bossHealth = new FlxBar(10, FlxG.height - 22, FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, 68, 12, boss, "healthBoss", 0, 100, true);
		bossHealth.scrollFactor.set(0, 0);
		//bossHealth.visible = false;
		add(bossHealth);
	}
}