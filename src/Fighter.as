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
		public static const MOVEMENT_IDLE:int = 0;
		public static const MOVEMENT_RUN:int = 1;
		public static const MOVEMENT_CROUCH:int = 2;
		public static const MOVEMENT_JUMP:int = 3;
		public static const MOVEMENT_HOP_FORWARD:int = 4;
		public static const MOVEMENT_HOP_BACK:int = 5;
		public static const MOVEMENT_SLIDE:int = 6;
		public static const MOVEMENT_TURN:int = 7;
		public static const MOVEMENT_CROUCH_BACK:int = 8;
		public static const MOVEMENT_CROUCH_FORWARD:int = 9;
		public static const MOVEMENT_JUMP_FORWARD:int = 10;

		//attack states
		public static const ATTACK_IDLE:int = 0;
		public static const ATTACK_STAB:int = 1;
		public static const ATTACK_SLASH:int = 2;

		//process states
		public static const WINDUP:int = 0;
		public static const ONGOING:int = 1;
		public static const RECOVERY:int = 2;
		
		//state objects
		
		//state variables
		private var movementState:FighterState;
		private var movementProcess:int;
		private var movementTarget:FighterState;

		private var attackState:FighterState;
		private var attackProcess:int;
		private var attackTarget:FighterState;
		
		private var movementStateTimer:FlxTimer;
		
		private var sword:FighterSword;
		private var facingRight:Boolean;
		
		public var isOnGround:Boolean = false;
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
			maxVelocity.x = 200;
			maxVelocity.y = 2000;
			drag.x = maxVelocity.x * 4;
			drag.y = 0;
			resetInput();
			movementStateTimer = new FlxTimer();
			movementStateTimer.start(0.01);
			sword = new FighterSword();
			movementState = sword.movementIdleState;
			movementTarget = sword.movementIdleState;
			movementProcess = ONGOING;
			attackState = sword.attackIdleState;
			attackTarget = sword.attackIdleState;
			movementProcess = ONGOING;
			facingRight = true;
		}
		
		override public function update():void
		{
			//acceleration.x = 0;
			//acceleration.y = 900;
			updateStates();
			resetInput();
			acceleration.x = 0;
			acceleration.y = 900;
			drag.x = maxVelocity.x * 4;
			if (movementState == sword.runState)
			{
				if (facingRight)
					acceleration.x = drag.x;
				else
					acceleration.x = -drag.x;
			}
			else if (isOnGround && (movementState == sword.jumpState || movementState == sword.jumpForwardState))
			{
				velocity.y = -400;
				drag.x = 0;
			}
			else if (!isOnGround && (movementState == sword.jumpState || movementState == sword.jumpForwardState))
			{
				drag.x = 0;
			}
			super.update();
		}
		
		private function updateStates():void
		{
			//set target state
			movementTarget = sword.movementIdleState;
			//if in air force a jump state
			if (!isOnGround && (movementState != sword.jumpState || movementState != sword.jumpForwardState))
			{
				movementTarget = sword.jumpForwardState;
				movementStateTimer.stop();
				movementProcess = ONGOING;
			}
			else
			{
				if (rightPressed)
				{
					if (movementState == sword.movementIdleState || movementState == sword.runState)
					{
						if(facingRight)
							movementTarget = sword.runState;
						else
							movementTarget = sword.turnState;
					}
					else if (movementState == sword.crouchState)
					{
						if(facingRight)
							movementTarget = sword.crouchForwardState;
						else
							movementTarget = sword.crouchBackState;
					}
				}
				if (leftPressed)
				{
					if (movementState == sword.movementIdleState || movementState == sword.runState)
					{
						if(!facingRight)
							movementTarget = sword.runState;
						else
							movementTarget = sword.turnState;
					}
					else if (movementState == sword.crouchState)
					{
						if(!facingRight)
							movementTarget = sword.crouchForwardState;
						else
							movementTarget = sword.crouchBackState;
					}
				}
				
				if (crouchPressed)
				{
					if (movementState == sword.runState)
						movementTarget = sword.slideState;
					else
						movementTarget = sword.crouchState;
				}
				
				if (jumpPressed)
				{
					if (movementState == sword.movementIdleState)
						movementTarget = sword.jumpState;
					else if (movementState == sword.runState)
						movementTarget = sword.jumpForwardState;
					else if (movementState == sword.crouchForwardState)
						movementTarget = sword.hopForwardState;
					else if (movementState == sword.crouchBackState)
						movementTarget = sword.hopBackState;
				}
			}
			//advance to next state
			if (movementStateTimer.finished)
			{
				if (movementState == movementTarget && (movementTarget != sword.turnState || 
														movementTarget != sword.hopForwardState || 
														movementTarget != sword.hopBackState ||
														movementTarget != sword.slideState))
				{
					movementProcess = ONGOING
				}
				else
				{
					if (movementProcess == WINDUP)
					{
						movementWindupToOngoing(movementState);
						movementStateTimer.start(movementState.ongoingTime);
						movementProcess = ONGOING;
					}
					else if (movementProcess == ONGOING)
					{
						transitionMovementStates(movementState, movementTarget);
						movementStateTimer.start(movementTarget.windupTime);
						trace(movementTarget.name);
						movementState = movementTarget;
						//movementTarget = sword.movementIdleState;
						movementProcess = WINDUP;
					}
				}
			}
		}
		private function movementWindupToOngoing(state:FighterState):void
		{
		}
		private function transitionMovementStates(state:FighterState, target:FighterState):void
		{
			switch(state.ID)
			{
				case MOVEMENT_TURN:
					facingRight = !facingRight;
					break;
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