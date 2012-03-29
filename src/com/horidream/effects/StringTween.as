package com.horidream.effects
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Dec 21, 2010 11:11:01 PM
	 */
	public class StringTween extends EventDispatcher
	{
		[Bindable]
		public var currentString:String;
		private var startString:String;
		private var endString:String;
		private var sampleStr:String ;
		private var startLength:int;
		private var endLength:int;
		private var curLength:int;
		private var sampleLength:int;
		private var sampleChangeLength:int;
		private var start:Number;
		private var position:Number;
		private var end:Number;
		private var duration:Number;
		private var delay:Number;
		private var ticker:Shape;
		private var vars:Object;
		private var easeFunc:Function
		private var reversed:Boolean = false;
		public function StringTween(vars:Object ) 
		{
			ticker = new Shape();
			reset(vars);
		}
		private function init():void {
			startString = vars.startString || "";
			startLength = startString.length;
			currentString = startString;
			endString = vars.endString || "";
			endLength = endString.length;
			sampleStr = vars.sampleString ||  "Horidream";
			sampleLength = sampleStr.length;
			sampleChangeLength = vars.changeLength || 1;
			duration = vars.duration || 1;
			delay = vars.delay || 0;
			delay = delay > 0?delay:0;
			easeFunc = vars.ease || linearEase;
		}
		public function reset(vars:Object):void {
			this.vars = vars;
			init();
			play();
			if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
		}
		public function destroy():void
		{
			if(ticker)
			ticker.removeEventListener(Event.ENTER_FRAME, tickHandler);
		}
		private function play():void {
			start = getTimer() / 1000 +delay;
			end = start + duration;
			tickHandler();
			ticker.addEventListener(Event.ENTER_FRAME, tickHandler);
		}
		/**
		 * reverse the tween.If a StringTween is reversed in the middle of tweening, the value will jump to then destination or start value.
		 */
		public function reverse():void {
			reversed = !reversed;
			var tempStr:String = vars.startString;
			vars.startString = vars.endString;
			vars.endString = tempStr;
			reset(vars);
		}
		/**
		 * handles enterFrame event.
		 * @param	e
		 */
		private function tickHandler(e:Event=null):void {
			updateTween(getTimer() / 1000);
		}
		/**
		 * update StringTween.Calculate tween progress and dispatch events.
		 * @param	time Current time in second.
		 */
		private function updateTween(time:Number):void {
			if (time >= end) {
				position = end;
			} else {
				position = time;
			}
			var past:Number = position - start
			if (past < 0) return;
			
			var ratio:Number = easeFunc(past/duration, 0, 1, 1);
			updateString(ratio);		
			
			if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			
			if ( position == end) {
				ticker.removeEventListener(Event.ENTER_FRAME, tickHandler);
				if (hasEventListener(Event.COMPLETE) ) dispatchEvent(new Event(Event.COMPLETE));
				
			}
		}
		/**
		 * update current string by picking part of startString or endString and some random characters.
		 * @param	ratio a number between 0 -1 that indicates the progress of StringTween
		 */
		private function updateString(ratio:Number):void {
			var curLength:int , finalLength:int, pendingLength:int, loop:int;
			
			curLength = startLength + (endLength - startLength) * ratio;
			finalLength = (curLength > endLength?endLength:curLength) * ratio;
			pendingLength = curLength - finalLength;
			if (endString != "") {
				currentString = endString.substr(0, finalLength);
				loop = pendingLength
			} else {
				currentString = startString.substr(0, pendingLength);
				loop = finalLength;
			}
			
			var i:int = 0, rid:int ;
			loop = Math.min(sampleChangeLength,loop);
			while (i < loop) {
				i++
					rid = Math.random() * sampleLength;
				currentString += sampleStr.charAt(rid);
			}
		}
		/**
		 * default easing function,equals Linear.easeNone.
		 * @param	t
		 * @param	b
		 * @param	c
		 * @param	d
		 * @return
		 */
		private function linearEase(t:Number, b:Number, c:Number, d:Number):Number {
			return t;
		}
	}
}