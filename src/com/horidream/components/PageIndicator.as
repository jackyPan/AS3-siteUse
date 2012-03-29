package com.horidream.components
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 12, 2011
	 */
	import com.greensock.easing.Sine;
	import com.horidream.core.CompomentCore;
	import com.horidream.util.HoriMath;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	public class PageIndicator extends CompomentCore
	{
		private var pageNum:int;
		private var _currentIndex:int = -1;
		
		
		
		private var circleRadius:Number;
		private var circleDistance:Number;
		private var circleColorWhenSelected:uint;
		private var circleColorWhenUnselected:uint;
		private var container:DisplayObjectContainer;
		private var interactive:Boolean;
		
		
		public function PageIndicator(vars:Object = null, xpos:Number = 0, ypos:Number =  0)
		{
			this.pageNum = vars.pageNum || 1;
			this.circleColorWhenUnselected = vars.colors?vars.colors[0]:0x999999;
			this.circleColorWhenSelected =vars.colors?vars.colors[1]: 0xFFFFFF;
			this.circleRadius = vars.curcleRadius || 5;
			this.circleDistance = vars.circleDistance || circleRadius*4;
			this.container = vars.container || null;
			this.interactive = vars.interactive || false;
			super(container,xpos,ypos);
			if(interactive)
			{
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				this.mouseEnabled = false;
			}
			
			this.currentIndex = vars.currentIndex || 0;
		}
		public function change(vars:Object):void
		{
			this.pageNum = vars.pageNum || this.pageNum;
			this.circleColorWhenUnselected = vars.colors?vars.colors[0]:this.circleColorWhenUnselected;
			this.circleColorWhenSelected =vars.colors?vars.colors[1]: this.circleColorWhenSelected;
			this.circleRadius = vars.circleRadius || this.circleRadius;
			this.circleDistance = vars.circleDistance || this.circleDistance;
			this.container = vars.container || this.container;
			this.interactive = vars.interactive == null?this.interactive:vars.interactive;
			if(interactive)
			{
				this.buttonMode = true;
				this.mouseEnabled = true;
				this.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				this.buttonMode = false;
				this.mouseEnabled = false;
				this.removeEventListener(MouseEvent.CLICK,onClick);
			}
			
			this.currentIndex = vars.currentIndex || this.currentIndex;
			drawCircles();
		}
		private function onClick(e:MouseEvent):void
		{
			for(var i:int = 0;i<pageNum;i++)
			{
				if(Point.distance(new Point(e.localX,e.localY),new Point(i*circleDistance+circleRadius,circleRadius))<=circleRadius)
				{
					currentIndex = i;
				}
				
			}
			e.stopImmediatePropagation();
		}
		
		

		public function get currentIndex():int
		{
			return _currentIndex;
		}

		public function set currentIndex(value:int):void
		{
			if(_currentIndex!=value){
				_currentIndex = HoriMath.getValidPeriodValue(value,0,pageNum);
				changed.dispatch();
			}
		}


		protected override function onChanged():void
		{
			drawCircles();
		}


		protected override function init():void
		{
			drawCircles();

		}
		
		private function drawCircles():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			for(var i:int = 0;i<pageNum;i++)
			{
				if(i!=currentIndex)
				{
					g.beginFill(circleColorWhenUnselected);
				}else
				{
					g.beginFill(circleColorWhenSelected);
				}
				g.drawCircle(i*circleDistance+circleRadius,circleRadius,circleRadius);
			}
			g.endFill();
			
		}

	}
}