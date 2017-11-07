package entities.enemies;

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
		loadGraphic(AssetPaths.armoredEnemy__png, true, 32, 26);
		scale.set(2, 2);
		updateHitbox();
		animation.add("idle", [0], false);
		animation.add("move", [0, 1, 2, 3], 12, true);
		animation.add("atk", [4], false);
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
		switch (currentState) 
		{
			case State.IDLE:
				animation.play("idle");
				tracking();
			case State.MOVING:
				animation.play("move");
				mov();
			case State.PREATTACKING:
				animation.play("idle");
				preatk();
			case State.ATTACKING:
				animation.play("atk");
				atk();
			default:
				
		}
		checkInmortality(elapsed);
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
				if(player.x - x > Reg.atkDist)
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
		if (timeAttack < Reg.preAtkTime) timeAttack ++;
		else
		{
			currentState = State.ATTACKING;
			timeAttack = 0;
		}
	}
	
	private function atk():Void
	{
		if (timeAttack < Reg.atkTime) timeAttack ++;
		else
		{
			currentState = State.IDLE;
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
	
	//public function getDamage()
	//{
		//if (lifePoints > 0)
			//lifePoints --;
		//else
			//kill();
	//}
	
	public function getDamage(damage:Int):Void
	{
		if (!hasJustBeenHit)
		{
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
		if (inmortalityTime >= 1)
			hasJustBeenHit = false;
	}
	
	public function getState():State
	{
		return currentState;
	}
}