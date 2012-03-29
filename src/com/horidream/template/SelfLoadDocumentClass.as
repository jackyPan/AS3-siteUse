package com.horidream.template
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 20, 2011
	 */
	import com.horidream.interfaces.IProgressBar;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	
	public class SelfLoadDocumentClass extends MovieClip
	{
		protected var progressBar:IProgressBar;
		protected var mainName:String;
		protected var mainInstace:DisplayObject;
		private var progress:DisplayObject;
		/**
		 * 一个可以自加载的文档类模板，在构造函数中需实例化progressBar和指定mainName，
		 * 编译参数为 -locale en_US -frames.frame 2 {mainName}
		 * 
		 */
		public function SelfLoadDocumentClass()
		{
			if(progressBar && (progressBar is DisplayObject))
			{
				progress = progressBar as DisplayObject
				addChild(progress);
			}
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE,onComplete);
			this.stop();
		}
		protected function onComplete(event:Event):void
		{
			if(progress && progress.parent)
				progress.parent.removeChild(progress);
			this.gotoAndStop(2);
			init();
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			var percent:int = int(event.bytesLoaded/event.bytesTotal*100);
			progressBar.showProgress(percent);
		}
		protected function init():void {
			if(!mainName){
				throw new Error("必须在构造函数中指定mainName的值为有效的类名");
			}
			var main:Class = ApplicationDomain.currentDomain.getDefinition(mainName) as Class;
			if(!main){
				throw new Error("无法取得mainName指定的类，或该类为空");
			}
			mainInstace = new main();
			addChild(mainInstace);
		}
	}
}