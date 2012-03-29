package com.horidream.util
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Feb 10, 2011 12:08:27 AM
	 */
	public class StagePin
	{
		public static var stage:Stage;
		private static var targetDictionary:Dictionary = new Dictionary();
		public static function add(target:DisplayObject,pattern:int,offset:Point = null,auto:Boolean = true):void{
			stage = stage || Hori.stage;
			if(!stage){
				throw new Error("before pin an object to stage, you should first use 'Hori.initialize(stage);' to initialize stage, or set the StagePin.stage property. ");
			}
			var offsetPoint:Point = offset || new Point();
			targetDictionary[target] = [pattern,offsetPoint,auto];
			if(auto){
				QuickSetter.autoAlign(target,stage,pattern,offsetPoint);
			}else{
				QuickSetter.align(target,stage,pattern,offsetPoint);
			}
			Hori.stage.addEventListener(Event.RESIZE,onResize);
		}
		public static function remove(target:DisplayObject):void{
			if(targetDictionary[target])
				delete targetDictionary[target];
		}
		public static function removeAll():void{
			for(var key:* in targetDictionary)
			{
				delete targetDictionary[key];
			}
		}
		private static function onResize(e:Event):void
		{
			for(var key:* in targetDictionary)
			{
				var arr:Array = targetDictionary[key] as Array;
				if(arr[2]){
					QuickSetter.autoAlign(key,stage,arr[0],arr[1]);
				}else{
					QuickSetter.align(key,stage,arr[0],arr[1]);
					
				}
			}
		}
	}
}