package entities.weapons;

import entities.WeaponBase;
import flixel.FlxObject;

enum States
{ 
	FLYING; 
	DYING;	
}

class WeaponPotion extends WeaponBase 
{
	private var currentState:States;
	private var speed:Int;
	public var isItTouching(default, set):Bool;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		acceleration.y = Reg.gravity;
		loadGraphic(AssetPaths.weaponPotion__png, true, 33, 10);
		animation.add("flying", [0]);
		animation.add("dying", [1, 2, 3, 4], 8, false);
		currentState = States.FLYING;
		speed = Reg.weaponPotNormalSpeed;
		isItTouching = false;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		switch (currentState) 
		{
			case States.FLYING:
				
				if (isItTouching || !inWorldBounds())
				{
					velocity.y = 0;
					velocity.x = 0;
					acceleration.y = 0;
					animation.play("dying");
					currentState = States.DYING;
				}
			case States.DYING:
				if (animation.name == "dying" && animation.finished)
					kill();
		}
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		velocity.y = Reg.weaponPotYSpeed;
		acceleration.y = Reg.gravity;
		animation.play("flying");
		currentState = States.FLYING;
		isItTouching = false;
		
		if (facing == FlxObject.RIGHT)
			velocity.x = speed;
		else
			velocity.x = -speed;
	}
	
	public function set_isItTouching(value:Bool):Bool 
	{
		return isItTouching = value;
	}
}