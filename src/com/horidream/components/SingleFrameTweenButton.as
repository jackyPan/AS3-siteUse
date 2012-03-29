package com.horidream.components
{
	import com.greensock.TweenMax;
	import com.horidream.core.ButtonBase;
	import com.horidream.util.QuickSetter;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jan 12, 2011 10:41:16 PM
	 */
	public class SingleFrameTweenButton extends ButtonBase
	{
		
		public static const DROP_SHADOW_VARS:Object = {dropShadowFilter:{blurX:5, blurY:5, angle:90,distance:5, alpha:0.6}};
		
		private var mouseOverStatus:Object;
		private var tween:TweenMax;
		private var time:Number;
		
		public function SingleFrameTweenButton(view:MovieClip,mouseOverStatus:Object,time:Number = .2)
		{
			this.mouseOverStatus = mouseOverStatus;
			this.time = time;
			tween = TweenMax.to(view,time,mouseOverStatus);
			tween.pause();
			super(view);
		}		
		
		
		
		protected override function onMouseOut(event:MouseEvent):void
		{
			tween.reverse();
		}
		protected override function onMouseOver(event:MouseEvent):void
		{
			tween.play();
			super.onMouseOver(event);
		}
		

		protected override function onMouseDown(event:MouseEvent):void
		{
			tween.play();
			super.onMouseDown(event);
		}


		
	}
}