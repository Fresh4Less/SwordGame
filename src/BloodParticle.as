package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	public class BloodParticle extends FlxParticle
	{
		public var m_length:int;
		public function BloodParticle(length:int = 5 ) 
		{
			super();
			m_length = length;
			makeGraphic(1, 1, 0xff990000);
			scale.x = length;
			exists = false;
		}
	
		override public function onEmit():void
		{
			super.onEmit();
			scale.x = m_length;
			scale.y = 1.0;
		}
		
		override public function update():void
		{
			super.update();
			angle = Math.atan(velocity.y / velocity.x) * 180 / Math.PI;
			if (touching)
			{
				scale.x = 2;
				scale.y = 2;
				velocity.x = 0;
				velocity.y = 0;
			}
		}
	}
}