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
		private static const MOVEMENT_HOP_FORWARD:int = 4;
		private static const MOVEMENT_HOP_BACK:int = 5;
		private static const MOVEMENT_SLIDE:int = 6;
		private static const MOVEMENT_TURN:int = 7;
		private static const MOVEMENT_CROUCH_BACK:int = 8;
		private static const MOVEMENT_CROUCH_FORWARD:int = 9;
		private static const MOVEMENT_JUMP_FORWARD:int = 10;

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
		
		private var stateTimer:FlxTimer;
		
		private var sword:FighterSword;
		private var facingRight:Boolean;
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
			maxVelocity.x = 200;
			maxVelocity.y = 2000;
			drag.x = maxVelocity.x * 4;
			drag.y = 0;
			resetInput();
			stateTimer = new FlxTimer();
			stateTimer.start(0.0);
			sword = new FighterSword();
			facingRight = true;
		}
		
		override public function update():void
		{
			//acceleration.x = 0;
			//acceleration.y = 900;
			
			updateStates();
			resetInput();
			super.update();
		}
		
		private function updateStates():void
		{
			//set target state
			movementTarget = MOVEMENT_IDLE;
			if (rightPressed)
			{
				if (movementState == MOVEMENT_IDLE || movementState == MOVEMENT_RUN)
				{
					if(facingRight)
						movementTarget = MOVEMENT_RUN;
					else
						movementTarget = MOVEMENT_TURN;
				}
				else if (movementState == MOVEMENT_CROUCH)
				{
					if(facingRight)
						movementTarget = MOVEMENT_CROUCH_FORWARD;
					else
						movementTarget = MOVEMENT_CROUCH_BACK;
				}
			}
			if (leftPressed)
			{
				if (movementState == MOVEMENT_IDLE || movementState == MOVEMENT_RUN)
				{
					if(!facingRight)
						movementTarget = MOVEMENT_RUN;
					else
						movementTarget = MOVEMENT_TURN;
				}
				else if (movementState == MOVEMENT_CROUCH)
				{
					if(!facingRight)
						movementTarget = MOVEMENT_CROUCH_FORWARD;
					else
						movementTarget = MOVEMENT_CROUCH_BACK;
				}
			}
			
			if (crouchPressed)
			{
				if (movementState == MOVEMENT_RUN)
					movementTarget = MOVEMENT_SLIDE;
				else
					movementTarget = MOVEMENT_CROUCH;
			}
			
			if (jumpPressed)
			{
				if (movementState == MOVEMENT_IDLE)
					movementTarget = MOVEMENT_JUMP;
				else if (movementState == MOVEMENT_RUN)
					movementTarget = MOVEMENT_JUMP_FORWARD;
				else if (movementState == MOVEMENT_CROUCH_FORWARD)
					movementTarget = MOVEMENT_HOP_FORWARD;
				else if (movementState == MOVEMENT_CROUCH_BACK)
					movementTarget = MOVEMENT_HOP_BACK;
			}
			
			//advance to next state
			if (stateTimer.finished)
			{
				if (movementState == movementTarget && (movementTarget != MOVEMENT_TURN || 
														movementTarget != MOVEMENT_HOP_FORWARD || 
														movementTarget != MOVEMENT_HOP_BACK ||
														movementTarget != MOVEMENT_SLIDE))
				{/*do nothing*/}
				else
				{
					//play appropriate animation
					switch(movementState)
					{
					}
				}
			}
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