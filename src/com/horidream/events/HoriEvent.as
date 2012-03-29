package com.horidream.events
{
	import flash.events.Event;
	
	public class HoriEvent extends Event
	{
		public static const CENSOR_COMPLETE:String = "censorComplete";
		public static const CENSOR_FIRE:String = "censorFire";
		public static const CLICK:String = "horiClick";
		public static const MOVIE_COMPLETE:String = "horiMovieComplete";
		
		public var params:*;
		public function HoriEvent(type:String, params:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return formatToString("HoriEvent","type","params","bubbles","cancelable","eventPhase");
		}

		


	}
}