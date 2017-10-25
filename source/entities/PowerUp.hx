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
    loadGraphic(AssetPaths.player__png, true, 11, 9);
    animation.add("health1", [0]);
    animation.add("weapon1", [1]);
	animation.add("weapon2", [2]);
	animation.add("weapon3", [3]);
    animation.add("ammu1", [4]);
	animation.add("ammu2", [5]);
	animation.add("ammu3", [6]);
    switch (whichPowerUp) 
    {
		case 0:
			animation.play("health1");
		case 1:
			animation.play("weapon1");
		case 2:
			animation.play("weapon2");
		case 3:
			animation.play("weapon3");
		case 4:
			animation.play("ammu1");
		case 5:
			animation.play("ammu2");
		case 6:
			animation.play("ammu3");
    }
  }
  public function get_whichPowerUp():Int 
  {
    return whichPowerUp;
  }
}