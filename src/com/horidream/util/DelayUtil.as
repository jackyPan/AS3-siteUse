package com.horidream.util
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Sep 8, 2011
	 */
	public class DelayUtil
	{
		public static function callNextFrame(func:Function,...args):void
		{
			Hori.enterFrame.add(
			function nextFrameCall():void
			{
				if(args.length>0){
					func.apply(null,args);
				}else{
					func.call(null);
				}
				Hori.enterFrame.remove(arguments.callee);
			})
		}
		
	}
}