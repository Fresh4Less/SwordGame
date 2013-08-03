package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxExplode;
	public class KillParticles  extends FlxGroup
	{
		public var splashEmitter:FlxEmitterExt//:BloodEmitter;
		public var sprayEmitter:BloodEmitter;
		public var sprayFrequency:Number;
		public var x:Number;
		public var y:Number;
		public var sprayDistance:Number
		public function KillParticles(X:Number, Y:Number) 
		{
			super();
			x =  X;
			y = Y;
			sprayFrequency = .0005;
			sprayDistance = 200;
			splashEmitter = new FlxEmitterExt(X, Y);
			
			var minLength:Number = 4;
			var maxLength:Number = 10;
			for (var i:int = 0; i < 400; i++)
			{
				var particle:BloodParticle = new BloodParticle((int)(FlxG.random()*(maxLength-minLength)) + minLength);
				splashEmitter.add(particle);
			}
			//splashEmitter = new BloodEmitter(X, Y, 400);
			//splashEmitter.setXSpeed( -100, 600);
			//splashEmitter.setYSpeed( -60, 60);
			//splashEmitter.gravity *= 0.3;
			//splashEmitter.setXSpeed( -100, 100);
			//splashEmitter.setYSpeed( -100, 100);
			//splashEmitter.gravity = 200;
			sprayEmitter = new BloodEmitter(X, Y, 800);
			add(splashEmitter);
			add(sprayEmitter);
			
		}
		
		public function start(initialVelocity:FlxPoint, initialAngle:Number):void
		{
			splashEmitter.gravity = 800 * 0.2;
			splashEmitter.bounce = 0.01;
			splashEmitter.minRotation = 0.0;
			splashEmitter.maxRotation = 0.0;
			var initialSpeed:Number = Math.sqrt(Math.pow(initialVelocity.x, 2) + Math.pow(initialVelocity.y, 2));
			initialAngle = initialAngle * 180 / Math.PI + 10;
										//* Math.cos(Math.atan2(initialVelocity.y,initialVelocity.x)-initialAngle);
			//var initialAngle:Number = Math.atan2(initialVelocity.y, initialVelocity.x)*180/Math.PI - 20;
			splashEmitter.setMotion(initialAngle, initialSpeed , 2, -40, 400, 8);
			splashEmitter.start(true, 0, 0, 350);
			splashEmitter.setMotion(initialAngle - 180 + 30, initialSpeed, 2, -30, 400, 8);
			splashEmitter.start(true, 0, 0, 50);
			//splashEmitter.start(true, 10);
			sprayEmitter.setMotion(10, sprayDistance, .5, -40, 100, .5);
			sprayEmitter.start(false, 1, sprayFrequency);
		}
		
		override public function update():void
		{
			sprayEmitter.x = x;
			sprayEmitter.y = y;
			splashEmitter.x = x;
			splashEmitter.y = y;
			sprayFrequency += .001 * FlxG.elapsed;
			sprayEmitter.frequency = sprayFrequency;
			if (sprayDistance > 30)
				sprayDistance -= 25 * FlxG.elapsed;
			sprayEmitter.distance = sprayDistance;
			super.update();
		}
		
	}

}