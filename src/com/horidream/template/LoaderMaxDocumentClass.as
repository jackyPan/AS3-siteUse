package com.horidream.template
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 29, 2011
	 */
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SelfLoader;
	import com.horidream.interfaces.IProgressBar;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	
	public class LoaderMaxDocumentClass extends MovieClip
	{
		protected var progressBar:IProgressBar;
		protected var urls:Array;
		protected var mainName:String;
		protected var progress:DisplayObject;
		private var loader:LoaderMax;
		/**
		 * 一个可以自加载的文档类模板，在构造函数中需实例化progressBar和指定mainName，
		 * 编译参数为 -locale en_US -frames.frame 2 Main
		 * 
		 */
		public function LoaderMaxDocumentClass()
		{
			if(progressBar && (progressBar is DisplayObject))
			{
				progress = progressBar as DisplayObject
				addChild(progress);
				onResize(null);
				stage.addEventListener(Event.RESIZE,onResize);
			}
			
			if(urls){
				loader = LoaderMax.parse(urls,{onProgress:progressHandler, onComplete:completeHandler},{autoPlay:false});
			}else{
				loader = new LoaderMax({onProgress:progressHandler, onComplete:completeHandler});
			}
			loader.prepend(new SelfLoader(this));
			loader.load();
			this.stop();
			
		}

		protected function onResize(e:Event):void
		{
			
		}
		protected function completeHandler(event:LoaderEvent):void
		{
			if(progress && progress.parent)
				progress.parent.removeChild(progress);
			this.gotoAndStop(2);
			init();
		}
		
		protected function progressHandler(event:LoaderEvent):void
		{
			var percent:int = Math.ceil(loader.progress*100);
			progressBar && progressBar.showProgress(percent);
		}
		protected function init():void {
			if(!mainName){
				throw new Error("必须在构造函数中指定mainName的值为有效的类名");
			}
			var main:Class = getDefinitionByName(mainName) as Class;
			if(!main){
				throw new Error("无法取得mainName指定的类，或该类为空");
			}
			addChildAt(new main(),0);
			stage.removeEventListener(Event.RESIZE,onResize);
		}
	}
}