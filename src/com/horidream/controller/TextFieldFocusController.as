package com.horidream.controller
{
	import com.horidream.core.DisplayObjectController;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Oct 16, 2011 12:46:38 AM
	 */
	public class TextFieldFocusController extends DisplayObjectController
	{
		public function TextFieldFocusController(tf:DisplayObject,onFocusIn:String = "",onFocusOut:String = "")
		{
			super(tf, {onFocusIn:onFocusIn,onFocusOut:onFocusOut}, false);
			target["text"] = vars.onFocusOut;
		}
		

		public override function bind(vars:Object):void
		{
			super.bind(vars);
			target.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			target.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}


		public override function release():void
		{
			if(target){
				target.removeEventListener(FocusEvent.FOCUS_IN,onFocusIn);
				target.removeEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			}
			super.release();
		}


		private function onFocusOut(e:FocusEvent):void
		{
			if(target["text"] == vars.onFocusIn){
				target["text"] = vars.onFocusOut;
			}
		}

		private function onFocusIn(e:FocusEvent):void
		{
			if(String(target["text"]).indexOf(String(vars.onFocusOut))>-1){
				target["text"] = vars.onFocusIn;
			}
			
		}


	}
}