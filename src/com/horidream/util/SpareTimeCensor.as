package com.horidream.util
{
	import com.horidream.events.HoriEvent;
	import com.horidream.interfaces.ICommand;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SpareTimeCensor extends EventDispatcher
	{
		private var stage:Stage;
		private var timer:Timer;
		private var delayTime:uint;
		private var callBack:Function;
		private var _idle:Boolean = false;
		private var _isRunning:Boolean = false;
		public function SpareTimeCensor(stage:Stage)
		{
			this.stage = stage;
			
			
		}
		public function get idle():Boolean
		{
			return _idle;
		}
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		public function start(delayTime:uint):void{
			stop();
			this.delayTime = delayTime;
			_isRunning = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,prepareCensor);
			stage.addEventListener(MouseEvent.CLICK,prepareCensor);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,prepareCensor);
			prepareCensor();
		}
		public function stop():void{
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,onTimer);
			}
			_isRunning = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,prepareCensor);
			stage.removeEventListener(MouseEvent.CLICK,prepareCensor);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,prepareCensor);
		}


		
		private function prepareCensor(e:Event = null):void {
			if(timer){
				timer.reset();
				timer.addEventListener(TimerEvent.TIMER,onTimer);
			}else{
				timer = new Timer(delayTime);
				timer.addEventListener(TimerEvent.TIMER,onTimer);
			}
			timer.start();
			if(_idle){
				_idle = false;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		private function onTimer(event:TimerEvent):void
		{
			if(!_idle){
				_idle = true;
				_isRunning = false;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}