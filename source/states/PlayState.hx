package states;

import entities.Player;
import entities.PowerUp;
import entities.weapons.WeaponNormal;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.ui.FlxBar;

class PlayState extends FlxState
{
	// Player
	public var player(get, null):Player;
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	
	override public function create():Void
	{
		super.create();
		
		//Tilemap
		loader = new FlxOgmoLoader(AssetPaths.Level__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset__png, 16, 16, "Tiles");
		tilemap.setTileProperties(0, FlxObject.NONE);
		tilemap.setTileProperties(1, FlxObject.NONE);
		tilemap.setTileProperties(2, FlxObject.ANY);
		add(tilemap);
		
		//Loader && Bounds
		loader.loadEntities(entityCreator, "Entities");
		FlxG.worldBounds.set(0, 0, 5120, 480);
		
		//Camera
		camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 2);
		camera.setScrollBounds(0, 5120, 0, 480);
		
		//HUD
		hud = new HUD();
		add(hud);
		
		playerHealth = new FlxBar(5, 250, FlxBarFillDirection.LEFT_TO_RIGHT, 50, 10, player, "hp", 0, 100, true);
		playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(player, tilemap);
	}
	
	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		switch (entityName)
		{
			case "Player":
				player = new Player(x, y);
				add(player);
		}
	}
	
	function get_player():Player 
	{
		return player;
	}
}