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
		public static const ATTACK_IDLE:int = 11;
		public static const ATTACK_STAB_FORWARD:int = 12;
		public static const ATTACK_SLASH_FORWARD:int = 13;
		public static const ATTACK_STAB_UP:int = 14;
		public static const ATTACK_SLASH_UP:int = 15;
		public static const ATTACK_STAB_FORWARD_RUNNING:int = 16;
		public static const ATTACK_SLASH_FORWARD_RUNNING:int = 17;
		public static const ATTACK_STAB_UP_RUNNING:int = 18;
		public static const ATTACK_SLASH_UP_RUNNING:int = 19;
		
		//process states
		public static const WINDUP:int = 0;
		public static const ONGOING:int = 1;
		public static const RECOVERY:int = 2;
		
		//state objects
		
		//state variables
		private var movementState:FighterState;
		private var movementProcess:int;
		private var movementTargets:Vector.<FighterState>;
		
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
			//movementTarget = sword.movementIdleState;
			movementTargets = new Vector.<FighterState>();
			//empty = idle
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
			if (movementState == sword.slashForwardRunningState || movementState == sword.slashUpRunningState)
			{
				drag.x = 0;
			}
			if (movementState == sword.stabForwardRunningState || movementState == sword.stabUpRunningState)
			{
				
			}
			super.update();
		}
		
		private function updateStates():void
		{
			//set target state
			//if in air force a jump state
			
			if (!isOnGround && !(movementState == sword.jumpState || movementState == sword.jumpForwardState))
			{
				//movementTarget= sword.jumpForwardState;
				movementTargets.length = 0;
				movementTargets.push(sword.jumpForwardState);
				movementStateTimer.stop();
				movementProcess = RECOVERY;
			}
			
			else
			{
				if (!isOnGround && (movementState == sword.jumpState || movementState == sword.jumpForwardState))
				{
					
				}
				if (movementTargets.length == 0)
				{
					if (rightPressed)
					{
						if (movementState == sword.movementIdleState || movementState == sword.runState || 
							movementState == sword.slideState || movementState == sword.jumpForwardState)
						{
							if (facingRight)
								movementTargets.push(sword.runState);
							else
								movementTargets.push(sword.turnState);
						}
					}
					if (leftPressed)
					{
						if (movementState == sword.movementIdleState || movementState == sword.runState ||
							movementState == sword.slideState || movementState == sword.jumpForwardState)
						{
							if (!facingRight)
								movementTargets.push(sword.runState);
							else
								movementTargets.push(sword.turnState);
						}
					}
					
					if (crouchPressed)
					{
						if (movementState == sword.runState)
							{
								movementTargets.push(sword.slideState);
							}
						else if ( movementState == sword.slideState || movementState == sword.jumpForwardState)
						{
							//DON"T COMBO FROM A CONTINUED SLIDE
							movementTargets.length = 0;
							movementTargets.push(sword.slideState);
						}
						else
						{
							if (rightPressed)
							{
								if(facingRight)
									movementTargets.push(sword.crouchForwardState);
								else
									movementTargets.push(sword.crouchBackState);
							}
							else if (leftPressed)
							{
								if (!facingRight)
									movementTargets.push(sword.crouchForwardState);
								else
									movementTargets.push(sword.crouchBackState);
							}
							else
								movementTargets.push(sword.crouchState);
						}
					}
				}
						if (stabPressed)
						{
							if (movementState == sword.movementIdleState || movementState == sword.crouchBackState || 
								movementState == sword.crouchState || movementState == sword.crouchForwardState)
							{
								if (upPressed)
									movementTargets.push(sword.stabUpState);
								else
									movementTargets.push(sword.stabForwardState);
							}
							else if (movementState == sword.runState)
							{
								if (upPressed)
									movementTargets.push(sword.stabUpRunningState);
								else 
								movementTargets.push(sword.stabForwardRunningState);
							}
						}
						if (slashPressed)
						{
							if (movementState == sword.movementIdleState || movementState == sword.crouchBackState || 
								movementState == sword.crouchState || movementState == sword.crouchForwardState)
							{
								if (upPressed)
									movementTargets.push(sword.slashUpState);
								else
									movementTargets.push(sword.slashForwardState);
							}
							else if (movementState == sword.runState)
							{
								if (upPressed)
									movementTargets.push(sword.slashUpRunningState);
								else 
								movementTargets.push(sword.slashForwardRunningState);
							}
						}
					if (jumpPressed)
					{
						if (movementState == sword.movementIdleState)
							movementTargets.push(sword.jumpState);
						else if (movementState == sword.runState)
						{
							//If you press turn and jump the same frame while running, you skip running up to full speed
							//HORRIBLE HACK TO FIX THIS
							if (movementTargets.length > 0 && movementTargets[0] == sword.turnState)
							{
								movementTargets.push(sword.runState);
								movementTargets.push(sword.runState);
							}
							movementTargets.push(sword.jumpForwardState);
						}
						//else if (movementState == sword.jumpForwardState)
						//	movementTargets.push(sword.jumpForwardState);
						//else if ( movementState == sword.jumpState)
						//	movementTargets.push(sword.jumpState);
						else if (movementState == sword.turnState)
						{
							//NOTE: I put two run states as a small workaround
							//since running constantly generates a runstate, if we want to do a running jump we first 
							//check for a run state, then check if there is a following jump state so we can skip the run recovery
							//here, the first run state gets us up to full speed, the second gets eaten by state machine
							movementTargets.push(sword.runState);
							movementTargets.push(sword.runState);
							movementTargets.push(sword.jumpForwardState);
						}
						else if (movementState == sword.crouchForwardState)
							movementTargets.push(sword.hopForwardState);
						else if (movementState == sword.crouchBackState)
							movementTargets.push(sword.hopBackState);
						else if (movementState == sword.hopForwardState || movementState == sword.hopBackState)
							movementTargets.push(sword.jumpState);
					}
			}
			//advance to next state
			if (movementStateTimer.finished)
			{
				if (movementProcess == WINDUP)
				{
					movementWindupToOngoing(movementState);
					movementStateTimer.start(movementState.ongoingTime);
					movementProcess = ONGOING;
				}
				else if (movementProcess == ONGOING)
				{
					trace(movementTargets.length);
					var movementTarget:FighterState = sword.movementIdleState;
					if (movementTargets.length != 0)
						movementTarget = movementTargets[0];
						
					if (movementState == movementTarget && (movementTarget == sword.movementIdleState ||
															movementTarget == sword.runState ||
															movementTarget == sword.crouchBackState ||
															movementTarget == sword.crouchState ||
															movementTarget == sword.crouchForwardState ||
															movementTarget == sword.slideState ))
					{
						//ignore the repeated action
						if(movementTargets.length != 0)
							movementTargets.shift();
						//if we still have an action, it was a combo (eg: running->forward jump) and we skip recovery
						if (movementTargets.length > 0)
						{
							movementTarget = movementTargets.shift();
							transitionMovementStates(movementState, movementTarget);
							movementState = movementTarget;
							movementProcess = WINDUP;
							movementStateTimer.start(movementState.windupTime);
						}
						
							
					}
					else if (!isOnGround && (movementState == sword.jumpState || movementState == sword.jumpForwardState))
					{
						//effectively disables queuing while in air
						//otherwise you only queue right when you leave the ground
						movementTargets.length = 0;
						//movementTargets.push(movementState);
					}
					else
					{
						if (movementState == sword.jumpForwardState && 
						   (movementTarget == sword.slideState || movementTarget == sword.runState))
						{
							//special cases where you land from jump, but don't have to recover
							movementTarget = movementTargets.shift();
							transitionMovementStates(movementState, movementTarget);
							movementState = movementTarget;
							movementProcess = WINDUP;
							movementStateTimer.start(movementState.windupTime);
						}
						else
						{
							movementOngoingToRecovery(movementState);
							movementProcess = RECOVERY;
							movementStateTimer.start(movementState.recoveryTime);
						}
					}
				}
				else if (movementProcess == RECOVERY)
				{
					var movementTarget1:FighterState = sword.movementIdleState;
					if (movementTargets.length != 0)
						movementTarget1 = movementTargets.shift();
						
					transitionMovementStates(movementState, movementTarget1);
					movementState = movementTarget1;
					movementProcess = WINDUP;
					movementStateTimer.start(movementState.windupTime);
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
					alpha = 1.0;
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
				case MOVEMENT_TURN:
					alpha = 0.5;
					break;
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