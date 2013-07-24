package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	public class FighterSword 
	{
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
		
		//states
		public var movementIdleState:FighterState;
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
		public var slashState:FighterState;
		
		public function FighterSword() 
		{
			runWindupTime = 0.1;
			runOngoingTime = 0.01;
			runRecoveryTime = 0.1;
			crouchWindupTime = 0.1;
			crouchOngoingTime = 0.01;
			crouchRecoveryTime = 0.1;
			crouchBackWindupTime = 0.1;
			crouchBackOngoingTime = 0.01;
			crouchBackRecoveryTime = 0.1;
			crouchForwardWindupTime = 0.1;
			crouchForwardOngoingTime = 0.01;
			crouchForwardRecoveryTime = 0.1;
			jumpWindupTime = 0.1;
			jumpOngoingTime = 0.01;
			jumpRecoveryTime = 0.1;
			jumpForwardWindupTime = 0.1;
			jumpForwardOngoingTime = 0.01;
			jumpForwardRecoveryTime = 0.1;
			hopForwardWindupTime = 0.1;
			hopForwardOngoingTime = 0.1;
			hopForwardRecoveryTime = 0.1;
			hopBackWindupTime = 0.1;
			hopBackOngoingTime = 0.1;
			hopBackRecoveryTime = 0.1;
			slideWindupTime = 0.1;
			slideOngoingTime = 0.1;
			slideRecoveryTime = 0.1;
			turnWindupTime = 0.1;
			turnOngoingTime = 0.1;
			turnRecoveryTime = 0.1;
			stabWindupTime = 0.1;
			stabOngoingTime = 0.1;
			stabRecoveryTime = 0.1;
			slashWindupTime = 0.1;
			slashOngoingTime = 0.1;
			slashRecoveryTime = 0.1;
			
			movementIdleState = new FighterState(Fighter.MOVEMENT_IDLE, "movementIdle");
			attackIdleState = new FighterState(Fighter.ATTACK_IDLE, "attackIdle");
			runState = new FighterState(Fighter.MOVEMENT_RUN, "run", runWindupTime, runOngoingTime, runRecoveryTime);
			crouchState = new FighterState(Fighter.MOVEMENT_CROUCH, "crouch", crouchWindupTime, crouchOngoingTime, crouchRecoveryTime);
			crouchForwardState = new FighterState(Fighter.MOVEMENT_CROUCH_FORWARD, "crouchForward", crouchForwardWindupTime, crouchForwardOngoingTime, 
																															crouchForwardRecoveryTime);
			crouchBackState = new FighterState(Fighter.MOVEMENT_CROUCH_BACK, "crouchBack", crouchBackWindupTime, crouchBackOngoingTime, crouchBackRecoveryTime);
			jumpState = new FighterState(Fighter.MOVEMENT_JUMP, "jump", jumpWindupTime, jumpOngoingTime, jumpRecoveryTime);
			jumpForwardState = new FighterState(Fighter.MOVEMENT_JUMP_FORWARD, "jumpForward", jumpForwardWindupTime, jumpForwardOngoingTime, jumpForwardRecoveryTime);
			hopForwardState = new FighterState(Fighter.MOVEMENT_HOP_FORWARD, "hopForward", hopForwardWindupTime, hopForwardOngoingTime, hopForwardRecoveryTime);
			hopBackState = new FighterState(Fighter.MOVEMENT_HOP_BACK, "hopBack", hopBackWindupTime, hopBackOngoingTime, hopBackRecoveryTime);
			slideState = new FighterState(Fighter.MOVEMENT_SLIDE, "slide", slideWindupTime, slideOngoingTime, slideRecoveryTime);
			turnState = new FighterState(Fighter.MOVEMENT_TURN, "turn", turnWindupTime, turnOngoingTime, turnRecoveryTime);
			stabState = new FighterState(Fighter.ATTACK_STAB, "stab", stabWindupTime, stabOngoingTime, stabRecoveryTime);
			slashState = new FighterState(Fighter.ATTACK_SLASH, "slash", slashWindupTime, slashOngoingTime, slashRecoveryTime);
		}
		
	}

}