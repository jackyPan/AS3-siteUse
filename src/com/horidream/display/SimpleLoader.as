package com.horidream.display
{
	import com.horidream.interfaces.IProgressBar;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class SimpleLoader extends EventDispatcher
	{

		
		private static var loaderArr:Array = [];
		public static function load(url:String,progressBar:IProgressBar = null,container:DisplayObjectContainer = null,autoHideProgressBar:Boolean = true):Loader
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.load(new URLRequest(url));
			
			loaderArr.push({"loader":loader,"progressBar":progressBar,"container":container,"autoHideProgressBar":autoHideProgressBar});
			
			return loader;
		}

		private static function onComplete(event:Event):void
		{
			var index:int = getIndex(event.target.loader);
			if(index == -1){
				return;
			}
			if(loaderArr[index].container != null){
				loaderArr[index].container.addChild(loaderArr[index].loader);
			}
			var tempBar:DisplayObject = loaderArr[index].progressBar as DisplayObject;
			if(loaderArr[index].autoHideProgressBar && tempBar && tempBar.parent){
				tempBar.parent.removeChild(tempBar);
			}
			loaderArr.splice(index,1);
		}

		private static function onProgress(event:ProgressEvent):void
		{
			var index:int = getIndex(event.target.loader);
			if(index == -1){
				return;
			}
			var percent:int = int(event.bytesLoaded/event.bytesTotal*100);
			if(loaderArr[index] && loaderArr[index].progressBar)
				(loaderArr[index].progressBar as IProgressBar).showProgress(percent);
			
		}
		private static function getIndex(loader:Loader):int{
			for (var i:int = 0; i < loaderArr.length; i++) {
				var element:Object = loaderArr[i] as Object;
				if(element.loader == loader){
					return i;
				}
			}
			return -1;
		}


	}
}