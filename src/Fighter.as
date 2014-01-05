package
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import mx.core.FlexSprite;
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
		public static const MOVEMENT_WALLSLIDE:int = 11;
		
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
		public var facingRight:Boolean;
		
		//collision variables (public because collision handler is static and I don't know how to make friend functions
		public var collider:ChildCollider;
		public var colliderFront:FlxSprite;
		public var colliderBack:FlxSprite;
		public var colliderTop:FlxSprite;
		public var colliderWallLeft:FlxSprite; //doesn't push player out of walls, but detects that they're there for the state machine
		public var colliderWallRight:FlxSprite;
		
		//rect(offsetx, offsety, width, height
		//private var colliderBottomRect:FlxRect = new FlxRect(6, 32, 20, 16);
		//private var colliderFrontRect:FlxRect = new FlxRect(16, 16, 16, 16);
		//private var colliderBackRect:FlxRect = new FlxRect(0, 16, 16, 16);
		//private var colliderTopRect:FlxRect = new FlxRect(6, 0, 20, 16);
		
		public var colliderRect:FlxRect = new FlxRect(-6, -32, 32, 48);
		public var colliderFrontRect:FlxRect = new FlxRect(10, -16, 14, 16);
		public var colliderBackRect:FlxRect = new FlxRect(-4, -16, 14, 16);
		public var colliderTopRect:FlxRect = new FlxRect(0, -32, 20, 16);
		public var colliderWallLeftRect:FlxRect = new FlxRect( -6, -16, 16, 16);
		public var colliderWallRightRect:FlxRect = new FlxRect(10, -16, 16, 16);
				
		public var isOnGround:Boolean = false;
		public var isOnWallRight:Boolean = false;
		public var isOnWallLeft:Boolean = false;
		
		//drawing
		private var mainSprite:FlxSprite;
		
		public function Fighter(X:Number, Y:Number)
		{
			super(X, Y);
						
			makeGraphic(20, 16, 0xffaaffaa);
			
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
			
			collider = new ChildCollider(X + colliderRect.x, Y + colliderRect.y, this);
			collider.makeGraphic(colliderRect.width, colliderRect.height, 0xff000000);
			
			colliderFront = new FlxSprite(X + colliderFrontRect.x, Y + colliderFrontRect.y);
			colliderFront.makeGraphic(colliderFrontRect.width, colliderFrontRect.height, 0xffaaaaff);
			colliderBack = new FlxSprite(X + colliderBackRect.x, Y + colliderBackRect.y);
			colliderBack.makeGraphic(colliderBackRect.width, colliderBackRect.height, 0xffffaaaa);
			colliderTop = new FlxSprite(X + colliderTopRect.x, Y + colliderTopRect.y);
			colliderTop.makeGraphic(colliderTopRect.width, colliderTopRect.height, 0xffffffaa);
			colliderWallLeft = new FlxSprite(X + colliderWallLeftRect.x, Y + colliderWallLeftRect.y);
			colliderWallLeft.makeGraphic(colliderWallLeftRect.width, colliderWallLeftRect.height, 0xff00aaaa);
			colliderWallRight = new FlxSprite(X + colliderWallRightRect.x, Y + colliderWallRightRect.y);
			colliderWallRight.makeGraphic(colliderWallRightRect.width, colliderWallRightRect.height, 0xffaa00aa);
			
			
			mainSprite = new FlxSprite(X, Y);
			mainSprite.makeGraphic(32, 48, 0xffffffff);
			mainSprite.offset.x = -colliderRect.x;
			mainSprite.offset.y = -colliderRect.y;
		}
		override public function draw():void
		{
			mainSprite.draw();
			colliderWallLeft.draw();
			colliderWallRight.draw();
			//collider.draw();
			colliderFront.draw();
			colliderBack.draw();
			colliderTop.draw();
			
			super.draw();
		}
		
		override public function update():void
		{
			updateStates();
			resetInput();
			acceleration.x = 0;
			acceleration.y = 900;
			drag.x = maxVelocity.x * 4;
			isOnGround = false;
			isOnWallRight = false;
			isOnWallLeft = false;
			
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
		override public function postUpdate():void
		{			
			super.postUpdate();
			
			setPositionAndColliders(this.x, this.y);
		}
		
		private function updateStates():void
		{
			//set target state
			//if in air force a jump state
			
			if (!isOnGround && movementState != sword.wallSlideState)
			{
				//first try to force a wallSlide
				if (isOnWallLeft || isOnWallRight)
				{
					movementTargets.length = 0;
					movementTargets.push(sword.wallSlideState);
					movementStateTimer.stop();
					movementProcess = RECOVERY;
				}
				else if(!(movementState == sword.jumpState || movementState == sword.jumpForwardState))
				{
					//movementTarget= sword.jumpForwardState;
					movementTargets.length = 0;
					movementTargets.push(sword.jumpForwardState);
					movementStateTimer.stop();
					movementProcess = RECOVERY;
				}
			}
			else if (movementState == sword.wallSlideState && !(isOnWallLeft || isOnWallRight))
			{
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
				if (!isOnGround && movementState == sword.wallSlideState)
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
							if ((rightPressed && !facingRight) || (leftPressed && facingRight))
							{
								movementTargets.push(sword.runState);
								movementTargets.push(sword.runState);
								movementTargets.push(sword.jumpForwardState);
							}
							else
								movementTargets.push(sword.jumpState);
						}
						else if (movementState == sword.crouchForwardState)
							movementTargets.push(sword.hopForwardState);
						else if (movementState == sword.crouchBackState)
							movementTargets.push(sword.hopBackState);
						else if (movementState == sword.hopForwardState || movementState == sword.hopBackState)
							movementTargets.push(sword.jumpState);
						else if ( movementState ==  sword.wallSlideState)
						{
							facingRight = isOnWallLeft;
							movementTargets.push(sword.jumpForwardState);
						}
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
					//trace(movementTargets.length);
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
					else if (!isOnGround && movementState == sword.wallSlideState)
					{
						//if in a wallslide in the air, only allow a walljump
						if (movementTarget == sword.jumpForwardState)
						{
							//skip directly to ongoing
							//TEMPORARY WORKAROUND - set "isOnGround" to true temporarily so the jump works
							isOnGround = true;
							movementTarget = movementTargets.shift();
							transitionMovementStates(movementState, movementTarget);
							movementState = movementTarget;
							//movementProcess = WINDUP;
							//movementStateTimer.start(movementState.windupTime);
							
							movementWindupToOngoing(movementState);
							movementStateTimer.start(movementState.ongoingTime);
							movementProcess = ONGOING;
						}
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
				
				case MOVEMENT_TURN: 
					facingRight = !facingRight;
					if (facingRight)
						mainSprite.color = 0xff0000;
					else
						mainSprite.color = 0x990000;
					mainSprite.alpha = 1.0;
					break;
				case MOVEMENT_SLIDE:
					mainSprite.angle = 0;
				case MOVEMENT_CROUCH:
					mainSprite.scale.y = 1.0;
					break;
				case MOVEMENT_CROUCH_BACK:
					mainSprite.angle = 0;
					break;
				case MOVEMENT_CROUCH_FORWARD:
					mainSprite.angle = 0;
					break;
			}
			//begin new state
			//this is where we set the new animation, etc.
			switch(target.ID)
			{
				case MOVEMENT_IDLE:
				case MOVEMENT_RUN:
					if (facingRight)
						mainSprite.color = 0xff0000;
					else
						mainSprite.color = 0x990000;
					break;
				case MOVEMENT_TURN:
					mainSprite.alpha = 0.5;
					break;
				case MOVEMENT_SLIDE:
					mainSprite.angle = 90;
					break;
				case MOVEMENT_CROUCH:
					if (facingRight)
						mainSprite.color = 0xff0000;
					else
						mainSprite.color = 0x990000;
					mainSprite.scale.y = .8;
					break;
				case MOVEMENT_CROUCH_BACK:
					mainSprite.angle = -20;
					if (!facingRight)
						mainSprite.angle *= -1;
					break;
				case MOVEMENT_CROUCH_FORWARD:
					mainSprite.angle = 20;
					if (!facingRight)
						mainSprite.angle *= -1;
					break;
				case MOVEMENT_JUMP:
					mainSprite.color = 0x000000;
					break;
				case MOVEMENT_JUMP_FORWARD:
					mainSprite.color = 0xaaaaaa;
					break;
				case MOVEMENT_WALLSLIDE:
					mainSprite.color = 0x00ee00;
					break;
			}
		}
		
		private function movementOngoingToRecovery(state:FighterState):void
		{
		
		}
		
		//collision
		static public function handleCollision(object1:FlxObject, object2:FlxObject):Boolean
		{
			var collided:Boolean = false;
			var childCollider:ChildCollider = (object1 as ChildCollider);
			var fighter:Fighter = Fighter(childCollider.m_parent)
			if (object2.overlaps(fighter))
			{
				FlxObject.separateY(fighter, object2);
				fighter.setPositionAndColliders(fighter.x, fighter.y);
				
				fighter.isOnGround = true;
				collided = true;
			}
			
			if (object2.overlaps(fighter.colliderTop))
			{
				fighter.setPositionAndColliders(fighter.x, object2.y + object2.height - fighter.colliderTopRect.y );
				fighter.velocity.y = 0;
			}
			
			if (object2.overlaps(fighter.colliderFront))
			{
				if (fighter.facingRight)
				{
					fighter.setPositionAndColliders(object2.x - fighter.colliderFrontRect.x - fighter.colliderFrontRect.width, 
						fighter.y);
				}
				else
				{
					fighter.setPositionAndColliders(object2.x + object2.width - fighter.colliderBackRect.x, fighter.y);
				}
				fighter.velocity.x = 0;
			}
			if (object2.overlaps(fighter.colliderBack))
			{
				if (fighter.facingRight)
				{
					fighter.setPositionAndColliders(object2.x + object2.width - fighter.colliderBackRect.x, fighter.y);
				}
				else
				{
					fighter.setPositionAndColliders(object2.x - fighter.colliderFrontRect.x - fighter.colliderFrontRect.width, 
						fighter.y);
				}
				fighter.velocity.x = 0;
			}
			if (object2.overlaps(fighter.colliderWallLeft))
			{
				fighter.isOnWallLeft = true;
			}
			if (object2.overlaps(fighter.colliderWallRight))
			{
				fighter.isOnWallRight = true;
			}
			
			return collided;
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
		
		public function setPositionAndColliders(X:Number, Y:Number):void
		{
			this.x = X;
			this.y = Y;
			mainSprite.x = X;
			mainSprite.y = Y;
			collider.x = this.x + colliderRect.x;
			collider.y = this.y + colliderRect.y;
			if (facingRight)
			{
				colliderFront.x = this.x + colliderFrontRect.x;
				colliderFront.y = this.y + colliderFrontRect.y;
				colliderBack.x = this.x + colliderBackRect.x;
				colliderBack.y = this.y + colliderBackRect.y;
			}
			else
			{
				colliderFront.x = this.x + colliderBackRect.x;
				colliderFront.y = this.y + colliderBackRect.y;
				colliderBack.x = this.x + colliderFrontRect.x;
				colliderBack.y = this.y + colliderFrontRect.y;
			}
			colliderTop.x = this.x + colliderTopRect.x;
			colliderTop.y = this.y + colliderTopRect.y;
			colliderWallLeft.x = this.x + colliderWallLeftRect.x;
			colliderWallLeft.y = this.y + colliderWallLeftRect.y;
			colliderWallRight.x = this.x + colliderWallRightRect.x;
			colliderWallRight.y = this.y + colliderWallRightRect.y;
			
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