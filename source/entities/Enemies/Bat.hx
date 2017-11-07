package entities.enemies;

import flixel.FlxSprite;
import flixel.FlxG;
import entities.Player.States;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

enum BatState
{
	IDLE;
	ATTACKING;
	MOVING;
	HIDING;
}
class Bat extends FlxSprite 
{
	private var speed:Int;
	private var player: Player;
	private var timeAttack:Int;
	private var gotcha:Bool;
	private var currentState:BatState;
	
	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.bat__png, true, 16, 48);
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 30, true);
		animation.play("idle");
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		height = 16;
		offset.y += 20;
		speed = Reg.speedEnemy;
		velocity.set(speed, speed);
		gotcha = false;
		player = _player;
		timeAttack = 0;
		currentState = BatState.IDLE;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		switch (currentState) 
		{
			case BatState.IDLE:
				tracking();
			case BatState.MOVING:
				mov();
			case BatState.ATTACKING:
				atk();
			case BatState.HIDING:
				hid();
		}
		animControl();
		infinite();
	}
	
	private function tracking():Void
	{
		if (timeAttack < Reg.atkTime) timeAttack ++;
		else
		{
			timeAttack = 0;	
			if (((x > player.x) && (x - player.x < Reg.trackDist)) && 
				((y > player.y)&&( y - player.y < Reg.trackDist / 2)))
			{
				gotcha = true;
				currentState = BatState.MOVING;
			}
			if (((x < player.x) && (player.x - x < Reg.trackDist)) && 
				((y < player.y)&&( player.y - y < Reg.trackDist / 2)))
			{
				gotcha = true;
				currentState = BatState.MOVING;
			}
		}
	}
	
	private function mov():Void
	{
		if (FlxG.overlap(this, player))
		{
			if (velocity.x > 0)
				velocity.x = -speed;
			else if(velocity.x < 0)
				velocity.x = speed;
			if (velocity.y > 0)
				velocity.y = -speed;
			else if (velocity.y < 0)
				velocity.y = speed;
		}
		if (x > player.x)
		{
			if (x - player.x > Reg.batAtkDist)
				velocity.x =  -speed;
			if (x - player.x <= Reg.batAtkDist)
			{
				velocity.set(0, 0);
				currentState = BatState.ATTACKING;
			}
		}
		else
		if (x < player.x)
		{
			if(player.x - x > Reg.batAtkDist)
				velocity.x =  speed;
			if (player.x  - x <= Reg.batAtkDist)
			{
				velocity.set(0, 0);
				currentState = BatState.ATTACKING;
			}
		}
	}
	
	private function atk():Void
	{
		if (x > player.x)
		{
			if(x - player.x > player.x + 1)
				velocity.x =  -speed;
			if (x - player.x <= player.x + 1)
			{
				velocity.set(0, 0);
				currentState = BatState.HIDING;
			}
		}
		else
		if (x < player.x)
		{
			if(player.x - x > player.x - 1)
				velocity.x =  speed;
			if (player.x  - x <= player.x - 1)
			{
				velocity.set(0, 0);
				currentState = BatState.HIDING;
			}
		}
	}
	
	private function hid():Void
	{
		if (x > player.x)
		{
			if (x - player.x < Reg.trackDist + 10)
				velocity.set(speed, speed);
			if (x - player.x >= Reg.trackDist + 10)
				currentState = BatState.IDLE;
		}
		else
		if (x < player.x)
		{
			if (player.x - x < Reg.trackDist + 4)
				velocity.set(-speed, -speed);
			if (player.x - x >= Reg.trackDist + 4)
				currentState = BatState.IDLE;
		}
	}
	
	private function infinite():Void
	{
		if ((x > camera.scroll.x + FlxG.width - width) && (velocity.x >= 0))
		{
			velocity.x -= speed;
			if(velocity.y == 0)
				velocity.y -= speed;
		}
		else if ((x < camera.scroll.x) && (velocity.x <= 0))
			velocity.x += speed;
		if ((y> camera.scroll.y +  FlxG.height - height) && (velocity.y >= 0))
			velocity.y -= speed;
		else if((y<camera.scroll.y) && (velocity.y <= 0))
			velocity.y += speed;
	}
	
	private function animControl():Void
	{
		if (x >= player.x)
			facing = FlxObject.LEFT;
		else
			facing = FlxObject.RIGHT;
	}
}

	/*private function tracking(elapsed:Float):Void
	{
		if (!catche)
		{
			speed = Reg.pathSpeed;
			infinite();
		}
		else
		{
			velocity.set(0, 0);
			speed = Reg.speedEnemy;
			if ((y > player.y + 1) || (y > player.y - 1))
				if(velocity.y >=0)
					velocity.y -= speed;
			if ((y < player.y + 1) || (y < player.y - 1))
				if(velocity.y <= 0)
					velocity.y += speed;
			if ((x > player.x + 1) || (x > player.x - 1))
				if(velocity.x >=0)
					velocity.x -= speed;
			if ((x < player.x + 1) || (x < player.x - 1))
				if(velocity.x <= 0)
					velocity.x += speed;
		}
	}
	
	private function estoyLejos():Void
	{
		if ((x > player.x) && (x - player.x < Reg.trackDist))
			if ((y > player.y) && (y - player.y < Reg.trackDist))
				catche = true;
		if ((x < player.x) && (player.x - x < Reg.trackDist))
			if ((y < player.y) && (player.y - y < Reg.trackDist))
				catche = true;
	}*/