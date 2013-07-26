package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	public class FighterSword 
	{
		/*
		public var turnTime:Number;
		public var jumpTime:Number;
		public var jumpForwardTime:Number;
		public var crouchTime:Number;
		public var crouchBackTime:Number;
		public var crouchForwardTime:Number;
		public var hopBackTime:Number;
		public var hopForwardTime:Number;
		public var slideTime:Number;
		*/
		public var stabWindupTime:Number;
		public var stabTime:Number;
		public var stabRecoveryTime:Number;
		public var slashWindupTime:Number;
		public var slashTime:Number;
		public var slashRecoveryTime:Number;
		/*
		public var stabWindupTime:Number;
		public var stabTime:Number;
		public var stabRecoveryTime:Number;
		public var slashWindupTime:Number;
		public var slashTime:Number;
		public var slashRecoveryTime:Number;
		public var runWindupTime:Number;
		public var runOngoingTime:Number;
		public var runRecoveryTime:Number;
		public var crouchWindupTime:Number;
		public var crouchOngoingTime:Number;
		public var crouchRecoveryTime:Number;
		public var crouchBackWindupTime:Number;
		public var crouchBackOngoingTime:Number;
		public var crouchBackRecoveryTime:Number;
		public var crouchForwardWindupTime:Number;
		public var crouchForwardOngoingTime:Number;
		public var crouchForwardRecoveryTime:Number;
		public var jumpWindupTime:Number;
		public var jumpOngoingTime:Number;
		public var jumpRecoveryTime:Number;
		public var jumpForwardWindupTime:Number;
		public var jumpForwardOngoingTime:Number;
		public var jumpForwardRecoveryTime:Number;
		public var hopForwardWindupTime:Number;
		public var hopForwardOngoingTime:Number;
		public var hopForwardRecoveryTime:Number;
		public var hopBackWindupTime:Number;
		public var hopBackOngoingTime:Number;
		public var hopBackRecoveryTime:Number;
		public var slideWindupTime:Number;
		public var slideOngoingTime:Number;
		public var slideRecoveryTime:Number;
		public var turnWindupTime:Number;
		public var turnOngoingTime:Number;
		public var turnRecoveryTime:Number;
		public var stabWindupTime:Number;
		public var stabOngoingTime:Number;
		public var stabRecoveryTime:Number;
		public var slashWindupTime:Number;
		public var slashOngoingTime:Number;
		public var slashRecoveryTime:Number;
		*/
		//states
		//public var movementStates:Vector.<int>;
		public var attackStates:Vector.<int>;
		/*public var movementIdleState:FighterState;
		public var attackIdleState:FighterState;
		public var runState:FighterState;
		public var crouchState:FighterState;
		public var crouchForwardState:FighterState;
		public var crouchBackState:FighterState;
		public var jumpState:FighterState;
		public var jumpForwardState:FighterState;
		public var hopForwardState:FighterState;
		public var hopBackState:FighterState;
		public var slideState:FighterState;
		public var turnState:FighterState;
		public var stabState:FighterState;
		public var slashState:FighterState;*/
		
		public function FighterSword() 
		{
			/*
			turnTime = 0.1;
			jumpTime = 0.01;
			jumpForwardTime = 0.01;
			crouchTime = 0.01;
			crouchBackTime = 0.01;
			crouchForwardTime = 0.01;
			hopBackTime = 0.1;
			hopForwardTime = 0.1;
			slideTime = 0.1;
			*/
			stabWindupTime = 0.1;
			stabTime = 0.1;
			stabRecoveryTime = 0.1;
			slashWindupTime = 0.1;
			slashTime = 0.1;
			slashRecoveryTime = 0.1;
			/*
			movementStates = new Vector.<int>();
			movementStates[Fighter.MOVEMENT_IDLE] = 0;
			movementStates[Fighter.MOVEMENT_RUN] = 0;
			movementStates[Fighter.MOVEMENT_TURN] = turnTime;
			movementStates[Fighter.MOVEMENT_JUMP] = jumpTime;
			movementStates[Fighter.MOVEMENT_JUMP_FORWARD] = jumpForwardTime;
			movementStates[Fighter.MOVEMENT_CROUCH] = crouchTime;
			movementStates[Fighter.MOVEMENT_CROUCH_BACK] = crouchBackTime;
			movementStates[Fighter.MOVEMENT_CROUCH_FORWARD] = crouchForwardTime;
			movementStates[Fighter.MOVEMENT_HOP_BACK] = hopBackTime;
			movementStates[Fighter.MOVEMENT_HOP_FORWARD] = hopForwardTime;
			movementStates[Fighter.MOVEMENT_SLIDE] = slideTime;
			*/
			attackStates = new Vector.<int>();
			attackStates[Fighter.ATTACK_IDLE] = 0;
			attackStates[Fighter.ATTACK_STAB_WINDUP] = stabWindupTime;
			attackStates[Fighter.ATTACK_STAB] = stabTime;
			attackStates[Fighter.ATTACK_STAB_RECOVERY] = stabRecoveryTime;
			attackStates[Fighter.ATTACK_SLASH_WINDUP] = slashWindupTime;
			attackStates[Fighter.ATTACK_SLASH] = slashTime;
			attackStates[Fighter.ATTACK_SLASH_RECOVERY] = slashRecoveryTime;
		}
		
	}

}