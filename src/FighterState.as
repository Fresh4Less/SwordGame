package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	public class FighterState 
	{
		public var ID:int;
		public var name:String;
		public var windupTime:Number;
		public var ongoingTime:Number;
		public var recoveryTime:Number;
		
		public function FighterState(l_ID:int = 0, l_name:String = "", 
									l_windupTime:Number = 0.01, l_ongoingTime:Number = 0.01, l_recoveryTime:Number = 0.01) 
		{
			ID = l_ID;
			name = l_name;
			windupTime = l_windupTime;
			ongoingTime = l_ongoingTime;
			recoveryTime = l_recoveryTime;
		}
		
	}

}