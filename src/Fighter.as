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
				if (movementProcess == WINDUP)
				{
					var newVelocity:Number =  sword.runSpeed * movementStateTimer.progress
					if (Math.abs(velocity.x) < newVelocity)
					{
					//acceleration.x = sword.runSpeed / movementState.windupTime;//a/tm * t
					velocity.x = newVelocity;
					if (!facingRight)
					//	acceleration.x *= -1;
						velocity.x *= -1;
					}
				}
				else if(movementProcess == ONGOING)
					drag.x = 0;
				else if (movementProcess == RECOVERY) //NOTE: RECOVERY DOESN'T REALLY EXIST
				{
					velocity.x = sword.runSpeed * (1.0 - movementStateTimer.progress);
					if (!facingRight)
						velocity.x *= -1;
				}
			}
			if (movementState == sword.slideState)
			{
				drag.x = 100;
			}
			if ((movementState == sword.jumpState || movementState == sword.jumpForwardState) && movementProcess != RECOVERY)
			{
				drag.x = 0;
			}
			if (movementState == sword.hopBackState || movementState == sword.hopForwardState)
			{
				drag.x = 0;
			}
			super.update();
		}
		
		private function updateStates():void
		{
			//set target state
			//if in air force a jump state
			
			if (!isOnGround && !(movementState == sword.jumpState || movementState == sword.jumpForwardState))
			{
				movementTarget = sword.jumpForwardState;
				movementStateTimer.stop();
				movementProcess = ONGOING;
			}
			
			else
			{
				if (movementProcess != WINDUP)
				{
					if (rightPressed)
					{
						if (movementState == sword.movementIdleState || movementState == sword.runState || 
							movementState == sword.slideState || movementState == sword.jumpForwardState)
						{
							if (facingRight)
								movementTarget = sword.runState;
							else
								movementTarget = sword.turnState;
						}
					}
					if (leftPressed)
					{
						if (movementState == sword.movementIdleState || movementState == sword.runState ||
							movementState == sword.slideState || movementState == sword.jumpForwardState)
						{
							if (!facingRight)
								movementTarget = sword.runState;
							else
								movementTarget = sword.turnState;
						}
					}
					
					if (crouchPressed)
					{
						if (movementState == sword.runState || movementState == sword.slideState || 
															   movementState == sword.jumpForwardState)
							{
								movementTarget = sword.slideState;
							}
						else
						{
							if (rightPressed)
							{
								if(facingRight)
									movementTarget = sword.crouchForwardState;
								else
									movementTarget = sword.crouchBackState;
							}
							else if (leftPressed)
							{
								if (!facingRight)
									movementTarget = sword.crouchForwardState;
								else
									movementTarget = sword.crouchBackState;
							}
							else
								movementTarget = sword.crouchState;
						}
					}
				}
				if (jumpPressed)
				{
					if (movementState == sword.movementIdleState)
						movementTarget = sword.jumpState;
					else if (movementState == sword.runState)
						movementTarget = sword.jumpForwardState;
					//else if (movementState == sword.jumpForwardState)
					//	movementTarget = sword.jumpForwardState;
					//else if ( movementState == sword.jumpState)
					//	movementTarget = sword.jumpState;
					//else if (movementState == sword.turnState)
					//	movementTarget = sword.jumpForwardState;
					else if (movementState == sword.crouchForwardState)
						movementTarget = sword.hopForwardState;
					else if (movementState == sword.crouchBackState)
						movementTarget = sword.hopBackState;
					else if (movementState == sword.hopForwardState || movementState == sword.hopBackState)
						movementTarget = sword.jumpState;
				}
			}
			//advance to next state
			if (movementStateTimer.finished)
			{
				if (movementProcess == WINDUP)
				{
					//directly transition into a jump in some cases
					if (movementTarget == sword.jumpForwardState && movementState == sword.runState)
					{
						transitionMovementStates(movementState, movementTarget);
						movementStateTimer.start(movementTarget.windupTime);
						movementState = movementTarget;
						movementTarget = sword.movementIdleState;
						movementProcess = WINDUP;
					}
					else
					{
					movementWindupToOngoing(movementState);
					movementStateTimer.start(movementState.ongoingTime);
					movementProcess = ONGOING;
					}
				}
				else if (movementProcess == ONGOING)
				{
					if (movementState == movementTarget && (movementTarget == sword.movementIdleState ||
															movementTarget == sword.runState ||
															movementTarget == sword.crouchBackState ||
															movementTarget == sword.crouchState ||
															movementTarget == sword.crouchForwardState ||
															movementTarget == sword.slideState))
					{
						movementTarget = sword.movementIdleState;
					}
					else if (!isOnGround && (movementState == sword.jumpState || movementState == sword.jumpForwardState))
					{
						//movementTarget = movementState;
					}
					else
					{
						if (movementTarget == sword.movementIdleState)
						{
							//movementOngoingToRecovery(movementState);
							transitionMovementStates(movementState, movementTarget);
							movementProcess = RECOVERY;
							movementStateTimer.start(movementState.recoveryTime);
						}
						else
						{
							transitionMovementStates(movementState, movementTarget);
							movementStateTimer.start(movementTarget.windupTime);
							movementState = movementTarget;
							movementTarget = sword.movementIdleState;
							movementProcess = WINDUP;
							
						}
					}
				}
				else if (movementProcess == RECOVERY)
				{
					movementState = sword.movementIdleState;
					//skip idle warmup
					movementProcess = ONGOING;
					movementTarget = sword.movementIdleState;
				}
			}
		}
		
		private function movementWindupToOngoing(state:FighterState):void
		{
			switch(state.ID)
			{
				case MOVEMENT_JUMP:
					if (isOnGround)
					{
					velocity.y = -400;
					//velocity.x = 0;
					drag.x = 0;
					}
					break;
				case MOVEMENT_JUMP_FORWARD:
					//MOVE THIS CHECK SOMEWHERE ELSE
					if (isOnGround)
					{
					velocity.y = -400;
					if (facingRight)
						velocity.x = sword.runSpeed;
					else
						velocity.x = -sword.runSpeed;
					drag.x = 0;
					}
					break;
				case MOVEMENT_HOP_FORWARD:
						velocity.x = 1800;
					if (!facingRight)
						velocity.x *= -1;
					break;
				case MOVEMENT_HOP_BACK:
						velocity.x = -1800;
					if (!facingRight)
						velocity.x *= -1;
					break;
			}
		}
		
		private function transitionMovementStates(state:FighterState, target:FighterState):void
		{
			//finish old state
			switch (state.ID)
			{
				//very temporary
				case MOVEMENT_JUMP:
				case MOVEMENT_JUMP_FORWARD:
					if (facingRight)
						color = 0xffffff;
					else
						color = 0x999999;
					break;
				case MOVEMENT_TURN: 
					facingRight = !facingRight;
					if (facingRight)
						color = 0xffffff;
					else
						color = 0x999999;
					break;
				case MOVEMENT_SLIDE:
					angle = 0;
				case MOVEMENT_CROUCH:
					scale.y = 1.0;
					break;
				case MOVEMENT_CROUCH_BACK:
					angle = 0;
					break;
				case MOVEMENT_CROUCH_FORWARD:
					angle = 0;
					break;
			}
			//begin new state
			//this is where we set the new animation, etc.
			switch(target.ID)
			{
				case MOVEMENT_SLIDE:
					angle = 90;
					break;
				case MOVEMENT_CROUCH:
					scale.y = .8;
					break;
				case MOVEMENT_CROUCH_BACK:
					angle = -20;
					if (!facingRight)
						angle *= -1;
					break;
				case MOVEMENT_CROUCH_FORWARD:
					angle = 20;
					if (!facingRight)
						angle *= -1;
					break;
				case MOVEMENT_JUMP:
					color = 0x000000;
					break;
				case MOVEMENT_JUMP_FORWARD:
					color = 0x000000;
					break;
			}
		}
		
		private function movementOngoingToRecovery(state:FighterState):void
		{
		
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