package com.horidream.util
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.SelfLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.horidream.signals.LoadingSignal;
	import com.horidream.vo.ProgressVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 29, 2010 10:12:59 AM
	 */
	public class LibraryManager
	{
		protected static var mainLoader:LoaderMax = new LoaderMax({onProgress:mainProgressHandler,onComplete:mainCompleteHandler});
		
		protected static var instances:Dictionary;
		protected static var loadedULRs:Array = [];
		protected static var loadingURLs:Array = [];
		private var subLoader:LoaderMax;
		
		private var urls:Array;
		private var prefix:String;
		private var onCompleteHandler:Function;
		private var args:Array;
		public static var itemLoaded:Signal = new Signal(LoaderCore);
		public static var totalProgress:LoadingSignal = new LoadingSignal();
		public var progress:LoadingSignal = new LoadingSignal();
		private static var unHandledHandlers:Array = [];
		public function LibraryManager(urls:Array,prefix:String ,onCompleteHandler:Function,arguments:Array)
		{
			this.urls = urls;
			this.prefix = prefix;
			this.onCompleteHandler = onCompleteHandler;
			this.args = arguments;
		}
		public static function request(url:*,prefix:String = null,onCompleteHandler:Function = null,...args):LibraryManager
		{
			
			mainLoader.pause();
			var urls:Array;
			if(url is Array){
				urls = url.slice();
			}else if(url is String){
				urls = [url];
			}else{
				throw new Error("url参数不正确，应为Array或String类型");
			}
			if(prefix){
				if(prefix.substr(-1,1) != "/"){
					prefix = prefix + '/';
				}
				for (var i:int = urls.length;i--;){
					urls[i] = prefix + urls[i];
				}
			}
			var orignalURLs:Array = urls.slice();
//			trace("loaded:["+loadedULRs+"]");
			ArrayUtil.cullItems(urls,loadedULRs);
			if(urls.length >0){
				ArrayUtil.cullItems(urls,loadingURLs);
//				trace("original:["+orignalURLs+"],urls:["+urls+"]","loading:["+loadingURLs+"]");
				if(urls.length>0){
					var instance:LibraryManager = new LibraryManager(urls,null,onCompleteHandler,args);
					instance.startLoading();
					return instance;
				}else{
					if(onCompleteHandler != null){
						if(!isOverride(onCompleteHandler)){
							unHandledHandlers.push([orignalURLs,onCompleteHandler,args]);
						}
					}
					mainLoader.paused = false;
					
					return null;
				}
			}else{
				if(onCompleteHandler != null){
					onCompleteHandler.apply(null,args);
				}
				
				mainLoader.paused = false;
				if(mainLoader.bytesLoaded == mainLoader.bytesTotal)
				{
					totalProgress.dispatch(new ProgressVO(100,true));
				}
				return null;
			}
		}

		private static function isOverride(onCompleteHandler:Function):Boolean
		{
			for each(var arr:Array in unHandledHandlers){
				if(arr[1] == onCompleteHandler){
					return true;
				}
			}
			return false;
		}
//		public static function getSharedEvents(defination:String):EventDispatcher{
//			var loader:SWFLoader = mainLoader.getLoader(defination);
//			return loader.sharedEvents;
//		}
		public function getClass(defination:String):Class{
			var allLoaders:Array = subLoader.getChildren(true,true);
			for(var i:int = 0; i < allLoaders.length; i++)
			{
				var item:SWFLoader = allLoaders[i] as SWFLoader;
				var tempClass:Class = null;
				if(item){
					tempClass = item.getClass(defination) as Class;
					if(tempClass){
						return tempClass;
					}
				}
			}
			return null;
		}
		public static function getClass(defination:String):Class{
			var allLoaders:Array = mainLoader.getChildren(true,true);
			for(var i:int = 0; i < allLoaders.length; i++)
			{
				var item:SWFLoader = allLoaders[i] as SWFLoader;
				var tempClass:Class = null;
				if(item){
					tempClass = item.getClass(defination) as Class;
					if(tempClass){
						return tempClass;
					}
				}
			}
			return null;
		}
		public static function getImage(defination:String):Bitmap{
			var loader:ImageLoader = mainLoader.getLoader(defination) as ImageLoader;
			
			if(loader){
				return Cast.bitmap(loader.rawContent);
			}else{
				return null;
			}
		}
		public static function getVideo(defination:String):VideoLoader{
			var loader:VideoLoader = mainLoader.getLoader(defination) as VideoLoader;
			if(loader){
				return loader;
			}else{
				return null;
			}
		}
		public static function getMP3(defination:String):MP3Loader{
			var loader:MP3Loader = mainLoader.getLoader(defination) as MP3Loader;
			if(loader){
				return loader;
			}else{
				return null;
			}
		}
		public static function getMovie(defination:String):MovieClip{
			var loader:SWFLoader = mainLoader.getLoader(defination) as SWFLoader;
			if(loader){
				return loader.rawContent as MovieClip;
			}else{
				return null;
			}
		}
		private static function mainProgressHandler(e:LoaderEvent):void{
			var loader:LoaderCore = e.currentTarget as LoaderCore;
			totalProgress.dispatch(new ProgressVO(int(loader.progress*100),false));
		}
		private static function mainCompleteHandler(e:LoaderEvent):void{
//			for each(var pair:Array in unHandledHandlers){
//				(pair[0] as Function).apply(null,pair[1]);
//			}
//			unHandledHandlers = [];
			totalProgress.dispatch(new ProgressVO(100,true));
		}
		private function startLoading():void{
			LoaderMax.activate([ImageLoader, VideoLoader, SWFLoader, MP3Loader]);
			subLoader = LoaderMax.parse(urls, {onProgress:subProgressHandler,onComplete:subCompleteHandler, autoPlay:false},{onComplete:onItemLoaded,autoPlay:false}) as LoaderMax;
			
			for each(var loader:LoaderCore in subLoader.getChildren())
			{
				if(loader is MP3Loader)
				{
					MP3Loader(loader).addEventListener(LoaderEvent.COMPLETE,onSoundLoaded);
				}
				if(loader is VideoLoader)
				{
					VideoLoader(loader).addEventListener(LoaderEvent.COMPLETE,onVideoLoaded);
				}
				if(loader is SWFLoader)
				{
					SWFLoader(loader).addEventListener(LoaderEvent.COMPLETE,onMovieLoaded);
				}
			}
			
			if(prefix)
				subLoader.prependURLs(prefix);
			loadingURLs = loadingURLs.concat(urls);
			mainLoader.append(subLoader);
			mainLoader.load();
			mainLoader.paused = false;
		}
		private function onItemLoaded(e:LoaderEvent):void{
			itemLoaded.dispatch(LoaderCore(e.currentTarget))
		}
		protected function onMovieLoaded(e:LoaderEvent):void
		{
			if(e.target.rawContent && e.target.rawContent.hasOwnProperty("stop"))
			{
				e.target.rawContent.stop();
			}
			
		}
		
		private function onVideoLoaded(e:LoaderEvent):void
		{
			e.target.pauseVideo();
		}

		private function onSoundLoaded(e:LoaderEvent):void
		{
			e.target.pauseSound();
		}
		
		private function subCompleteHandler(e:LoaderEvent):void{
			mainLoader.paused = true;
			ArrayUtil.cullItems(loadingURLs,urls);
			loadedULRs = loadedULRs.concat(urls);
			if(onCompleteHandler!=null){
				onCompleteHandler.apply(null,args);
			}
			dealUnHandledHandlers()
			mainLoader.paused = false;
			progress.dispatch(new ProgressVO(100,true));
		}
		private function dealUnHandledHandlers():void
		{
			var len:int = unHandledHandlers.length;
			for (var i:int = (len-1);i>=0;i--){
				if(ArrayUtil.contain(loadedULRs,unHandledHandlers[i][0] as Array)){
					(unHandledHandlers[i][1]  as Function).apply(null,unHandledHandlers[i][2]);
					unHandledHandlers.splice(i,1);
				}
			}
		}
		private function subProgressHandler(e:LoaderEvent):void
		{
			var loader:LoaderCore = e.currentTarget as LoaderCore;
			progress.dispatch(new ProgressVO(int(loader.progress*100),false));
		}
	}
}