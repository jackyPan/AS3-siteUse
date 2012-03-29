package com.horidream.display
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 14, 2011
	 */
	public class SWFMovieComposition extends Sprite
	{
		private var _urls:Array;
		private var _autoPlay:Boolean;
		private var _isPlaying:Boolean = false;
		private var swfMovie:SWFMovieDelegate;
		public function SWFMovieComposition(urls:Array, autoPlay:Boolean=false)
		{
			this._urls = urls;
			this._autoPlay = autoPlay;
			
			swfMovie.playCompleteSignal.remove(onPlayItemComplete);
			swfMovie = new SWFMovieDelegate(null,autoPlay);
			swfMovie.playCompleteSignal.add(onPlayItemComplete);
			
			if(autoPlay)
			{
				play();
			}
		}
		


		public function play():void
		{
			var currentPlayItem:String;
			if(_urls && _urls.length>0)
			{
				_isPlaying = true;
				currentPlayItem = _urls.shift();
				swfMovie.urls = [currentPlayItem];
			}else{
				_isPlaying = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onPlayItemComplete():void
		{
			play();
			
		}
		
		public function get urls():Array
		{
			return _urls;
		}

		public function set urls(value:Array):void
		{
			_urls = value;
			if(autoPlay)
			{
				play();
			}
		}
		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}
		
		public function addSWFMovieByURL(url:String):void
		{
			_urls.push(url);
			if((!_isPlaying) && _autoPlay)
			{
				play();
			}
			
		}
	}
}