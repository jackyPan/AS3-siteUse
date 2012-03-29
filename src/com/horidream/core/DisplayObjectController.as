package com.horidream.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.horidream.interfaces.IController;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 8, 2011
	 */
	public class DisplayObjectController extends EventDispatcher implements IController
	{
		public static const RELEASED:String = "released";
		protected var target:DisplayObject;
		protected var autoRelease:Boolean;
		protected var vars:Object;
		
		private var _paused:Boolean;
		/*如果是Flash IDE，则使用autoRelease模式*/
		public static var isOnTimeLine:Boolean = false;
		public function DisplayObjectController(target:DisplayObject,vars:Object = null,autoRelease:Boolean = false)
		{
			bind({target:target,initVars:vars,autoRelease:autoRelease});
		}


		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
		}

		public function bind(vars:Object):void
		{
			release();
			this.target = vars.target;
			this.autoRelease = isOnTimeLine? true:vars.autoRelease?vars.autoRelease:autoRelease;
			this.vars = vars.initVars || this.vars;
			if(target.stage)
			{
				init();
			}else{
				target.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		public function release():void
		{
			if(target){
				target.removeEventListener(Event.ADDED_TO_STAGE,init);
				target.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			}
			this.target = null;
			dispatchEvent(new Event(RELEASED));
		}
		
		
		
		protected function init(e:Event = null):void
		{
			target.removeEventListener(Event.ADDED_TO_STAGE,init);
			target.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		protected function onRemoveFromStage(e:Event):void
		{
			target.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			if(!autoRelease){
				target.addEventListener(Event.ADDED_TO_STAGE,init);
			}else{
				release();
			}
		}
	}
}