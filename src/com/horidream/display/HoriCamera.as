package com.horidream.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created May 28, 2010 
	 */
	public class HoriCamera
	{
		public static var amplifier:Number = 20;
		private var regularDistance:Number = 100;
		private var targetsArr:Array = [];
		private var distanceArr:Array = [];
		private var positionArr:Array = [];
		public var container:DisplayObjectContainer;
		private var _destroyed:Boolean = false;
		
//		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		private var mainVersion:int;
		public function HoriCamera(target:DisplayObject=null,distance:Number = 100,versionCheck:Boolean = false){
			if(versionCheck){
				var versionString:String = (Capabilities.version.split(" ")[1] as String);
				mainVersion = int(versionString.split(",")[0]);
			}else{
				mainVersion = 9;
			}
			if(target){
				targetsArr.push(target);
				distanceArr.push(distance);
				positionArr.push([target.x,target.y,mainVersion>=10?target.z:0]);
			}
		}
		

		public function get destroyed():Boolean
		{
			return _destroyed;
		}

		public static function quickCamera(targets:Array,distances:Array,container:DisplayObjectContainer,xOffset:Number = 75,yOffset:Number = 75,rec:Rectangle = null):HoriCamera{
			var camera:HoriCamera = new HoriCamera();
			var w:Number = rec.width || container.width;
			var h:Number = rec.height || container.height;
			camera.container = container;
			if(container is Stage){
				w = Stage(container).stageWidth;
				h = Stage(container).stageHeight;
			}
			for (var i:int = 0; i < targets.length; i++)
			{
				var element:DisplayObject = targets[i] as DisplayObject;
				if(element){
					camera.addTarget(element,distances[i]);
				}
			}
			container.addEventListener(Event.ENTER_FRAME,loop);
			return camera;
			function loop(e:Event):void{
				if(camera.destroyed){
					container.removeEventListener(Event.ENTER_FRAME,arguments.callee);
				}
				var disX:Number = (w/2-container.mouseX)/w*xOffset;
				var disY:Number = (h/2-container.mouseY)/h*yOffset;
				camera.x +=	(disX-camera.x)*.1;
				camera.y += (disY-camera.y)*.1;
			}
		}
		public function destroy():void{
			targetsArr = [];
			positionArr = [];
			distanceArr = [];
			_destroyed = true;
		}
		
		public function addTarget(target:Object,distance:Number = 100):void
		{
			_destroyed = false;
			var index:int = targetsArr.indexOf(target);
			var validDistance:Number = (distance<5)?5:distance;
			if(index != -1){
				distanceArr[index] = validDistance;
			}else{
				targetsArr.push(target);
				distanceArr.push(validDistance);
				positionArr.push([target.x,target.y,mainVersion>=10?target.z:0]);
			}
			
		}

		public function reset():void {
			x = y = z = 0;
		}
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			for (var i:int = 0; i < targetsArr.length; i++) {
				var element:Object = targetsArr[i];
				element.x = positionArr[i][0] - _x * regularDistance/distanceArr[i];
			}
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			for (var i:int = 0; i < targetsArr.length; i++) {
				var element:Object = targetsArr[i] ;
				element.y = positionArr[i][1] - _y * regularDistance/distanceArr[i];
			}
		}
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(value:Number):void
		{
			_z = value;
			for (var i:int = 0; i < targetsArr.length; i++) {
				var element:DisplayObject = targetsArr[i] as DisplayObject;
				if(mainVersion>=10)
				element.z = -_z * regularDistance/distanceArr[i]*amplifier;
			}
		}

	}
}