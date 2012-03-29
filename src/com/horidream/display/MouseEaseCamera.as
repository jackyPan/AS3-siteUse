package com.horidream.display
{
	import com.horidream.util.RecUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 10, 2011
	 */
	
	public class MouseEaseCamera
	{
		private var _camera:HoriCamera;
		private var mouseCoordinate:DisplayObject;
		private var mouseRec:Rectangle;
		private var xOffset:Number;
		private var yOffset:Number;
		private var w:Number;
		private var h:Number;
		
		private var _active:Boolean = false;
		
		public function MouseEaseCamera(mouseCoordinate:DisplayObject,mouseRec:Rectangle = null,xOffset:Number = 75,yOffset:Number = 75)
		{
			_camera = new HoriCamera();
			this.mouseCoordinate = mouseCoordinate;
			w = mouseRec.width || mouseCoordinate.width;
			h = mouseRec.height || mouseCoordinate.height;
			this.mouseRec = mouseRec || new Rectangle(0,0,w,h);
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			
			start();
			
		}
		

		public function get active():Boolean
		{
			return _active;
		}

		public function start():void
		{
			if(mouseCoordinate.stage){
				Hori.enterFrame.add(loop);
				mouseCoordinate.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			}else{
				mouseCoordinate.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
			_active = true;
			
		}

		public function get camera():HoriCamera
		{
			return _camera;
		}

		private function onAddedToStage(e:Event):void
		{
			Hori.enterFrame.add(loop);
			mouseCoordinate.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			mouseCoordinate.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
		}

		private function onRemovedFromStage(e:Event):void
		{
			Hori.enterFrame.remove(loop);
			mouseCoordinate.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			mouseCoordinate.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
		}
		
		private function loop():void
		{
			if(xOffset != 0)
			{
				var disX:Number = (w/2-mouseCoordinate.mouseX)/w*xOffset;
				camera.x +=	(disX-camera.x)*.1;
			}
			if(yOffset !=0)
			{
				var disY:Number = (h/2-mouseCoordinate.mouseY)/h*yOffset;
				camera.y += (disY-camera.y)*.1;
			}
		}
		
		public function destroy():void
		{
			camera.destroy();
			stop();
		}
		public function stop():void
		{
			mouseCoordinate.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			mouseCoordinate.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			Hori.enterFrame.remove(loop);
			_active = false;
		}
		public function reset():void
		{
			camera.reset();
		}
		public function addTarget(target:DisplayObject,distance:Number = 100):DisplayObject
		{
			camera.addTarget(target,distance);
			return target;
		}
		
		public function addMultiTarget(targets:Array,distances:Array):Array
		{
			var len:int = targets.length;
			for(var i:int = 0;i< len;i++)
			{
				camera.addTarget(targets[i],distances[i] as Number);
			}
			return targets;
		}
		public static function createMouseEaseCamera(targets:Array,distances:Array,mouseCoordinate:DisplayObject,mouseRec:Rectangle = null,xOffset:Number = 75,yOffset:Number = 75):MouseEaseCamera
		{
			var mouseEaseCamera:MouseEaseCamera = new MouseEaseCamera(mouseCoordinate,mouseRec,xOffset,yOffset);
			mouseEaseCamera.addMultiTarget(targets,distances);
			return mouseEaseCamera;
		}
	}
}