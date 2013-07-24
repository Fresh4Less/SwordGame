package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import org.flixel.*;
	public class Fighter extends FlxSprite
	{
		//virtual keyboard
		protected var rightPressed:Boolean;
		protected var leftPressed:Boolean;
		protected var upPressed:Boolean;
		protected var downPressed:Boolean;
		protected var crouchPressed:Boolean;
		protected var jumpPressed:Boolean;
		protected var slashPressed:Boolean;
		protected var stabPressed:Boolean;

		//movement states
		private static const MOVEMENT_IDLE:int = 0;
		private static const MOVEMENT_RUN:int = 1;
		private static const MOVEMENT_CROUCH:int = 2;
		private static const MOVEMENT_JUMP:int = 3;
		private static const MOVEMENT_HOP:int = 4;
		private static const MOVEMENT_SLIDE:int = 5;

		//attack states
		private static const ATTACK_IDLE:int = 0;
		private static const ATTACK_STAB:int = 1;
		private static const ATTACK_SLASH:int = 2;

		//process states
		private static const WINDUP:int = 0;
		private static const ONGOING:int = 1;
		private static const RECOVERY:int = 2;

		//state variables
		private var movementState:int = MOVEMENT_IDLE;
		private var movementProcess:int = ONGOING;
		private var movementTarget:int = MOVEMENT_IDLE;

		private var attackState:int = ATTACK_IDLE;
		private var attackProcess:int = ONGOING;
		private var attackTarget:int = ATTACK_IDLE;
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
			maxVelocity.x = 200;
			maxVelocity.y = 2000;
			drag.x = maxVelocity.x * 4;
			drag.y = 0;
			resetInput();
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			acceleration.y = 900;
			
			
			resetInput();
			super.update();
		}
		
		public function resetInput():void
		{
			 rightPressed = false;
			 leftPressed = false;
			 upPressed = false;
			 downPressed = false;
			 crouchPressed = false;
			 jumpPressed = false;
			 slashPressed = false;
			 stabPressed = false;
		}
		//raw input interface, called based on keyboard input, etc.
		//all these do is set the next queued action
		//if the player is idle, it will set them to run right
		//if the player is crouching, they will lean forward
		//if the player is facing left, they will turn to the right
		//if the player is in the middle of an attack, queues them up for one of the previous
		public function pressRight():void
		{
			rightPressed = true;
			leftPressed = false;
		}
		public function pressLeft():void
		{
			leftPressed = true;
			rightPressed = false;
		}
		public function pressUp():void
		{
			upPressed = true;
			downPressed = false;
		}
		public function pressDown():void
		{
			downPressed = true;
			upPressed = true;
		}
		public function pressCrouch():void
		{
			crouchPressed = true;
		}
		public function pressJump():void
		{
			jumpPressed = true;
		}
		public function pressSlash():void
		{
			slashPressed = true;
		}
		public function pressStab():void
		{
			stabPressed = true;
		}
	}

}