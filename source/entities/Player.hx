package entities;

import entities.weapons.WeaponPotion;
import entities.weapons.WeaponShuriken;
import entities.weapons.WeaponNormal;
import entities.weapons.WeaponSpear;
import flash.display.Shape;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;

enum States
{
	IDLE;
	MOVING;
	JUMPING;
	ATTACKING;
	CROUCHED;
	CLIMBING_LADDERS;
	DEAD;
}
enum WeaponStates
{
	SINWEA;
	WEASPEAR;
	WEASHURIKEN;
	WEAPOTION;
}
class Player extends FlxSprite
{
	public var currentState(get, null):States;
	public var weaponCurrentState(get, null):WeaponStates;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var stairsSpeed:Int;
	private var weaponN:WeaponNormal;
	private var weaponSpear:WeaponSpear;
	private var weaponShuriken:WeaponShuriken;
	private var weaponPotion:WeaponPotion;
	private var hp:Int;
	public var lives(get, null):Int;
	public var ammo(get, null):Int;
	public var isTouchingLadder(null, set):Bool;
	public var isOnTopOfLadder(null, set):Bool;
	private var inmort:Int;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		// Attributes Inicialization
		currentState = States.IDLE;
		weaponCurrentState = WeaponStates.WEAPOTION;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		stairsSpeed = Reg.playerStairsSpeed;
		acceleration.y = Reg.gravity;
		hp = Reg.playerMaxHealth;
		lives = Reg.playerMaxLives;
		isTouchingLadder = false;
		isOnTopOfLadder = false;
		ammo = 10;
		inmort = 0;

		// Weapons Creation
		weaponN = new WeaponNormal(x + width, y + height / 3);
		weaponN.kill();
		weaponSpear = new WeaponSpear(x + width / 2, y + height / 3);
		weaponSpear.kill();
		weaponShuriken = new WeaponShuriken(x + width / 2, y + height / 3);
		weaponShuriken.kill();
		weaponPotion = new WeaponPotion(x + width, y + height / 3);
		weaponPotion.kill();
		FlxG.state.add(weaponN);
		FlxG.state.add(weaponSpear);
		FlxG.state.add(weaponShuriken);
		FlxG.state.add(weaponPotion);

		// Player Facings
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		// Animations
		loadGraphic(AssetPaths.player__png, true, 32, 48);
		animation.add("idle", [0, 1], 6, true);
		animation.add("move", [2, 3, 4], 6, true);
		animation.add("jump", [5, 6], 9, false);
		animation.add("attack", [7, 8, 0], 9, false);
		animation.add("crouch", [9], false);
		animation.add("crouchAttack", [10, 11], 9, false);
		animation.add("climbLadders", [12, 13], 6, false);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		stateMachine();
		checkAmmo();
		
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
				climbLadders();
				
				if (velocity.x != 0)
					currentState = States.MOVING;
				else
				{
					if (velocity.y != 0 && !weaponN.alive && acceleration.y != 0 && !isTouching(FlxObject.FLOOR))
						currentState = States.JUMPING;
					else
					{
						if (weaponN.alive)
							currentState = States.ATTACKING;
						else
						{
							if (height == 36)
								currentState = States.CROUCHED;
							else
								if (acceleration.y == 0)
									currentState = States.CLIMBING_LADDERS;
						}
						
					}
					
				}

			case States.MOVING:
				animation.play("move");

				moveHor();
				jump();
				attack();

				if (velocity.x == 0)
					currentState = States.IDLE;
				else
				{
					if (velocity.y != 0 && !weaponN.alive  && !isTouching(FlxObject.FLOOR))
						currentState = States.JUMPING;
					else
						if (weaponN.alive)
							currentState = States.ATTACKING;
				}
						
			case States.JUMPING:
				if (animation.name != "jump")
					animation.play("jump");

				attack();

				if (velocity.y == 0 || velocity.y == Reg.elevatorSpeed || velocity.y == -Reg.elevatorSpeed)
				{
					if (velocity.x == 0)
						currentState = States.IDLE;
					else
						currentState = States.MOVING;
				}
				else
					if (weaponN.alive)
						currentState = States.ATTACKING;

			case States.ATTACKING:
				if (height == 48)
				{
					if (animation.name != "attack")
						animation.play("attack");
				}
				else
					if (animation.name != "crouchAttack")
						animation.play("crouchAttack");

				if (velocity.y != 0 && velocity.x != 0)
				{
					if (facing == FlxObject.RIGHT)
						velocity.x = speed;
					else
						velocity.x = -speed;
				}
				else
					velocity.x = 0;

				weaponN.velocity.x = velocity.x;
				weaponN.velocity.y = velocity.y;

				if ((animation.name == "attack" || animation.name == "crouchAttack") && animation.finished)
				{
					weaponN.kill();
					if (velocity.y != 0)
						currentState = States.JUMPING;
					else
					{
						if (velocity.x != 0)
							currentState = States.MOVING;
						else
						{
							if (height == 36)
								currentState = States.CROUCHED;
							else
								currentState = States.IDLE;
						}
					}
				}
				
			case States.CLIMBING_LADDERS:
				if (velocity.y != 0)
					animation.play("climbLadders");
				
				velocity.set(0, 0);
				climbLadders();
				if (!isTouchingLadder || isTouching(FlxObject.FLOOR))
				{
					acceleration.y = Reg.gravity;
					currentState = States.IDLE;
				}
				
			case States.CROUCHED:
				animation.play("crouch");
				
				attack();
				if (!FlxG.keys.pressed.DOWN)
				{
					height = 48;
					y -= 12;
					updateHitbox();
					currentState = States.IDLE;
				}
				else
					if (weaponN.alive)
						currentState = States.ATTACKING;

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
		}
	}
	private function attack():Void
	{
		if (FlxG.keys.justPressed.A)
		{			
			if (!weaponSpear.alive && !weaponShuriken.alive)
				WeaponBase.pFacing = facing;
			if (!FlxG.keys.pressed.UP)
			{
				if (facing == FlxObject.RIGHT)
					weaponN.reset(x + width, y + height / 3 - 4);
				else
					weaponN.reset(x - width, y + height / 3 - 4);
			}
			else
			{
				switch (weaponCurrentState)
				{
					case WeaponStates.SINWEA:

					case WeaponStates.WEASPEAR:
						if (!weaponSpear.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponSpear.reset(x + width / 2, y + height / 3 - 4);
							else
								weaponSpear.reset(x - width / 2, y + height / 3 - 4);
							
							ammo--;
						}
					case WeaponStates.WEASHURIKEN:
						if (!weaponShuriken.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponShuriken.reset(x + width * 4 / 5, y + height / 4);
							else
								weaponShuriken.reset(x - width * 4 / 5, y + height / 4);
							
							ammo--;
						}
					case WeaponStates.WEAPOTION:
						if (!weaponPotion.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponPotion.reset(x + width - weaponPotion.width / 2, y + height / 3);
							else
								weaponPotion.reset(x - weaponPotion.width / 2, y + height / 3);
							
							ammo--;
						}
				}
			}
		}
	}
	private function crouch():Void
	{
		if (FlxG.keys.pressed.DOWN && !isTouchingLadder)
		{	
			offset.y = 12;
			height = 36;
		}
	}
	
	private function climbLadders():Void
	{
		if (isTouchingLadder)
		{
			if (FlxG.keys.pressed.UP && !isOnTopOfLadder)
			{
				acceleration.y = 0;
				velocity.y = -stairsSpeed;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				acceleration.y = 0;
				velocity.y = stairsSpeed;
			}
		}
	}
	
	private function checkAmmo():Void
	{
		if (ammo == 0)
			weaponCurrentState = WeaponStates.SINWEA;
	}
	
	public function getWeaponN():WeaponBase
	{
		switch (weaponCurrentState) 
		{
			case WeaponStates.SINWEA:
				return null;
			case WeaponStates.WEAPOTION:
				return weaponPotion;
			case WeaponStates.WEASHURIKEN:
				return weaponShuriken;
			case WeaponStates.WEASPEAR:
				return weaponSpear;
		}
	}
	
	public function getMainWeapon():WeaponBase
	{
		return weaponN;
	}
	
	public function getDamage()
	{
		FlxFlicker.flicker(this, 3, 0.08, true, true);
		if (lives > 0) 
			lives--;
		else 
			kill();
	}
	
	function get_lives():Int 
	{
		return lives;
	}
	
	function get_ammo():Int 
	{
		return ammo;
	}
	
	function get_weaponCurrentState():WeaponStates 
	{
		return weaponCurrentState;
	}
	
	function set_isTouchingLadder(value:Bool):Bool 
	{
		return isTouchingLadder = value;
	}
	
	function get_currentState():States 
	{
		return currentState;
	}
	
	function set_isOnTopOfLadder(value:Bool):Bool 
	{
		return isOnTopOfLadder = value;
	}
}