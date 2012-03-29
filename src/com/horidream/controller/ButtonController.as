package com.horidream.controller
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 8, 2011
	 */
	import com.horidream.core.DisplayObjectController;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ButtonController extends DisplayObjectController
	{
		public function ButtonController(target:DisplayObject, vars:Object=null, autoRelease:Boolean=false)
		{
			super(target, vars, autoRelease);
			
		}

		
		protected override function init(e:Event = null):void
		{
			super.init(e);
			if(vars){
				if(vars.onClick){
					target.addEventListener(MouseEvent.CLICK,onClick);
				}
				if(vars.onRollOver){
					target.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
				}
				if(vars.onRollOut){
					target.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
				}
				if(vars.onMouseDown){
					target.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				}
				if(vars.onMouseUp){
					target.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				}
				if(vars.buttonMode && target.hasOwnProperty("buttonMode")){
					target['buttonMode'] = vars.buttonMode;
				}
			}
		}

		protected function onMouseUp(e:MouseEvent):void
		{
			vars.onMouseUp.apply(null,vars.onMouseUpParams || [e]);
		}

		protected function onMouseDown(e:MouseEvent):void
		{
			vars.onMouseDown.apply(null,vars.onMouseDownParams || [e]);
		}

		protected function onRollOut(e:MouseEvent):void
		{
			vars.onRollOut.apply(null,vars.onRollOutParams || [e]);
		}

		protected function onRollOver(e:MouseEvent):void
		{
			vars.onRollOver.apply(null,vars.onRollOverParams || [e]);
		}

		protected function onClick(e:MouseEvent):void
		{
			vars.onClick.apply(null,vars.onClickParams || [e]);
		}
		public override function release():void
		{
			if(target){
				target.removeEventListener(MouseEvent.CLICK,onClick);
				target.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
				target.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
				target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				target.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				if(target.hasOwnProperty("buttonMode")){
					target['buttonMode'] = false;
				}
			}
			super.release();
			
		}


	}
}