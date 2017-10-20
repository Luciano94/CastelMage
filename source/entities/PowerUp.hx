package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Aleman5
 */
class PowerUp extends FlxSprite 
{
  public var whichPowerUp(get, null):Int;
  
  public function new(?X:Float=0, ?Y:Float=0, WhichPowerUp:Int) 
  {
    super(X, Y);
    whichPowerUp = WhichPowerUp;
    loadGraphic(AssetPaths.player__png, true, 11, 9);
    animation.add("health1", [0]);
    animation.add("weapon1", [2]);
	animation.add("weapon2", [3]);
	animation.add("weapon3", [4]);
    animation.add("ammu1", [5]);
	animation.add("ammu2", [6]);
	animation.add("ammu3", [7]);
    switch (whichPowerUp) 
    {
      case 0:
        animation.play("health1");
      case 1:
        animation.play("health2");
      case 2:
        animation.play("weapon");
      case 3:
        animation.play("ammu");
    }
    scale.set(2, 2); // Temporary
    updateHitbox();  //
  }
  public function get_whichPowerUp():Int 
  {
    return whichPowerUp;
  }
}