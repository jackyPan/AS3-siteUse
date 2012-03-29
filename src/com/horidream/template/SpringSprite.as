package com.horidream.template
{
	import flash.events.Event;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 28, 2011
	 */
	public class SpringSprite extends AddedSprite
	{
		
		protected var SW:Number = 0;
		protected var SH:Number = 0;

		protected override function onRegister(e:Event=null):void
		{
			super.onRegister(e);
			onResize();
			this.stage.addEventListener(Event.RESIZE,onResize);
		}

		protected override function onRemove(e:Event):void
		{
			super.onRemove(e);
			this.stage.removeEventListener(Event.RESIZE,onResize);
		}
		
		protected function onResize(e:Event = null):void
		{
			SW = this.stage.stageWidth;
			SH = this.stage.stageHeight;
		}


	}
}