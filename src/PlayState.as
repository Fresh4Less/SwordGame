package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	public class PlayState extends FlxState 
	{
		
		private var platforms:FlxGroup;
		private var player1:Player;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffffffff;
			
			player1 = new Player(100, 200);
			player1.makeGraphic(32, 48, 0xffffffff);
			
			platforms = new FlxGroup();
			var platform1:FlxSprite = new FlxSprite(0, 400);
			platform1.makeGraphic(640, 10, 0xff000000);
			platform1.immovable = true;
			platforms.add(platform1);
			var platform2:FlxSprite = new FlxSprite(0, 400 - 68)
			platform2.makeGraphic(200, 10, 0xff000000);
			platform2.immovable = true;5
			platforms.add(platform2);
			
			add(platforms);
			add(player1);
		}
		
		override public function update():void
		{
			super.update();
			if (FlxG.collide(player1, platforms))
			{
				//TODO: change this so only a "foot" collider will set this true
				player1.isOnGround = true;
			}
			else
				player1.isOnGround = false;
		}
	}

}