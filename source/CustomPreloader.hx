package;

import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.Lib;
import openfl.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

@:font("assets/data/BatmanFA.ttf") class CustomFont extends Font {}

class CustomPreloader extends FlxBasePreloader 
{
	var text:TextField;
	
	public function new(MinDisplayTime:Float=5, ?AllowedURLs:Array<String>) 
	{
		super(MinDisplayTime, AllowedURLs);
		
	}
	
	override function create():Void
	{
		_width = Lib.current.stage.stageWidth;
		_height = Lib.current.stage.stageHeight;
		
		var ratio:Float = _width / 800;
		
		Font.registerFont(CustomFont);
		text = new TextField();
		text.defaultTextFormat = new TextFormat("BatmanForeverAlternate", Std.int(24 * ratio), 0xffeeeeee, true, false, false, " ", " ", TextFormatAlign.CENTER);
		text.embedFonts = true;
		text.selectable = false;
		text.multiline = false;
		text.x = 0;
		text.y = 5 * _height / 6;
		text.width = _width;
		text.height = Std.int(32 * ratio);
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