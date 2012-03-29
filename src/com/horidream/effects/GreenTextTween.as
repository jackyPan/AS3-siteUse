package com.horidream.effects
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.text.SplitTextField;
	
	import flash.text.TextField;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jul 8, 2011
	 */
	public class GreenTextTween
	{
		private var stf:SplitTextField;
		public var timeline:TimelineMax;
		private static const typeArr:Array = ["characters","words","lines"]


		public function GreenTextTween(tf:TextField,duration:Number,vars:Object,delay:Number = 0.02,type:int = 0,autoDestroy:Boolean = true)
		{
			stf = new SplitTextField(tf,typeArr[type]);
			
			timeline = new TimelineMax(autoDestroy?{onComplete:stf.destroy}:null);
			
			var tweens:Array = TweenMax.allFrom(stf.textFields, duration, vars, delay);
			for(var i:int = 0;i<tweens.length;i++)
			{
				timeline.insert(tweens[i]);
			}
		}
		
		public static function show(tf:TextField,duration:Number,vars:Object= null,delay:Number = 0.02,type:int = 0,autoDestroy:Boolean = true):GreenTextTween
		{
			vars ||=  {alpha:0}
			var gtt:GreenTextTween = new GreenTextTween(tf,duration,vars,delay,type,autoDestroy);
			
			return gtt;
		}
		
		public function destroy():void
		{
			stf.destroy();
		}
		
	}
}