package com.horidream.util
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Mar 1, 2011
	 */
	public class TimeUtil
	{
		public static function formatDuration(duration:int):String
		{
			var d:int = int(duration/1000);
			var second:int = d%60;
			d = int(d/60);
			var minute:int = d%60;
			d = int(d/60);
			var hour:int = d%24;
			d = int(d/24);
			var day:int = d;
			
			var msg:String = "";
			if(day>0){
				if(day == 1){
					msg = day + " day "
					
				}else{
					msg = day + " days "
				}
			}
			if((hour>0) || (day>0)){
				if(hour == 1){
					msg += hour+ " hour ";
				}else{
					msg += hour+ " hours ";
				}
			}
			if((hour>0) || (day>0) || (minute>0))
			{
				if(minute == 1)
				{
					msg += minute+ " minute ";
				}else{
					msg += minute+ " minutes ";
				}
			}
			msg +=second+ " seconds ";
			return msg;
		}
	}
}