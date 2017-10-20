package source.states;

import entities.Player;
import entities.PowerUp;
import entities.Box;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	// Player
	private var player:Player;
	// PowerUp
	private var whichPUp:Int;
	private var r:FlxRandom;
	private var pUp:PowerUp;
	private var pUps:FlxTypedGroup<PowerUp>;
  
	private var floor:FlxSprite; // Temporary
	private var floor2:FlxSprite; // Temporary
	
	override public function create():Void
	{
		super.create();
		FlxG.worldBounds.set(0, 0, 512, 480);
		// Player
		player = new Player(100, 15);
		// PowerUp
		pUps = new FlxTypedGroup();
		
		floor = new FlxSprite(100, camera.height - 30);
		floor.makeGraphic(400, 32);
		floor.immovable = true;
		floor2 = new FlxSprite(100, 60);
		floor2.makeGraphic(200, 32);
		floor2.immovable = true;
		
		camera.follow(player);
		
		add(player);
		add(floor);
		add(floor2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		checkCollisions();
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
	}
	public function checkCollisions() 
	{
		FlxG.overlap(player, pUps, powered);
		FlxG.collide(player, floor);
		FlxG.collide(player, floor2);
	}
	public function powered(p:Player, pU:PowerUp):Void // In process
	{
		whichPUp = pU.get_whichPowerUp();
		switch (whichPUp) 
		{
		  default:
			trace("I do nothing :D");
		}
		pU.kill();
	}
}