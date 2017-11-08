package entities.enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

enum State
{
	IDLE;
	ATTACKING;
	PREATTACKING;
	MOVING;
}
class ArmoredEnemy extends FlxSprite 
{
	private var currentState:State;
	private var gotcha: Bool;
	private var player: Player;
	private var speed: Int;
	private var gravity: Int;
	private var timeAttack: Int;
	private var hp: Int;
	private var hasJustBeenHit:Bool;
	private var inmortalityTime:Float;

	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		/*animations*/
		loadGraphic(AssetPaths.armoredEnemy__png, true, 64, 64);
		updateHitbox();
		animation.add("idle", [0], 6, false);
		animation.add("move", [0, 1, 2, 3], 12, true);
		animation.add("atk", [4], 6, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		/*set var*/
		timeAttack = 0;
		currentState = State.IDLE;
		player = _player;
		speed = Reg.speedEnemy;
		gravity = Reg.gravity;
		acceleration.y = gravity;
		hp = Reg.armoredEnemyLifePoints;
		hasJustBeenHit = false;
		inmortalityTime = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		animControl();
		hitboxControl();
		switch (currentState) 
		{
			case State.IDLE:
				animation.play("idle");
				decreaseHitBox();
				tracking();
			case State.MOVING:
				animation.play("move");
				mov();
			case State.PREATTACKING:
				animation.play("idle");
				preatk();
			case State.ATTACKING:
				animation.play("atk");
				velocity.x = 0;
				increaseHitBox();
				atk();
		}
		checkInmortality(elapsed);
	}
	
	private function hitboxControl():Void
	{
		if (currentState == State.ATTACKING)
			updateHitbox();
		else
		{
			width = 32;
			if(x >= player.x)
				offset.x = 10;
			else
				offset.x = -10;
		}
	}
	
	private function tracking():Void
	{
		if (gotcha)
			currentState = State.MOVING;
		else
		{
			if ((x > player.x) && (x - player.x < Reg.trackDist))
			{
				gotcha = true;
				currentState = State.MOVING;
			}
			if ((x < player.x) && (player.x - x < Reg.trackDist))
			{
				gotcha = true;
				currentState = State.MOVING;
			}
		}
	}
	
	private function mov():Void
	{
		if (x > player.x)
		{
			if (x - player.x > Reg.atkDist)
				velocity.x =  -speed;
			if (x - player.x <= Reg.atkDist)
			{
				velocity.set(0, 0);
				currentState = State.PREATTACKING;
			}
		}
		else
			if (x < player.x)
			{
				if (player.x - x > Reg.atkDist)
					velocity.x =  speed;
				if (player.x  - x <= Reg.atkDist)
				{
					velocity.set(0, 0);
					currentState = State.PREATTACKING;
				}
			}
	}
	
	private function preatk():Void
	{
		if (timeAttack < Reg.preAtkTime)
			timeAttack++;
		else
		{
			currentState = State.ATTACKING;
			if(x >= player.x)
				x -= 10;
			else
				x += 10;
			timeAttack = 0;
		}
	}
	
	private function atk():Void
	{
		if (timeAttack < Reg.atkTime) 
			timeAttack++;
		else
		{
			currentState = State.IDLE;
			if(x >= player.x)
				x += 10;
			else
				x -= 10;
			timeAttack = 0;
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
				if (player.x < x)
					x += 32;
				else
					x -= 32;
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
	
	private function increaseHitBox():Void 
	{
		if (width == 32)
		{
			width = 64;
			updateHitbox();
			if (facing == FlxObject.LEFT)
				x -= 32;
			else
				x += 32;
		}
	}
	
	private function decreaseHitBox():Void 
	{
		if (width == 64)
		{
			if (facing == FlxObject.LEFT)
				offset.x = 32;
			else
				offset.x = -32;
			width = 32;
		}
	}
	
	public function getState():State
	{
		return currentState;
	}
}