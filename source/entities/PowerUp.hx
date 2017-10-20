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
    loadGraphic(AssetPaths.bichi__png, true, 11, 9);
    animation.add("health1", [0]); // When the Health appears on the air
    animation.add("health2", [1]); // When the Health appears on the floor
    animation.add("weapon", [2]); // the mount of weapon will be defined later
    animation.add("ammu", [3]); // Ammunition
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