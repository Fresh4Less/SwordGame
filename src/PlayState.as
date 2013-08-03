package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	public class PlayState extends FlxState 
	{
		
		private var platforms:FlxGroup;
		private var player1:Player;
		//private var bloodEmitter:BloodEmitter;
		private var killParticles:KillParticles;
		
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
			//bloodEmitter = new BloodEmitter(320, 240);
			//add(bloodEmitter);
			//bloodEmitter.start(false, 2, .005);
			killParticles = new KillParticles(100, 300);
			add(killParticles);
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("A"))
				killParticles.start(player1.velocity, 0);
			
			super.update();
			killParticles.x = player1.x + 16;
			killParticles.y = player1.y + 24;
			FlxG.collide(killParticles, platforms);
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