package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import org.flixel.*;
	public class Fighter extends FlxSprite
	{
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
			maxVelocity.x = 200;
			maxVelocity.y = 2000;
			drag.x = maxVelocity.x * 4;
			drag.y = 0;
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			acceleration.y = 900;
			super.update();
		}
	}

}