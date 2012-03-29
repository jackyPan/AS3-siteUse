package com.horidream.template
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 20, 2011
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AddedSprite extends Sprite
	{
		protected var _initlized:Boolean = false;
		public function AddedSprite()
		{
			if(stage){
				onRegister();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,onRegister);
			}
		}

		protected function init():void
		{
			
		}
		protected function onRegister(e:Event = null):void
		{
			if(!_initlized)
			{
				init();
				_initlized = true;
			}
			if(e)
			{
				removeEventListener(Event.ADDED_TO_STAGE,onRegister);
			}
			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}

		protected function onRemove(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE,onRegister);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
	}
}