package com.horidream.core
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created May 21, 2010 
	 */
	public class MovieClipDecorator extends MovieClip
	{
		public var decoratedMovieClip:MovieClip;
		public function MovieClipDecorator(decoratedMovieClip:MovieClip)
		{
			this.decoratedMovieClip = decoratedMovieClip;
			if(decoratedMovieClip.parent && decoratedMovieClip.parent != this){
				var index:int = decoratedMovieClip.parent.getChildIndex(decoratedMovieClip);
				decoratedMovieClip.parent.addChildAt(this,index);
			}
			addChild(decoratedMovieClip);
		}
		public function get origin():MovieClip{
			var temp_mc:MovieClip = this;
			while(temp_mc.decoratedMovieClip){
				temp_mc = temp_mc.decoratedMovieClip;
			}
			return temp_mc;
		}
				

//		public override function get currentFrameLabel():String
//		{
//			return decoratedMovieClip.currentFrameLabel;
//		}
		
		public override function get currentLabel():String
		{
			return decoratedMovieClip.currentLabel;
		}
		
		public override function get currentLabels():Array
		{
			return decoratedMovieClip.currentLabels;
		}
		
		public override function get currentScene():Scene
		{
			return decoratedMovieClip.currentScene;
		}
		
		public override function get framesLoaded():int
		{
			return decoratedMovieClip.framesLoaded;
		}
		
		public override function gotoAndPlay(frame:Object, scene:String=null):void
		{
			decoratedMovieClip.gotoAndPlay(frame,scene);
		}
		

		public override function play():void
		{
			decoratedMovieClip.play();
		}

		public override function stop():void
		{
			decoratedMovieClip.stop();
		}


		public override function gotoAndStop(frame:Object, scene:String=null):void
		{
			decoratedMovieClip.gotoAndStop(frame,scene);
		}
		
		public override function nextFrame():void
		{
			decoratedMovieClip.nextFrame();
		}
		
		public override function nextScene():void
		{
			decoratedMovieClip.nextScene();
		}
		
		public override function prevFrame():void
		{
			decoratedMovieClip.prevFrame();
		}
		
		public override function prevScene():void
		{
			decoratedMovieClip.prevScene();
		}
		
		public override function get scenes():Array
		{
			return decoratedMovieClip.scenes;
		}
		
		
		
		public override function get currentFrame():int
		{
			return decoratedMovieClip.currentFrame;
		}
		
		public override function get totalFrames():int
		{
			return decoratedMovieClip.totalFrames;
		}
	}
}