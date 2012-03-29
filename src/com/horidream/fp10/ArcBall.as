/*
Copyright (c) 2009 Ralph Hauwert

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.horidream.fp10
{
	import __AS3__.vec.Vector;
	
	import com.horidream.util.QuaternionUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	public class ArcBall
	{
		public var radius:Number;
		public var useRadius:Boolean;
		
		private var radiusVector:Vector3D;
		private var startVector:Vector3D;
		private var startQuat:Vector3D;
		private var dragVector:Vector3D;
		private var dragQuat:Vector3D;
		private var newQuat:Vector3D;
		
		private var _enabled:Boolean = true;
		private var _displayObject:InteractiveObject;
		private var _stage:Stage;
		private var _radius:Number;
		
		private var transformComponents:Vector.<Vector3D>;
		
		public function ArcBall(sprite:Sprite, useRadius:Boolean = false, radius:Number = 200)
		{
			this.displayObject = sprite;
			this.useRadius = useRadius;
			this.radius = radius;
			init();
		}
		
		private function init():void
		{
			if(displayObject.transform.matrix3D == null){
				displayObject.rotationX = 0;
			}
			startVector = new Vector3D();
			startQuat = new Vector3D();
			dragQuat = new Vector3D();
			dragVector = new Vector3D();
			newQuat = new Vector3D();
			
			radiusVector = new Vector3D();
		}
		
		protected function startDrag(vector3D:Vector3D):void
		{
            transformComponents = _displayObject.transform.matrix3D.decompose(Orientation3D.QUATERNION);
			var quat:Vector3D = transformComponents[1];
			startQuat.x = quat.x;
			startQuat.y = quat.y;
			startQuat.z = quat.z;
			startQuat.w = quat.w;
			dragQuat.x = dragQuat.y = dragQuat.z = dragQuat.w = 0;
		}
		
		protected function dragTo(vector:Vector3D):void
		{
			var v:Vector3D = startVector.crossProduct(dragVector);
			dragQuat.x = v.x;
			dragQuat.y = v.y;
			dragQuat.z = v.z;
			dragQuat.w = startVector.dotProduct(dragVector);
			QuaternionUtil.multiplyQuats(dragQuat, startQuat, newQuat);
			transformComponents[1] = newQuat;
			_displayObject.transform.matrix3D.recompose(transformComponents, Orientation3D.QUATERNION);
		}
		
		public function coordinate2Dto3D(x:Number, y:Number, targetVector:Vector3D, displayObject:InteractiveObject):Vector3D
		{
			if(displayObject.transform.matrix3D){
				var transformMatrix:Matrix3D = displayObject.transform.getRelativeMatrix3D(this._displayObject);
				targetVector.x = x;
				targetVector.y = y;
				targetVector.z = 0;
				targetVector = transformMatrix.transformVector(targetVector);
			}
			return targetVector;
		}
		
		public function coordinate2DToSphere(x:Number, y:Number, targetVector:Vector3D):Vector3D
		{
			targetVector.x = (displayObject.x-x)/_radius;
			targetVector.y = (displayObject.y-y)/_radius;
			targetVector.z = 0;
			if(targetVector.lengthSquared > 1){
				targetVector.normalize();
			}else{
				targetVector.z = Math.sqrt(1-targetVector.lengthSquared);
			}
			return targetVector;
		}
		
		public function setStage(stage:Stage):void
		{
			this._stage = stage;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			_displayObject.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			setStage(displayObject.stage);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(_enabled){
				_displayObject.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				var eventObject:InteractiveObject = event.target as InteractiveObject;
				if(!useRadius){
					radiusVector = coordinate2Dto3D(eventObject.mouseX,eventObject.mouseY,radiusVector,eventObject);
					_radius = radiusVector.length*2;
				}else{
					_radius = radius;
				}
				startVector = coordinate2DToSphere(_stage.mouseX,_stage.mouseY,startVector);
				startDrag(startVector);
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			event.stopPropagation();
			_displayObject.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
				
		protected function onEnterFrame(event:Event):void
		{
			dragVector = coordinate2DToSphere(_stage.mouseX,_stage.mouseY,dragVector);
			dragTo(dragVector);
		}
		
		public function set displayObject(displayObject:InteractiveObject):void
		{
			if(_displayObject != null){
				_displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,true);
				_displayObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp,true);
			}
			if(displayObject){
				if(displayObject.stage != null){
					setStage(displayObject.stage);
				}else{
					displayObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				}
				displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				displayObject.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				displayObject.mouseEnabled = true;
			}
			_displayObject = displayObject;
		}
		
		public function get displayObject():InteractiveObject
		{
			return _displayObject;
		}
		
		public function set enabled(enabled:Boolean):void
		{
			_enabled = enabled;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

	}
}