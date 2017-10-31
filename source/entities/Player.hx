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
	WEAPOTION;
}
class Player extends FlxSprite
{
	private var currentState:States;
	public var weaponCurrentState(get, null):WeaponStates;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var weaponN:WeaponNormal;
	private var weaponSpear:WeaponSpear;
	private var weaponShuriken:WeaponShuriken;
	private var weaponPotion:WeaponPotion;
	private var hp:Int;
	public var lives(get, null):Int;
	public var ammo(get, null):Int;
	//public var isNextToStairs(null, set):Bool;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		// Attributes Inicialization
		currentState = States.IDLE;
		weaponCurrentState = WeaponStates.WEAPOTION;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		acceleration.y = Reg.gravity;
		hp = Reg.playerMaxHealth;
		lives = Reg.playerMaxLives;
		ammo = 10;

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
				//takeStairs();
				if (velocity.x != 0)
					currentState = States.MOVING;
				if (velocity.y != 0)
					currentState = States.JUMPING;
				if (weaponN.alive)
					currentState = States.ATTACKING;

			case States.MOVING:
				animation.play("move");

				moveHor();
				jump();
				attack();
				//takeStairs();

				if (velocity.x == 0)
					currentState = States.IDLE;
				if (velocity.y != 0)
					currentState = States.JUMPING;
				if (weaponN.alive)
					currentState = States.ATTACKING;

			case States.JUMPING:
				if (animation.name != "jump")
					animation.play("jump");

				attack();

				if (velocity.y == 0)
				{
					if (velocity.x == 0)
						currentState = States.IDLE;
					else
						currentState = States.MOVING;
				}
				if (weaponN.alive)
					currentState = States.ATTACKING;

			case States.ATTACKING:
				if (animation.name != "attack")
					animation.play("attack");

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

				if (animation.name == "attack" && animation.finished)
				{
					weaponN.kill();
					if (velocity.y != 0)
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
				if (FlxG.keys.justReleased.DOWN)
					currentState = States.IDLE;
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
			currentState = States.ATTACKING;
			
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
					// Tengo pensado en que aparezca un mensaje diciendo que no tiene arma
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
		if (FlxG.keys.pressed.DOWN)
		{
			currentState = States.CROUCHED;
		}
	}
	
	private function takeStairs():Void
	{
		if (isNextToStairs)
		{
			if (FlxG.keys.pressed.UP)
				velocity.set(16, 16);
			if (FlxG.keys.pressed.DOWN)
				velocity.set( -16, -16);
				
		}
	}
	
	private function checkAmmo():Void
	{
		if (ammo == 0)
			weaponCurrentState = WeaponStates.SINWEA;
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
	
	//function set_isNextToStairs(value:Bool):Bool 
	//{
		//return isNextToStairs = value;
	//}
}