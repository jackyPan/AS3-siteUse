package com.horidream.components
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Nov 15, 2010 10:09:56 PM
	 */
	public class DebugPanel extends Sprite
	{
		private var panel:SimpleScrollPane;
		private var logText:TextField;
		private var bar:ScrollBarVistaStyle;
		private var _instance:DebugPanel;
		private var h:uint;
		public function DebugPanel(w:uint = 550,h:uint= 400)
		{
			this.h = h;
			drawBackgroud(w,h);
			bar = new ScrollBarVistaStyle();
			bar.height = h;
			bar.x = w-bar.width;
			logText = log("------------------------------------------------------------------------------------------------------",false,w-bar.width,h);
			bar.numPerPage = Math.floor(h/16);
			bar.minimum = 0;
			bar.maximum = logText.numLines+0.000001;
			addChild(logText);
			bar.addEventListener(Event.CHANGE,onChange);
			logText.addEventListener(Event.SCROLL,onScroll);
			
		}
		public function setSize(w:uint,h:uint):void
		{
			this.h = h;
			drawBackgroud(w,h);
			bar.height = h;
			bar.x = w-bar.width;
			bar.numPerPage = Math.floor(h/16);
			bar.minimum = 0;
			logText.width = w-bar.width;
			logText.height = h;
			bar.maximum = logText.numLines+0.000001;
			
		}

		private function drawBackgroud(w:uint, h:uint):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,.7);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}


		public function reset():void{
			bar.maximum = logText.numLines;
		}
		private function onScroll(event:Event):void
		{
			bar.maximum = logText.numLines+0.000001;
			bar.removeEventListener(Event.CHANGE,onChange);
			if(logText.scrollV<=1){
				bar.value = bar.minimum;
			}else if(logText.scrollV>=logText.maxScrollV){
				bar.value = bar.maximum;
				
			}else{
				bar.value = logText.scrollV*(bar.maximum - bar.minimum)/(logText.numLines - bar.numPerPage +1);
			}
			bar.addEventListener(Event.CHANGE,onChange);
			if(logText.maxScrollV > 1 ){
				addChild(bar);
			}else{
				QuickSetter.removeSelf(bar);
			}
		}


		private function onChange(event:Event):void
		{
			bar.maximum = logText.numLines+0.000001;
			logText.removeEventListener(Event.SCROLL,onScroll);
			logText.scrollV = bar.value/(bar.maximum - bar.minimum)*(logText.numLines - bar.numPerPage +1);
			logText.addEventListener(Event.SCROLL,onScroll);
		}
	}
	
}
