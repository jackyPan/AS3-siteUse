package com.horidream.display
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 1, 2011
	 */
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.horidream.util.FunctionCache;
	import com.horidream.util.LibraryManager;
	import com.horidream.util.QuickSetter;
	import com.horidream.vo.ProgressVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class SWFMovieDelegate extends Sprite
	{
		private var _urls:Array;
		private var _autoPlay:Boolean;
		private var isPlaying:Boolean = false;
		private var _isLoaded:Boolean = false;
		protected var _playList:Array;
		protected var startFromFrame:int = 1;
		protected var mc:MovieClip;
		public var playCompleteSignal:Signal = new Signal();
		public var progressSignal:Signal = new Signal(int);
		public var completeSignal:Signal = new Signal();
		public function SWFMovieDelegate(urls:Array,autoPlay:Boolean = false)
		{
			this._urls = urls || [];
			this._autoPlay = autoPlay;
			this._playList = this._urls.slice();
			LoaderMax.activate([SWFLoader]);
			if(autoPlay)
			{
				play();
			}
		}
		

		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}


		public function get playing():Boolean{
			return isPlaying;
		}
		
		protected function startQuerry():void
		{
			LibraryManager.totalProgress.add(onLoadProgress);
			LibraryManager.request(_urls);
			if(_playList[0]){
				var firstLoader:SWFLoader = (LoaderMax.getLoader(_playList[0]) as SWFLoader);
				firstLoader.prioritize(false);
				if(!mc || (mc && !mc.parent))
				{
					mc = new MovieClip();
					if(firstLoader.rawContent)
					{
						mc.addChild(firstLoader.rawContent);
					}else{
						mc.addChild(firstLoader.content);
					}
					addChild(mc);
				}
			}

			
		}
		
		
		private function onLoadProgress(vo:ProgressVO):void
		{
			if(vo.completed)
			{
				LibraryManager.totalProgress.remove(onLoadProgress);
				_isLoaded = true;
				if(FunctionCache.hasCachedFunction(this))
				{
					FunctionCache.execute(this);
				}else{
					if(isPlaying){
						play();
					}
				}
				completeSignal.dispatch();
				
			}else{
				progressSignal.dispatch(vo.progress);
			}
			
		}
		public function get totalFrames():int
		{
			if(!_isLoaded){
				return 0;
			}
			var list:Array = urls.slice();
			var frame:int = 0;
			var mc:MovieClip;
			while(list.length>0)
			{
				mc = LibraryManager.getMovie(list.shift());
				if(mc){
					frame += mc.totalFrames;
				}
			}
			return frame;
		}
		public function gotoAndPlay(frame:int):void
		{
			
			if(!_isLoaded){
				startQuerry();
				FunctionCache.addCache(this,arguments);
				return;
			}
			_playList = urls.slice();
			var currentFrame:int = 0;
			var lastFrame:int = 0;
			var url:String;
			var mc:MovieClip;
			while(_playList.length>0)
			{
				url = _playList.shift();
				mc = LibraryManager.getMovie(url);
				if(mc){
					currentFrame += mc.totalFrames;
				}
				if(currentFrame>frame)
				{
					_playList.unshift(url);
					startFromFrame = Math.min(totalFrames,frame - lastFrame);
					break;
				}
				lastFrame = currentFrame;
			}
			play();
			
		}
		public function gotoMovieAtFrame(index:int,frame:int):void
		{
			startFromFrame = frame;
			gotoMoiveAt(index);
		}
		public function play():void
		{
			this.isPlaying = true;
			if(_isLoaded)
			{
				
				if(_playList.length>0){
					nextMovie();
					
				}else{
					isPlaying = false;
					playCompleteSignal.dispatch();
				}
			}else{
				startQuerry();
			}
			
		}

		public function nextMovie():void
		{
			if(!_isLoaded){
				FunctionCache.addCache(this,arguments);
				startQuerry();
				isPlaying = true;
				return;
			}
			if(_playList.length>0){
				mc && mc.stop();
				QuickSetter.removeSelf(mc);
				//			if(mc)
				//				ShowManager.showOut(mc);
				mc = LibraryManager.getMovie(_playList.shift());
				if(mc){
					mc.gotoAndPlay(startFromFrame);
					startFromFrame = 1;
					mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}else{
					nextMovie();
					return;
				}
				addChild(mc);
				//			mc.alpha = 1;
				//			ShowManager.showIn(mc);
			}
		}


		public function stop():void
		{
			if(mc)
			{
				mc.stop();
			}
			this.isPlaying = false;
		}
		public function restart():void
		{
			gotoMoiveAt(0);
		}
		public function gotoMovie(url:String):void
		{
			var index:int = this.urls.indexOf(url);
			gotoMoiveAt(index);
		}
		public function gotoMoiveAt(index:int):void
		{
			if(!_isLoaded){
				isPlaying = true;
				FunctionCache.addCache(this,arguments);
				startQuerry();
				return;
			}
			_playList = this.urls.slice();
			while(index>0)
			{
				if(_playList.length>0){
					_playList.shift();
				}
				index --;
			}
			play();
		}
		private function onEnterFrame(e:Event):void
		{
			if(MovieClip(e.currentTarget).currentFrame == MovieClip(e.currentTarget).totalFrames)
			{
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				play();
			}
		}


		public function get urls():Array
		{
			return _urls;
		}

		public function set urls(value:Array):void
		{
			_urls = value;
			_playList = _urls.slice();
			_isLoaded = false;
			stop();
			if(autoPlay)
			{
				gotoMoiveAt(0);
			}
		}
		public function get playList():Array
		{
			return _playList;
		}


		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}


	}
}