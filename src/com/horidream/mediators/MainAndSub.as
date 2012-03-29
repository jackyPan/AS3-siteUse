package com.horidream.mediators
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Aug 19, 2010 10:37:01 PM
	 */
	public class MainAndSub extends EventDispatcher
	{
		private var target:InteractiveObject;
		private var sub:DisplayObject;
		public static function set(target:InteractiveObject,sub:DisplayObject):MainAndSub
		{
			return new MainAndSub(target,sub);
		}
		public function MainAndSub(target:InteractiveObject,sub:DisplayObject)
		{
			this.target = target;
			this.sub = sub;
			sub.visible = false;
			sub.alpha = 0;
			if(target.hasOwnProperty("buttonMode")){
				target["buttonMode"] = true;
			}
			target.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			target.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			sub.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			sub.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			sub.visible = false;
		}
		public function dispose():void
		{
			target.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			target.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			sub.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			sub.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
		}
		private function onMouseOut(event:MouseEvent):void
		{
			TweenMax.to(sub,0.3,{autoAlpha:0})
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			TweenMax.to(sub,0.3,{autoAlpha:1});
		}
	}
}