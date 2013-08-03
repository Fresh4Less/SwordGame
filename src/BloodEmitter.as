package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	public class BloodEmitter extends FlxEmitterExt
	{
		public var minLength:int;
		public var maxLength:int;
		public function BloodEmitter(X:int, Y:int, numParticles:int = 800) 
		{
			super(X, Y, 0);
			minLength = 4;
			maxLength = 10;
			//particleClass = BloodParticle;
			for (var i:int = 0; i < numParticles; i++)
			{
				var particle:BloodParticle = new BloodParticle((int)(FlxG.random()*(maxLength-minLength)) + minLength);
				//var particle:FlxParticle = new FlxParticle();
				//particle.makeGraphic(4, 4, 0xff990000);
				//particle.exists = false;
				add(particle);
			}
			setXSpeed(200, 400);
			setYSpeed(0, 100);
			gravity = 800;
			bounce = 0.01;
			minRotation = 0.0;
			maxRotation = 0.0;
			
		}
		
	}

}