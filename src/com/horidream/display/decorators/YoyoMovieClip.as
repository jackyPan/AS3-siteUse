package com.horidream.display.decorators
{
	import com.horidream.core.MovieClipDecorator;
	import com.horidream.events.EventBus;
	import com.horidream.events.HoriEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	
	public class YoyoMovieClip extends MovieClipDecorator
	{
		private var startIndex:int;
		private var endIndex:int;
		private var yoyo:Boolean;
		public function YoyoMovieClip(decoratedMovieClip:MovieClip)
		{
			super(decoratedMovieClip);
		}
		public function autoPlay(startIndex:int,endIndex:int,yoyo:Boolean = true):void {
			stop();
			this.startIndex = Math.max(1,Math.min(startIndex,decoratedMovieClip.totalFrames));
			this.endIndex = Math.max(1,Math.min(endIndex,decoratedMovieClip.totalFrames));
			this.yoyo = yoyo;
			if(startIndex>endIndex){
				backwardPlayFromTo(startIndex,endIndex);
			}else{
				forwardPlayFromTo(startIndex,endIndex);
			}
			if(yoyo){
				this.addEventListener(HoriEvent.MOVIE_COMPLETE,onHoriMovieComplete);
			}
		}

		private function onHoriMovieComplete(event:HoriEvent):void
		{
			var temp:int = startIndex;
			startIndex = endIndex;
			endIndex = temp;
			this.removeEventListener(HoriEvent.MOVIE_COMPLETE,onHoriMovieComplete);
			autoPlay(startIndex,endIndex,yoyo);
		}
		public function backwardPlayFromTo(startIndex:int,endIndex:int):void {
			stop();
			this.startIndex = Math.max(1,Math.min(startIndex,decoratedMovieClip.totalFrames));
			this.endIndex = Math.max(1,Math.min(endIndex,decoratedMovieClip.totalFrames));
			if(startIndex <= endIndex){
				return;
			}else{
				gotoAndStop(startIndex);
				decoratedMovieClip.addEventListener(Event.ENTER_FRAME,onBackwardEnterFrame);
			}
		}
		public function forwardPlayFromTo(startIndex:int,endIndex:int):void {
			stop();
			this.startIndex = Math.max(1,Math.min(startIndex,decoratedMovieClip.totalFrames));
			this.endIndex = Math.max(1,Math.min(endIndex,decoratedMovieClip.totalFrames));
			if(startIndex >= endIndex){
				return;
			}else{
				gotoAndStop(startIndex);
				decoratedMovieClip.addEventListener(Event.ENTER_FRAME,onForwardEnterFrame);
			}
		}
		public function forwardPlayFrom(startIndex:int):void{
			forwardPlayFromTo(startIndex,decoratedMovieClip.totalFrames);
		}
		public function forwardPlayTo(endIndex:int):void{
			forwardPlayFromTo(decoratedMovieClip.currentFrame,endIndex);
		}
		

		



		
		public function backwardPlayFrom(startIndex:int):void {
			backwardPlayFromTo(startIndex,1);
		}
		public function backwardPlayTo(endIndex:int):void{
			backwardPlayFromTo(decoratedMovieClip.currentFrame,endIndex);
		}
		public function backwardPlay():void{
			backwardPlayFromTo(decoratedMovieClip.currentFrame,1);
		}
		private function onForwardEnterFrame(event:Event):void
		{
			if(decoratedMovieClip.currentFrame<endIndex){
				decoratedMovieClip.gotoAndStop(decoratedMovieClip.currentFrame+1);
			}else{
				removeListener();
				dispatchEvent(new HoriEvent(HoriEvent.MOVIE_COMPLETE,[startIndex,endIndex]));
			}
		}
		private function onBackwardEnterFrame(event:Event):void
		{
			if(decoratedMovieClip.currentFrame>endIndex){
				decoratedMovieClip.gotoAndStop(decoratedMovieClip.currentFrame-1);
			}else{
				removeListener();
				dispatchEvent(new HoriEvent(HoriEvent.MOVIE_COMPLETE,[startIndex,endIndex]));
			}
		}
		public override function play():void
		{
			forwardPlayFromTo(decoratedMovieClip.currentFrame,decoratedMovieClip.totalFrames);
		}
		public override function stop():void
		{
			removeListener();
			decoratedMovieClip.stop();
		}
		

		public override function gotoAndStop(frame:Object, scene:String=null):void
		{
			stop();
			decoratedMovieClip.gotoAndStop(frame,scene);
		}


		private function removeListener():void
		{
			if(decoratedMovieClip.hasEventListener(Event.ENTER_FRAME)){
				decoratedMovieClip.removeEventListener(Event.ENTER_FRAME,onForwardEnterFrame);
			}
			if(decoratedMovieClip.hasEventListener(Event.ENTER_FRAME)){
				decoratedMovieClip.removeEventListener(Event.ENTER_FRAME,onBackwardEnterFrame);
			}
		}


		



		
	}
}