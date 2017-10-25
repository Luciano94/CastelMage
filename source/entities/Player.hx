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
	ATTACK;
	DEAD;
	DOORTRIGGER;
}
class Player extends FlxSprite
{
	private var currentState:States;
	private var speed:Int;
	private var speedYJump:Int;
	private var attackBox:Box;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		currentState = States.MOVING;  // Current State of Player
		speed = Reg.playerNormalSpeed;  // The speed that will be given to velocity.x of the player
		speedYJump = Reg.playerJumpSpeed; // Speed when Player jumps

		attackBox = new Box(x + width, y + height / 3, 30, 12);
		attackBox.kill();
		FlxG.state.add(attackBox);

		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		loadGraphic(AssetPaths.player__png, true, 40, 48);
		animation.add("idle", [0]);	// Temporary Animations (WORK IN PROGRESS)
		animation.add("move", [1, 2, 3], 6, true);
		animation.add("jump", [4, 5], 7, false);
		animation.add("attack", [2, 2, 3], 9, false);
		//animation.add("death", [3]);

		acceleration.y = Reg.gravity;
		currentState = States.IDLE;
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
				if (velocity.x != 0)
					currentState = States.MOVING;
				if (velocity.y != 0)
				{
					animation.play("jump");
					currentState = States.JUMPING;
				}
			case States.MOVING:
				animation.play("move");
				moveHor();
				jump();
				attack();

				if (velocity.x == 0)
					currentState = States.IDLE;
				if (velocity.y != 0)
				{
					animation.play("jump");
					currentState = States.JUMPING;
				}
			case States.JUMPING:
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
			case States.ATTACK:
				if (isTouching(FlxObject.FLOOR))
					velocity.x = 0;
				if (animation.name == "attack" && animation.finished)
				{
					attackBox.kill();
					if (!isTouching(FlxObject.FLOOR))
					{
						animation.play("jump");
						currentState = States.JUMPING;
					}
					else if (velocity.x != 0)
						currentState = States.MOVING;
					else
						currentState = States.IDLE;
				}
				if (animation.name == "attack" && animation.curAnim.curFrame == 2 && !animation.finished)
				{
					if (facing == FlxObject.RIGHT)
						attackBox.reset(x + width, y + height / 3);
					else
						attackBox.reset(x - 30, y + height / 3);
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
			velocity.x = speed;
			facing = FlxObject.RIGHT;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x = -speed;
			facing = FlxObject.LEFT;
		}
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
			if (velocity.x == 0)
				velocity.x = 0;
			else if (!isTouching(FlxObject.FLOOR) && speed != 0)
			{
				if(facing == FlxObject.RIGHT)
					velocity.x = speed;
				else
					velocity.x = -speed;
			}
		}
	}
}