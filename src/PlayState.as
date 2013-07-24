package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	public class PlayState extends FlxState 
	{
		
		private var platforms:FlxGroup;
		private var player1:Player;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffffffff;
			
			player1 = new Player(100, 300);
			player1.makeGraphic(32, 48, 0xffdd2222);
			
			platforms = new FlxGroup();
			var platform1:FlxSprite = new FlxSprite(0, 400);
			platform1.makeGraphic(640, 10, 0xff000000);
			platform1.immovable = true;
			platforms.add(platform1);
			
			add(platforms);
			add(player1);
		}
		
		override public function update():void
		{
			super.update();
			FlxG.collide(player1, platforms);
		}
	}

}