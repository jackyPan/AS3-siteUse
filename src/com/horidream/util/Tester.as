package com.horidream.util
{
	import flash.display.MovieClip;
	import flash.utils.getTimer;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Oct 8, 2010 5:32:28 PM
	 */
	public class Tester
	{
		public static function run(times:int,func:Function,...args):int
		{
			var time:int = getTimer();
			while(times--){
				func.apply(null,args);
			}
			return getTimer()-time;
		}
	}
}