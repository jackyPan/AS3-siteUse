package com.horidream.effects
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	May 6, 2011
	 */
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.horidream.fp10.TrianglePlane;
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	import com.horidream.vo.PointHori;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;
	
	public class AbsorbImage extends TrianglePlane
	{
		
		private var _isClose:Boolean = false;
		private var _status:int = 0;
		public static var delayAmplifier:uint = 1;
		public var statusChanged:Signal = new Signal(int);


		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			if(_status != value){
				_status = value;
				statusChanged.dispatch(value);
			}
		}

		public static function absorbAt(target:DisplayObject,x:Number,y:Number,rec:Rectangle = null,segW:int=10, segH:int=10):AbsorbImage
		{
			rec = rec || RecUtil.getVisibleBounds(target);
			var bmd:BitmapData = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			bmd.draw(target);
			
			var ai:AbsorbImage = new AbsorbImage(bmd,segW,segH);
			QuickSetter.cloneProperty(ai,target,"transform.matrix");
			ai.absorbAt(x-target.x,y-target.y);
//			target.parent.addChildAt(ai,target.parent.getChildIndex(target));
//			ai.alpha = 0;
//			TweenMax.to(ai,.3,{autoAlpha:1});
//			TweenMax.to(target,.3,{autoAlpha:0});
			QuickSetter.swapDisplayObject(ai,target);
			return ai;
		}
		public static function springAt(target:DisplayObject,x:Number,y:Number,container:DisplayObjectContainer = null,rec:Rectangle = null,segW:int=10, segH:int=10):AbsorbImage
		{
			rec = rec || RecUtil.getVisibleBounds(target);
			var bmd:BitmapData = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			bmd.draw(target);
			container = target.parent || container;
			if(!container)
			{
				return null;
			}
//			QuickSetter.removeSelf(target);
			var ai:AbsorbImage = new AbsorbImage(bmd,segW,segH);
			QuickSetter.cloneProperty(ai,target,"transform.matrix");
			ai.springAt(x-target.x,y-target.y);
			
			container.addChild(target);
			target.visible = false;
			Hori.enterFrame.add(onEnterFrame);
			
			function onEnterFrame():void
			{
				Hori.enterFrame.remove(onEnterFrame);
				if(ai)
					container.addChild(ai);
			}
			ai.addEventListener("effectFinished",onEffectFinished);
			function onEffectFinished(e:Event):void
			{
				target.visible = true;
//				QuickSetter.swapDisplayObject(ai,target);
				QuickSetter.removeSelf(ai);
				ai.removeEventListener("effectFinished",onEffectFinished);
				ai.dispose();
				ai = null;
				
			}
			return ai;
		}

		
		
		public function AbsorbImage(bmd:BitmapData, segW:int=10, segH:int=10)
		{
			super(bmd, segW, segH);
			this.addEventListener("effectFinished",onEffectFinished);
		}

		private function onEffectFinished(e:Event):void
		{
			status = 0;
		}

		public function get isClose():Boolean
		{
			return _isClose;
		}

		public function absorbAt(x:Number,y:Number,needReset:Boolean = false):void
		{
			
			if(needReset){
				reset();
			}
			var p:PointHori = origin;
			var longestDelay:Number = 0;
			var shortestDelay:Number = 1000;
			while(p){
				var dis:Number = HoriMath.distance(p.x,p.y,x,y);
				if(longestDelay<dis)
				{
					longestDelay = dis;
				}
				TweenMax.killTweensOf(p);
				TweenMax.to(p,.5,{x:x,y:y,delay:(dis)*.001*delayAmplifier-.1,ease:Back.easeIn});
				p = p.next?p.next:null;
			}
			TweenMax.delayedCall(longestDelay*.001*delayAmplifier+.1,dispatchEvent,[new Event("effectFinished")]);
			_isClose = true;
			status = 1;
		}
		public function springAt(x:Number,y:Number,container:DisplayObjectContainer = null):void
		{
			
			var rec:Rectangle = bitmapData.rect;
			var maxDis:Number = Math.max(HoriMath.distance(0,0,x,y),
				HoriMath.distance(0,rec.bottom,x,y),
				HoriMath.distance(rec.right,0,x,y),
				HoriMath.distance(rec.right,rec.bottom,x,y));
			var p:PointHori = origin;
			var longestDelay:Number = 0;
			while(p){
				p.x = x;
				p.y = y;
				var dis:Number = HoriMath.distance(p.initX,p.initY,x,y);
				TweenMax.killTweensOf(p);
				if(longestDelay<(maxDis-dis))
				{
					longestDelay = (maxDis-dis);
				}
				TweenMax.to(p,.6,{x:p.initX,y:p.initY,delay:(maxDis-dis)*.001*delayAmplifier,ease:Back.easeOut})
				p = p.next?p.next:null;
			}
			
			
			TweenMax.delayedCall(longestDelay*.001*delayAmplifier+.4,dispatchEvent,[new Event("effectFinished")]);
			if(container){
				container.addChild(this);
			}
			_isClose = false;
			status = 2;
		}
	}
}