package com.horidream.template
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 20, 2011
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.libspark.ui.SWFWheel;
	
	public class HoriMain extends MovieClip
	{
		protected var onStartFuncVector:Vector.<Function> ;
		public function HoriMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		protected function onAddedToStage(event:Event):void
		{
			SWFWheel.initialize(stage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (stage.stageWidth == 0 || stage.stageHeight == 0) addEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
			else startMain();
		}
		private function onWaitForWidthAndHeight(event:Event):void
		{
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
			{
				removeEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
				startMain();
			}
		}
		protected function startMain():void
		{
			if(onStartFuncVector){
				var len:int = onStartFuncVector.length;
				for (var i:int = 0;i<len;i++)
				{
					onStartFuncVector[i].call();
				}
			}
		}
	}
}