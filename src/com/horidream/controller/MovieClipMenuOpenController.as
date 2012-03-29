package com.horidream.controller
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 10, 2011
	 */
	import com.horidream.core.DisplayObjectController;
	import com.horidream.display.decorators.YoyoMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MovieClipMenuOpenController extends DisplayObjectController
	{
		private var menu:YoyoMovieClip;
		public function MovieClipMenuOpenController(target:MovieClip, autoRelease:Boolean=false)
		{
			menu = new YoyoMovieClip(target);
			super(target, null, autoRelease);
		}
		
		
		
		protected override function init(e:Event=null):void
		{
			menu.gotoAndStop(1);
			menu.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			menu.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			super.init(e);
		}

		private function onRollOut(e:MouseEvent):void
		{
			if(menu.hitTestPoint(menu.mouseX,menu.mouseY,true))
			{
				return;
			}
			menu.backwardPlay();
		}

		private function onRollOver(e:MouseEvent):void
		{
			menu.play();
		}


		public override function release():void
		{
			menu.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			menu.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			super.release();
		}


	}
}