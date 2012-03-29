package com.horidream.fp10
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Mar 25, 2011
	 */
	public class LookAt3D
	{
		private static var list:Array = [];
		private static var coordinateSpaceDic:Dictionary = new Dictionary();
		private static var eventDispatcher:Shape;
		public static var mouseZPos:Number = -100;
		public function LookAt3D(target:DisplayObject,coordinateSpace:DisplayObjectContainer)
		{
			if((list.indexOf(target) == -1) && coordinateSpace){
				if(!eventDispatcher){
					eventDispatcher = new Shape();
					eventDispatcher.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
				list.push(target);
				coordinateSpaceDic[target] = coordinateSpace;
			}
		}
		public static function add(target:DisplayObject,zPos:Number = 0,coordinateSpace:DisplayObjectContainer = null):LookAt3D
		{
			target.z = zPos;
			return new LookAt3D(target,coordinateSpace || Hori.stage || target.stage); 
		}
		public static function remove(target:DisplayObject):void
		{
			var index:int = list.indexOf(target);
			if(index != -1){
				var m:Matrix3D = target.transform.matrix3D;
				target.transform.matrix3D = null;
				target.transform.matrix = new Matrix(1,0,0,1,m.position.x,m.position.y);
//				target.transform.matrix3D.pointAt(new Vector3D(target.x,target.y,0),new Vector3D(0,-.000001,-1));
				list.splice(index,1);
				delete coordinateSpaceDic[target];
				
			}
		}
		public static function removeAll():void
		{
			for each(var target:DisplayObject in list)
			{
				remove(target);
			}
		}
		private static function onEnterFrame(e:Event):void
		{
			var len:int = list.length;
			if(len<1){
				eventDispatcher.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				eventDispatcher = null;
				return;
			}
			for(var i:int = 0;i<len;i++)
			{
				var target:DisplayObject = list[i] as DisplayObject;
				var coordinateSpace:DisplayObjectContainer = coordinateSpaceDic[target];
				var matrix:Matrix3D = target.transform.matrix3D.clone();
				matrix.pointAt(new Vector3D(coordinateSpace.mouseX,coordinateSpace.mouseY,mouseZPos),new Vector3D(0,-.000001,-1));
				target.transform.matrix3D.interpolateTo(matrix,.1);
//				target.transform.matrix3D.pointAt(new Vector3D(coordinateSpace.mouseX,coordinateSpace.mouseY,mouseZPos),new Vector3D(0,-.000001,-1));
			}
		}
	}
}