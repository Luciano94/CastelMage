package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class PowerUp extends FlxSprite 
{
	public var whichPowerUp(get, null):Int;
  
	public function new(?X:Float=0, ?Y:Float=0, WhichPowerUp:Int) 
	{
		super(X, Y);
	
		whichPowerUp = WhichPowerUp;
		loadGraphic(AssetPaths.powerUps__png, true, 16, 16);
		animation.add("health", [0]);
		animation.add("life", [1]);
		animation.add("spear", [2]);
		animation.add("shuriken", [3]);
		animation.add("poison", [4]);
		animation.add("ammo", [5]);
		animation.add("score", [6]);
		switch (whichPowerUp) 
		{
			case 0:
				animation.play("health");
			case 1:
				animation.play("life");
			case 2:
				animation.play("spear");
			case 3:
				animation.play("shuriken");
			case 4:
				animation.play("poison");
			case 5:
				animation.play("ammo");
			case 6:
				animation.play("score");
		}
	}
	
	public function get_whichPowerUp():Int 
	{
		return whichPowerUp;
	}
}