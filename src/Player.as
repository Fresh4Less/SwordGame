package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import org.flixel.*;
	public class Player extends Fighter
	{
		
		public function Player(X:int, Y:int)
		{
			super(X, Y);
		}
		
		override public function update():void
		{
			if (FlxG.keys.SHIFT)
			{
				pressCrouch();
			}
			if (!(FlxG.keys.RIGHT && FlxG.keys.LEFT))
			{
				if (FlxG.keys.RIGHT)
					pressRight();
				if (FlxG.keys.LEFT)
					pressLeft();
			}
			if (!(FlxG.keys.UP && FlxG.keys.DOWN))
			{
				if (FlxG.keys.UP)
					pressUp();
				if (FlxG.keys.DOWN)
					pressDown();
			}
			if (FlxG.keys.justPressed("SPACE"))
				pressJump();
			if (FlxG.keys.justPressed("Z"))
				pressSlash();
			if (FlxG.keys.justPressed("X"))
				pressStab();
			super.update();
			
		}
		
	}

}