package entities;

import entities.weapons.WeaponShuriken;
import entities.weapons.WeaponNormal;
import entities.weapons.WeaponSpear;
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
enum WeaponStates
{
	SINWEA;
	WEASPEAR;
	WEASHURIKEN;
	WEA3;
}
class Player extends FlxSprite
{
	private var currentState:States;
	private var weaponCurrentState:WeaponStates;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var weaponN:WeaponNormal;
	private var weaponSpear:WeaponSpear;
	private var weaponBoome:WeaponShuriken;
	private var hp:Int;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		// Variables Inicialization
		currentState = States.IDLE;
		weaponCurrentState = WeaponStates.WEASHURIKEN;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		acceleration.y = Reg.gravity;
		health = 100;
		// Weapons Creation
		weaponN = new WeaponNormal(x + width, y + height / 3);
		weaponN.kill();
		weaponSpear = new WeaponSpear(x + width / 2, y + height / 3);
		weaponSpear.kill();
		weaponBoome = new WeaponShuriken(x + width / 2, y + height / 3);
		weaponBoome.kill();
		FlxG.state.add(weaponN);
		FlxG.state.add(weaponSpear);
		FlxG.state.add(weaponBoome);
		// Player Facings
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		// Animations
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
				crouch();
				if (velocity.x != 0)
					currentState = States.MOVING;
				if (velocity.y != 0)
					currentState = States.JUMPING;
				attack(); // This goes here to correct a bug
				
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
				if (!isTouching(FlxObject.FLOOR) && velocity.x != 0)
					if(facing == FlxObject.RIGHT)
						velocity.x = speed;
					else
						velocity.x = -speed;
				else
					velocity.x = 0;
				weaponN.velocity.x = velocity.x;
				weaponN.velocity.y = velocity.y;
				if (animation.name == "attack" && animation.finished)
				{
					weaponN.kill();
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
				attack();
				jump();
				if (FlxG.keys.justReleased.DOWN)
					currentState = States.IDLE;
				
			case States.DEAD:
				
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
			velocity.y += jumpSpeed;
			animation.play("jump");
		}
	}
	private function attack():Void
	{
		if (FlxG.keys.justPressed.A)
		{
			WeaponBase.pFacing = facing;
			currentState = States.ATTACKING;
			animation.play("attack");
			if (facing == FlxObject.RIGHT)
				if (!FlxG.keys.pressed.UP)
					weaponN.reset(x + width, y + height / 3 - 4);
				else
				{
					switch (weaponCurrentState) 
					{
						case WeaponStates.SINWEA:
							// Tengo pensado en que aparezca un mensaje diciendo que no tiene arma
						case WeaponStates.WEASPEAR:
							weaponSpear.reset(x + width / 2, y + height / 3 - 4);
						case WeaponStates.WEASHURIKEN:
							weaponBoome.reset(x + width * 4 / 5, y + height / 4);
						case WeaponStates.WEA3:
							
					}
				}
			else
				if (!FlxG.keys.pressed.UP)
						weaponN.reset(x - 30, y + height / 3 - 4);
					else
					{
						switch (weaponCurrentState) 
						{
							case WeaponStates.SINWEA:
								// Tengo pensado en que aparezca un mensaje diciendo que no tiene arma
							case WeaponStates.WEASPEAR:
								weaponSpear.reset(x - width / 2, y + height / 3 - 4);
							case WeaponStates.WEASHURIKEN:
								weaponBoome.reset(x - weaponBoome.width * 4 / 5, y + height / 4);
							case WeaponStates.WEA3:
								
						}
					}
		}
	}
	private function crouch():Void
	{
		if (FlxG.keys.pressed.DOWN)
			currentState = States.CROUCHED;
	}
}