package com.horidream.effects
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Aug 24, 2010 11:43:30 AM
	 */
	public class ShockIt
	{
		private var target:DisplayObject;
		private var matrix:Matrix;
		private var xValue:Number;
		private var yValue:Number;
		private var count:int;
		private var totalFrames:int;
		private var attenuation:Boolean;
		private static var shockingList:Dictionary = new Dictionary();
		public function ShockIt(target:DisplayObject,xValue:Number = 20,yValue:Number = 20,totalFrames:int = 10,attenuation:Boolean = true)
		{
			this.target = target;
			if(!shockingList[target]){
				shockingList[target] = this;
			}else{
				shockingList[target].stop();
				shockingList[target] = this;
			}
			this.xValue = xValue;
			this.yValue = yValue;
			this.totalFrames = totalFrames;
			this.attenuation = attenuation;
			matrix = target.transform.matrix;
			count = 0;
			target.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function stop():void{
			target.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			target.transform.matrix = matrix;
			
		}
		private function onEnterFrame(event:Event):void
		{
			count++;
			var attenuationFactor:Number = (totalFrames - count)/totalFrames;
			if(count<=totalFrames){
				var tempMatrix:Matrix = matrix.clone();
				if(attenuation){
					tempMatrix.tx = matrix.tx+(count%2 == 0?xValue*attenuationFactor:-xValue*attenuationFactor); 			
					tempMatrix.ty = matrix.ty+(Math.random()>.5?yValue*attenuationFactor:-yValue*attenuationFactor); 			
					
				}else{
					tempMatrix.tx = matrix.tx+(Math.random()>.5?xValue:-xValue); 			
					tempMatrix.ty = matrix.ty+(Math.random()>.5?yValue:-yValue); 			
				}
				target.transform.matrix = tempMatrix;
			}else{
				stop();
				delete shockingList[target];
			}
		}
	}
}