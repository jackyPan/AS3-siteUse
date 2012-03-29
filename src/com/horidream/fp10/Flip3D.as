package com.horidream.fp10
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 18, 2010 12:15:23 PM
	 */
	public class Flip3D
	{
		private var maxRotation:Number;
		private var target:DisplayObject;
		private var container:DisplayObjectContainer;
		private var ease:Number;
		private var W:Number;
		private var H:Number;
		private var _isFlipping:Boolean;
		private var _onlyX:Boolean;
		private var _onlyY:Boolean;
		public function Flip3D(target:DisplayObject,container:DisplayObjectContainer,maxRotation:Number = 15,ease:Number = .1)
		{
			this.maxRotation = maxRotation;
			this.target = target;
			this.container = container;
			this.ease = ease;
			_isFlipping = false;
			if(container is Stage){
				var stage:Stage = container as Stage;
				W = stage.stageWidth;
				H = stage.stageHeight;
			}else{
				W = container.width;
				H = container.height;
			}
			target.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}

		private function onAddedToStage(e:Event):void
		{
//			if(isFlipping){
//				target.addEventListener(Event.ENTER_FRAME,onLoop);
//			}
			target.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			target.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
		}

		private function onRemovedFromStage(e:Event):void
		{
			target.removeEventListener(Event.ENTER_FRAME,onLoop);
		}


		public function get isFlipping():Boolean
		{
			return _isFlipping;
		}

		public function start(onlyX:Boolean = true,onlyY:Boolean = true):void
		{
			_onlyY = onlyY;
			_onlyX = onlyX;
			target.addEventListener(Event.ENTER_FRAME,onLoop);
			_isFlipping = true;
		}
		public function stop():void
		{
			target.removeEventListener(Event.ENTER_FRAME,onLoop);
			_isFlipping = false;
		}
		public function dispose():void{
			var m:Matrix3D = target.transform.matrix3D;
			target.transform.matrix3D = null;
			target.transform.matrix = new Matrix(m.rawData[0],0,0,m.rawData[5],m.position.x,m.position.y);
			target.removeEventListener(Event.ENTER_FRAME,onLoop);
			_isFlipping = false;
		}
		private function onLoop(e:Event):void {
			if(_onlyX){
				var disty:Number = Math.min(1,container.mouseY/H);
				var targetRotationX:Number = maxRotation - (maxRotation*2*disty);
				var changeValue:Number = (targetRotationX - target.rotationX);
				if(Math.abs(changeValue)>1){
					target.rotationX += changeValue*ease;
				}
			}
			if(_onlyY)
			{
				
				var distx:Number = Math.min(1,container.mouseX/W);
				var targetRotationY:Number = -maxRotation + (maxRotation*2*distx);
				changeValue = (targetRotationY - target.rotationY);
				if(Math.abs(changeValue)>1){
					target.rotationY += changeValue*ease;
				}
			}
			
		}
	}
}