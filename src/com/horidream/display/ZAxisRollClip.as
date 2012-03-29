package com.horidream.display
{
	import com.horidream.interfaces.IShowIndex;
	import com.horidream.interfaces.IUpdate;
	import com.horidream.template.AddedSprite;
	import com.horidream.util.HoriMath;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 25, 2011
	 */
	public class ZAxisRollClip extends AddedSprite
	{
		
		public var numberOfView:int = 4;
		public var blurs:Array;
		public var alphas:Array = [.5,1,1];
		public var scales:Array = [2,1,0];
		private var _points:Array = [new Point(100,200),new Point(350,200),new Point(550,200)];
		public var ratios:Array = [0,127,255];
		public var period:Number = 300;
		private var _value:Number = 0;

		private var _dataValue:Object = null;

		
		public var containers:Array = [];
		private var xPosArr:Array;
		private var yPosArr:Array;
		private var totalItemNumber:Number;
		public function ZAxisRollClip()
		{
			xPosArr = [];
			yPosArr = [];
//			for(var i:int = 0;i<numberOfView;i++)
//			{
//				var container:Sprite = new Sprite();
//				addChild(container);
//				containers.push(container);
//				
//			}
			
			
		}


		public function set points(value:Array):void
		{
			_points = value;
			for(var i:int = 0;i<_points.length;i++)
			{
				xPosArr.push(_points[i].x);
				yPosArr.push(_points[i].y);
			}
		}

		public function set data(dataValue:Object):void
		{
			
			if(dataValue is Array){
				this.totalItemNumber = dataValue.length;
			}else if(dataValue is XMLList)
			{
				this.totalItemNumber = dataValue.length();
			}else{
				return;
			}
			_dataValue = dataValue;
		}
		public function refresh():void
		{
			render();
		}
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			_value = value;
			render();
		}
		protected override function init():void
		{
			
			numberOfView = containers.length;
			super.init();
		}

		protected override function onRegister(e:Event=null):void
		{
			super.onRegister(e);
		}
		
		private function render():void
		{
			for(var i:int = 0;i<numberOfView;i++)
			{
				var f:Number = (_value+period/numberOfView*i)%period/period;
				containers[i].alpha = HoriMath.interpolate(alphas,ratios,f);
				var xpos:Number = HoriMath.interpolate(xPosArr,ratios,f);
				var ypos:Number = HoriMath.interpolate(yPosArr,ratios,f);
				var scale:Number = HoriMath.interpolate(scales,ratios,f);
				containers[i].transform.matrix = new Matrix(scale,0,0,scale,xpos,ypos);
				if(blurs){
					var blur:Number = HoriMath.interpolate(blurs,ratios,f);
					containers[i].filters = [new BlurFilter(blur,blur)];
				}
				var stackIndex:int =  (numberOfView-i)+ Math.floor((_value+period/numberOfView*i)/period)*numberOfView;
				stackIndex -= (numberOfView);
				showContentAtIndex(containers[i] as IUpdate,stackIndex,_dataValue);
			}
			alignDepth();
		}
		
		public function showContentAtIndex(content:IUpdate, stackIndex:int,currentData:Object):void
		{
			
			if(currentData && currentData[stackIndex]){
				content.update(currentData[stackIndex]);
			}
		}
		private function alignDepth():void
		{
			containers.sortOn("scaleX");
			for(var i:int = 0;i<containers.length;i++)
			{
				addChild(containers[i]);
			}
		}
		protected override function onRemove(e:Event):void
		{
			super.onRemove(e);
		}


	}
}