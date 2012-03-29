package com.horidream.controller
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 9, 2011
	 */
	import com.greensock.TweenMax;
	import com.horidream.core.DisplayObjectController;
	import com.horidream.interfaces.IStatusController;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DisplayObjectStatusTweenController extends DisplayObjectController implements IStatusController
	{
		public static const START:String = "start";
		public static const CHANGING:String = "changing";
		public static const END:String = "end";
		private var tween:TweenMax;
		public function DisplayObjectStatusTweenController(target:DisplayObject, vars:Object=null, autoRelease:Boolean=false)
		{
			
			super(target, vars, autoRelease);
		}
		

		protected override function init(e:Event=null):void
		{
			vars.paused = true;
			tween = TweenMax.to(target,vars.duration == null? .15:vars.duration,vars);
			super.init(e);
		}

		
		public override function release():void
		{
			if(tween){
				tween.currentTime = 0;
				tween = null;
			}
			super.release();
		}


		public function change():void
		{
			if(tween)
				tween.play();
		}

		public function reset():void
		{
			if(tween)
				tween.reverse();	
		}

		public function get status():String
		{
			var status:String;
			if(TweenMax.isTweening(target)){
				return CHANGING;
			}else{
				if(tween){
					if(tween.totalProgress == 0)
					{
						return START;
					}else{
						return END;
					}
				}
			}
			return RELEASED;
		}
	}
}