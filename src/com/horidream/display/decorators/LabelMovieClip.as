package com.horidream.display.decorators
{
	import com.horidream.core.MovieClipDecorator;
	import com.horidream.events.HoriEvent;
	
	import flash.display.MovieClip;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created Jun 1, 2010 
	 */
	public class LabelMovieClip extends MovieClipDecorator
	{
		public var currentIndex:int = -1;
		private var nameArr:Array = [];
		private var startIndexArr:Array = [];
		private var endIndexArr:Array = [];
		public function LabelMovieClip(decoratedMovieClip:MovieClip)
		{
			super(decoratedMovieClip);
		}
		public function setLabel(name:String,startIndex:uint,endIndex:uint):void{
			var start:int = startIndex;
			if(start<1){
				start = 1;
			}else if(start>decoratedMovieClip.totalFrames){
				start = decoratedMovieClip.totalFrames;
			}
			var end:int = endIndex;
			if(end<1){
				end = 1;
			}else if(end>decoratedMovieClip.totalFrames){
				end = decoratedMovieClip.totalFrames;
			}
			var index:int = nameArr.indexOf(name);
			if(index != -1){
				startIndex[index] = start;
				endIndexArr[index] = end;
			}else{
				nameArr.push(name);
				startIndexArr.push(start);
				endIndexArr.push(end);
			}
		}
		public function playLabel(name:String,loop:Boolean = true):void{
			var index:int = nameArr.indexOf(name);
			currentIndex = index;
			if(index == -1){
				super.play();
			}else{
				decoratedMovieClip = new YoyoMovieClip(decoratedMovieClip);
				if(startIndexArr[index]<endIndexArr[index]){
					if(loop)
						decoratedMovieClip.addEventListener(HoriEvent.MOVIE_COMPLETE,onHoriMovieComplete);
					decoratedMovieClip.forwardPlayFromTo(startIndexArr[index],endIndexArr[index]);
					
				}else if(startIndexArr[index]>endIndexArr[index]){
					if(loop)
						decoratedMovieClip.addEventListener(HoriEvent.MOVIE_COMPLETE,onHoriMovieComplete);
					decoratedMovieClip.backwardPlayFromTo(startIndexArr[index],endIndexArr[index]);
				}else{
					decoratedMovieClip.gotoAndStop(startIndexArr[index]);
				}
			}
		}
		public function get currentMovieLabel():String{
			return nameArr[currentIndex];
		}
		private function onHoriMovieComplete(event:HoriEvent):void
		{
			var startAndEndArr:Array = event.params as Array;
			if(startAndEndArr[0]<startAndEndArr[1]){
				decoratedMovieClip.forwardPlayFromTo(startAndEndArr[0],startAndEndArr[1]);
			}else if(startAndEndArr[0]>startAndEndArr[1]){
				decoratedMovieClip.backwardPlayFromTo(startAndEndArr[0],startAndEndArr[1]);
				
			}else{
				decoratedMovieClip.gotoAndStop(startAndEndArr[0]);
			}
		}
	}
}