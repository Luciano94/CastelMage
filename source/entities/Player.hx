package entities;

import flash.display.Shape;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

enum States
{
	IDLE;
	MOVING;
	JUMPING;
	ATTACKING;
	CROUCHED;
	DEAD;
}
class Player extends FlxSprite
{
	private var currentState:States;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var attackBox:Box;
	private var hp:Int;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		currentState = States.IDLE;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		acceleration.y = Reg.gravity;
		health = 100;

		attackBox = new Box(x + width, y + height / 3, 30, 12);
		attackBox.kill();
		FlxG.state.add(attackBox);

		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		loadGraphic(AssetPaths.player__png, true, 32, 48);
		animation.add("idle", [0, 1], 6, true);
		animation.add("move", [2, 3, 4], 6, true);
		animation.add("jump", [5, 6], 6, false);
		animation.add("attack", [8, 9, 0], 9, false);
		animation.add("crouch", [10], false);
	}
	override public function update(elapsed:Float):Void
	{
		stateMachine();
		super.update(elapsed);
	}

	private function stateMachine():Void
	{
		switch (currentState)
		{
			case States.IDLE:
				animation.play("idle");
				
				moveHor();
				jump();
				attack();
				crouch();
				if (velocity.x != 0)
					currentState = States.MOVING;
				if (velocity.y != 0)
					currentState = States.JUMPING;
					
			case States.MOVING:
				animation.play("move");
				
				moveHor();
				jump();
				attack();
				
				if (velocity.x == 0)
					currentState = States.IDLE;
				if (velocity.y != 0)
					currentState = States.JUMPING;
					
			case States.JUMPING:
				if (animation.name != "jump")
					animation.play("jump");
				
				if (velocity.x == 0)
					velocity.x = 0;
				else if (velocity.x > 0)
					velocity.x = speed;
				else
					velocity.x = -speed;
					
				attack();

				if (velocity.y == 0 && isTouching(FlxObject.FLOOR))
				{
					if (velocity.x == 0)
						currentState = States.IDLE;
					else
						currentState = States.MOVING;
				}
				
			case States.ATTACKING:
				if (animation.name != "attack")
					animation.play("attack");
				if (facing == FlxObject.RIGHT)
					attackBox.reset(x + width, y + height / 3);
				else
					attackBox.reset(x - 30, y + height / 3);
				
				if (animation.name == "attack" && animation.finished)
				{
					attackBox.kill();
					if (!isTouching(FlxObject.FLOOR))
						currentState = States.JUMPING;
					else
					{
						if (velocity.x != 0)
							currentState = States.MOVING;
						else
							currentState = States.IDLE;
					}

				}
				
			case States.CROUCHED:
				animation.play("crouch");
				
				if (velocity.y != 0)
					currentState = States.JUMPING;
				else
				{
					if (facing == FlxObject.RIGHT)
						attackBox.reset(x + width, y + height / 3);
					else
						if (FlxG.keys.justReleased.DOWN)
							currentState = States.IDLE;
				}
			case States.DEAD:
				
			case States.DOORTRIGGER:
				
		}
	}
	private function moveHor():Void
	{
		velocity.x = 0;

	if (FlxG.keys.pressed.RIGHT)
	{
		speed = Reg.playerNormalSpeed;
		facing = FlxObject.RIGHT;
	}
	if (FlxG.keys.pressed.LEFT)
	{
		speed = -Reg.playerNormalSpeed;
		facing = FlxObject.LEFT;
	}
	velocity.x = speed;
}

private function jump():Void
{
	if (FlxG.keys.justPressed.S)
	{
		velocity.y += speedYJump;
		animation.play("jump");
	}
}

private function attack():Void
{
	if (FlxG.keys.justPressed.A)
	{
		animation.play("attack");
		currentState = States.ATTACK;
		if (!isTouching(FlxObject.FLOOR) && speed != 0)
			velocity.x = speed;
	}
}