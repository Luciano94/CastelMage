package entities.enemies;

import flash.display.InterpolationMethod;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

class Chaman extends Zombie 
{
	
	private var minions:FlxTypedGroup<Minion>;
	private var maxMinions: Int;
	private var minionTime: Int;
	private var timer: Int;
	private var minionX:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, _player:Player, _minions:FlxTypedGroup<Minion>) 
	{
		super(X, Y, _player);
		loadGraphic(AssetPaths.Shaman__png, true, 32, 48);
		animation.add("idle", [0], false);
		animation.add("move", [1, 2, 3, 4, 5, 6, 7], 12, true);
		maxMinions = Reg.maxMinions;
		minionTime = Reg.minionTime;
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		timer = 0;
		minions = _minions;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		summon();
	}
	
	override function taiCorro():Void 
	{
		if ((x > player.x) && (x - player.x < Reg.trackDist))
		{
			velocity.set(speed, 0);
			catche = true;
		}
		if ((x < player.x) && (player.x - x < Reg.trackDist))
		{
			velocity.set(-speed, 0);
			catche = true;
		}
		if (((x > player.x) && (x - player.x > Reg.trackDist))
			||((x < player.x)&&(player.x - x > Reg.trackDist)))
			catche = false;
		if (!catche)
			velocity.set(0, 0);
	}
	
	private function summon():Void
	{
		if (timer >= (60 * minionTime))
		{
			timer = 0;
			if (x > player.x)
				minionX = x - 10;
			else
				minionX = x + 10;
			if (minions.length < maxMinions)
				minions.add(new Minion(minionX, y, player));
		}
		else timer++;
	}
	
	override function animControl():Void 
	{
		if (catche)
		{
			facing = FlxObject.LEFT;
			animation.play("move");
		}
		else
		{
			animation.play("idle");
			facing = FlxObject.RIGHT;
		}	
	}
}