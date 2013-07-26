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
		protected var leftRightButton:int;
		protected var upDownButton:int;
		protected var crouchPressed:Boolean;
		protected var jumpPressed:Boolean;
		protected var slashPressed:Boolean;
		protected var stabPressed:Boolean;

		//movement states
		public static const MOVEMENT_IDLE:int = 0;
		public static const MOVEMENT_RUN:int = 1;
		public static const MOVEMENT_TURN:int = 2;
		public static const MOVEMENT_JUMP:int = 3;
		public static const MOVEMENT_JUMP_FORWARD:int = 4;
		public static const MOVEMENT_CROUCH:int = 5;
		public static const MOVEMENT_CROUCH_BACK:int = 6;
		public static const MOVEMENT_CROUCH_FORWARD:int = 7;
		public static const MOVEMENT_HOP_BACK:int = 8;
		public static const MOVEMENT_HOP_FORWARD:int = 9;
		public static const MOVEMENT_SLIDE:int = 10;

		//attack states
		public static const ATTACK_IDLE:int = 0;
		public static const ATTACK_STAB_WINDUP:int = 1;
		public static const ATTACK_STAB:int = 2;
		public static const ATTACK_STAB_RECOVERY:int = 3;
		public static const ATTACK_SLASH_WINDUP:int = 4;
		public static const ATTACK_SLASH:int = 5;
		public static const ATTACK_SLASH_RECOVERY:int = 6;

		//directions
		public static const NONE:int = 0;
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		public static const UP:int = 3;
		public static const DOWN:int = 4;
		
		//state variables
		public var movementState:int;
		public var movementTarget:int;

		public var movementDirection:int;
		public var isOnGround:Boolean = false;

		public var attackState:int;
		public var attackTarget:int;
		
		private var movementTimer:FlxTimer;
		private var attackTimer:FlxTimer;
		
		private var sword:FighterSword;
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
			maxVelocity.x = 200;
			maxVelocity.y = 2000;
			drag.x = maxVelocity.x * 4;
			drag.y = 0;
			resetInput();
			movementTimer = new FlxTimer();
			movementTimer.start(0.01);
			sword = new FighterSword();

			movementState = MOVEMENT_IDLE;
			movementTarget = MOVEMENT_IDLE;
			movementDirection = RIGHT;

			attackState = ATTACK_IDLE;
			attackTarget = ATTACK_IDLE;
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
			
			if (movementState == MOVEMENT_RUN)
			{
				if (movementDirection == RIGHT)
					acceleration.x = drag.x;
				else
					acceleration.x = -drag.x;
			}
			else if (isOnGround && (movementState == MOVEMENT_JUMP || movementState == MOVEMENT_JUMP_FORWARD))
			{
				velocity.y = -400;
				drag.x = 0;
			}
			else if (!isOnGround && (movementState == MOVEMENT_JUMP || movementState == MOVEMENT_JUMP_FORWARD))
			{
				drag.x = 0;
			}
			
			super.update();
		}
		
		private function updateStates():void
		{
			switch (movementState) {
				case MOVEMENT_IDLE:
					if (leftRightButton != NONE)
					{
						if (leftRightButton == movementDirection)
						{
							movementState = MOVEMENT_RUN;
						}
						else
						{
							movementState = MOVEMENT_TURN;
						}
					}
				break;
				case MOVEMENT_RUN:
					if (leftRightButton == NONE)
					{
						movementState = MOVEMENT_IDLE;
					}
					else if (leftRightButton != movementDirection)
					{
						movementState = MOVEMENT_TURN;
					}
				break;
				case MOVEMENT_TURN:
					// once we have an animation/timer, check to see that it is done first
					if (movementDirection == RIGHT)
					{
						movementDirection = LEFT;
					}
					else
					{
						movementDirection = RIGHT;
					}

					if (leftRightButton == NONE) {
						movementState = MOVEMENT_IDLE;
					}
					else if (leftRightButton != movementDirection) {
						//do animation/timer over again
						movementState = MOVEMENT_TURN;
					}
					else
					{
						movementState = MOVEMENT_RUN;
					}
				break;
				case MOVEMENT_JUMP:

				break;
				case MOVEMENT_JUMP_FORWARD:

				break;
				case MOVEMENT_CROUCH:

				break;
				case MOVEMENT_CROUCH_BACK:

				break;
				case MOVEMENT_CROUCH_FORWARD:

				break;
				case MOVEMENT_HOP_BACK:

				break;
				case MOVEMENT_HOP_FORWARD:

				break;
				case MOVEMENT_SLIDE:

				break;
			}
			
			//if in air force a jump state
			/*
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
			*/
		}
		/*private function movementWindupToOngoing(state:FighterState):void
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
		}*/
		public function resetInput():void
		{
			 leftRightButton = NONE;
			 upDownButton = NONE;
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
			leftRightButton = RIGHT;
		}
		public function pressLeft():void
		{
			leftRightButton = LEFT;
		}
		public function pressUp():void
		{
			upDownButton = UP;
		}
		public function pressDown():void
		{
			upDownButton = DOWN;
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