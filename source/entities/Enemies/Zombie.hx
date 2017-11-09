package entities.enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

class Zombie extends FlxSprite 
{
	private var speed:Int;
	private var hp:Int;
	private var player:Player;
	private var gravity:Int;
	private var catche:Bool;
	private var hasJustBeenHit:Bool;
	private var inmortalityTime:Float;
	public var hasJustAttacked(null, set):Bool;
	public var recoveryTime(null, set):Float;

	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Zombie__png, true, 32, 51);
		animation.add("idle", [0], 6, false);
		animation.add("move", [1, 2, 3, 4, 5, 6, 7], 12, true);
		player = _player;
		catche = false;
		speed = Reg.speedEnemy;
		hp = Reg.zombieLifePoints;
		gravity = Reg.gravity;
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		acceleration.y = gravity;
		hasJustBeenHit = false;
		inmortalityTime = 0;
		hasJustAttacked = false;
		recoveryTime = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		animControl();
		if (!hasJustBeenHit && !hasJustAttacked)
			taiCorro();
		checkInmortality(elapsed);
		checkRecovery(elapsed);
	}
	
	override public function kill():Void
	{
		super.kill();
		Reg.score += 5;
	}
	
	private function taiCorro():Void
	{
		if ((x > player.x) && (x - player.x < Reg.trackDist))
		{
			velocity.set( -speed, 0);
			animation.play("move");
			catche = true;
		}
		if ((x < player.x) && (player.x - x < Reg.trackDist))
		{
			velocity.set(speed, 0);
			animation.play("move");
			catche = true;
		}
		if (catche)
		{
			if (((x > player.x + 1) || (x > player.x - 1)) && 
				((x < player.x + 1) || (x < player.x - 1)))
				animation.play("idle");
			if ((x > player.x + 1) || (x > player.x - 1))
				if(velocity.x >=0)
					velocity.x -= speed;
			if ((x < player.x + 1) || (x < player.x - 1))
				if(velocity.x <= 0)
					velocity.x += speed;
		}
	}
	
	private function animControl():Void
	{
		if (x >= player.x)
			facing = FlxObject.LEFT;
		else
			facing = FlxObject.RIGHT;
	}
	
	public function getDamage(damage:Int):Void
	{
		if (!hasJustBeenHit)
		{
			FlxG.sound.play(AssetPaths.enemyDamaged__wav);
			hp -= damage;
			if (hp <= 0)
				kill();
			else
			{
				hasJustBeenHit = true;
				inmortalityTime = 0;
				velocity.set(0, 0);
				animation.play("idle");
			}
		}
	}
	
	private function checkInmortality(elapsed:Float):Void 
	{
		if (hasJustBeenHit)
			inmortalityTime += elapsed;
		if (inmortalityTime >= 0.5)
			hasJustBeenHit = false;
	}
	
	private function checkRecovery(elapsed:Float):Void
	{
		if (hasJustAttacked)
		{
			animation.play("idle");
			recoveryTime += elapsed;
		}
		if (recoveryTime >= 1)
			hasJustAttacked = false;
	}
	
	function set_hasJustAttacked(value:Bool):Bool 
	{
		return hasJustAttacked = value;
	}
	
	function set_recoveryTime(value:Float):Float 
	{
		return recoveryTime = value;
	}
}