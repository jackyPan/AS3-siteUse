package com.horidream.core
{
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Dec 15, 2010
	 */
	import com.horidream.util.LibraryManager;
	import com.horidream.util.QuickSetter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class LoadableSprite extends Sprite
	{
		protected var url:*;
		public var initialized:Boolean = false;
		public var loaded:Signal = new Signal();
		protected var delayedFuncs:Array = [];
		protected var classMap:Array = new Array();
		private var _mapedClass:Dictionary = new Dictionary();
		public function LoadableSprite(url:* = null,prefix:String = null,classMap:Array = null)
		{
			this.url = url;
			this.classMap = classMap;
			if(url){
				LibraryManager.request(url,prefix,init);
			}else{
				init();
			}
		}


		public function mapedClass(key:String):Class
		{
			return _mapedClass[key];
		}
		public function mapedInstance(key:String,...args):*
		{
			return QuickSetter.instantiate(mapedClass(key),args);
		}
		public function getMapedInstanceAt(index:int,...args):*
		{
			var key:String = classMap[index];
			return QuickSetter.instantiate(mapedClass(key),args);
		}
		private function init():void
		{
			initialized = true;
			if(classMap){
				for(var i:int = classMap.length;i--;){
					_mapedClass[classMap[i]] = LibraryManager.getClass(classMap[i]);
				}
			}
			while(delayedFuncs.length>0){
				var currentPair:Array = delayedFuncs.shift();
				if(currentPair[1]){
					(currentPair[0] as Function).apply(null,currentPair[1]);
				}else{
					(currentPair[0] as Function).call();
				}
			}
			loaded.dispatch();
		}


		protected function isSafeCall(args:Array,name:String = null):Boolean
		{
			if(initialized){
				return true;
			}else{
				delayedFuncs.push([args.callee,args,name]);
				return false;
			}
		}
	}
}