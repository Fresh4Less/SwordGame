package
{
	/**
	 * ...
	 * @author ...
	 */
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	public class ChildCollider extends FlxSprite
	{
		public var m_parent:FlxObject = null;
		public function ChildCollider(X:Number = 0, Y:Number = 0, parent:FlxObject = null)
		{
			super(X, Y);
			m_parent = parent;
		}
		
	}

}