package;

import flixel.FlxG;
import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.Lib;
import flixel.text.FlxText;
import openfl.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

@:bitmap("assets/images/CustomPreload/logo.png") class LogoImage extends BitmapData {}

class CustomPreloader extends FlxBasePreloader 
{
	var text:TextField;
	var logo:Sprite;
	var flxText:FlxText;
	
	public function new(MinDisplayTime:Float=5, ?AllowedURLs:Array<String>) 
	{
		super(MinDisplayTime, AllowedURLs);
		
	}
	
	override function create():Void
	{
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;
		
		var ratio:Float = _width / 800;
		
		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0)));
		logo.scaleX = logo.scaleY = ratio;
		logo.x = this._width / 2 - logo.width / 2;
		logo.y = this._height / 2 - logo.height / 2;
		addChild(logo);
		
		text = new TextField();
		text.defaultTextFormat = new TextFormat("Nokia Cellphone FC Small", 48, 0xffffff, false, false, false, " ", " ", TextFormatAlign.CENTER);
		text.selectable = false;
		text.multiline = false;
		text.x = 0;
		text.y = this._height * 5/6 ;
		text.width = this._width;
		text.height = 64;
		text.text = "Loading:";
		addChild(text);
		
		super.create();
	}
	
	override function update(Percent:Float):Void
	{
		text.text = "Loading: " + Std.int(Percent * 100) + "%";
		super.update(Percent);
	}	
}