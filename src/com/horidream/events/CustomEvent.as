package com.horidream.events
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		public var params:*;
		public function CustomEvent(type:String, params:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.params = params;
			super(type, bubbles, cancelable);
		}
		

		public override function clone():Event
		{
			return (new HoriEvent(type,params,bubbles,cancelable));
				
		}

		public override function toString():String
		{
			return formatToString("CustomEvent","type","params","bubbles","cancelable","eventPhase");
		}

		


	}
}