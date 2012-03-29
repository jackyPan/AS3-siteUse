package com.horidream.effects
{
	import com.horidream.util.QuickSetter;
	import com.horidream.vo.BitmapDataParticle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jun 11, 2011 10:03:25 AM
	 */
	public class BitmapExplode
	{
		private static var bmdDic:Dictionary = new Dictionary();
		
		private const ANGLE_TO_RADIAN:Number = Math.PI/180;
		
		private var container:DisplayObjectContainer;
		private var target:DisplayObject;
		private var rec:Rectangle;
		private var bmd:BitmapData;
		private var canvasBitmap:Bitmap;
		private var xOffset:Number;
		private var yOffset:Number;
		private var source:BitmapData;
		private var particles:BitmapDataParticle;
		private var countDown:int = 20;
		
		
		private var gravity:Number;
		private var wind:Number;
		private var speed:int;
		private var angle:int;
		public var unionRatio:Number = .6;
		public var upwardForce:Number = 5; 
		public var blurAmount:uint = 8;
		private var colorMatrix:ColorMatrixFilter;
		private var blurFilter:BlurFilter;
		
		private var timer:Timer = new Timer(40);
		
		private static var spaceDic:Dictionary = new Dictionary();
		public function BitmapExplode(coordinateSpace:DisplayObjectContainer)
		{
			if(spaceDic[coordinateSpace])
			{
				throw new Error("This coordinateSpace has been created");
			}
			this.container = coordinateSpace;
			spaceDic[coordinateSpace] = this;	
			if(coordinateSpace is Stage){
				var stage:Stage = coordinateSpace as Stage;
				this.rec = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			}else{
				this.rec = coordinateSpace.getRect(coordinateSpace);
				if(this.rec.isEmpty() && coordinateSpace.stage){
					this.rec = new Rectangle(0,0,coordinateSpace.stage.stageWidth,coordinateSpace.stage.stageHeight);
				}
			}
			
//			bmd = new BitmapData(rec.width,rec.height,true,0xFFFF0000);
			bmd = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			canvasBitmap = new Bitmap(bmd);
			QuickSetter.set(canvasBitmap,{x:rec.x,y:rec.y});
			coordinateSpace.addChild(canvasBitmap);
			timer.addEventListener(TimerEvent.TIMER,renderParticles);
		}
		
		public function get viewport():Bitmap
		{
			return this.canvasBitmap;
		}
		public static function explode(target:DisplayObject,coordinateSpace:DisplayObjectContainer = null,vars:Object = null):BitmapExplode
		{
			coordinateSpace = coordinateSpace || target.parent || null;
			if(!coordinateSpace)
			{
				return null;
			}
			if(spaceDic[coordinateSpace])
			{
				spaceDic[coordinateSpace].explode(target,vars);
				return spaceDic[coordinateSpace];
			}else
			{
				var be:BitmapExplode = new BitmapExplode(coordinateSpace);
				be.explode(target,vars);
				return be;
			}
		}
		public function explode(target:DisplayObject,vars:Object = null):void
		{
			this.target = target;
			var targetRec:Rectangle = target.getBounds(container);
			this.source = new BitmapData(targetRec.width,targetRec.height,true,0x00FFFFFF);
			var m:Matrix = container.transform.matrix;
			m.invert();
//			var m:Matrix = target.transform.matrix;
			
			m.tx = -target.getRect(target).x*m.a;
			m.ty = -target.getRect(target).y*m.d;
			source.draw(target,m);
			xOffset = target.x+target.getRect(target).x*m.a-container.x-rec.x;
			yOffset = target.y+target.getRect(target).y*m.d-container.y-rec.y;
			
			vars = vars || {};
			this.gravity = vars.gravity || .5;
			this.wind = vars.wind || 0;
			this.speed = vars.speed || 5;
			this.angle = vars.angle || 45;
			
			this.unionRatio = vars.unionRatio || .6;
			this.blurAmount = vars.blurAmount==0?0:8;
			this.upwardForce = vars.upwardForce || 5;
			this.blurFilter = new BlurFilter(blurAmount,blurAmount);
			this.colorMatrix = new ColorMatrixFilter(
				[
					.9,0,0,0,0,
					0,.9,0,0,0,
					0,0,.9,0,0,
					0,0,0,.8,0
				]
			);
			createParticle(vars.size || 2);
			if(!timer.running)
				timer.start();
			drawParticles();
			QuickSetter.removeSelf(target);
			countDown = 20;
		}

		private function renderParticles(e:TimerEvent):void
		{
			drawParticles();
		}
		
		private function createParticle(size:int):void
		{
			var rect:Rectangle = source.getColorBoundsRect(0xFF000000, 0x00000000,false);
			if((!rect) || (rect.width == 0) || (rect.height == 0))
			{
				return;
			}
			var trimedBmd:BitmapData = new BitmapData(rect.width,rect.height,true,0x00FFFFFF);
			trimedBmd.copyPixels(source,rect,new Point(0,0));
			var w:uint = Math.ceil(trimedBmd.width/size);
			var h:uint = Math.ceil(trimedBmd.height/size);
			var n:int = w*h;
			var i:int = 0;
			var prev:BitmapDataParticle = new BitmapDataParticle(size);
			if(!particles){
				particles = prev;
			}else{
				var tempPar:BitmapDataParticle = particles;
				while(tempPar.next!=null){
					tempPar = tempPar.next;
				}
//				tempPar.next = prev;
				prev = tempPar;
			}
			var p:BitmapDataParticle;
			while(i<=n){
				var X:int = i % w ;
				var Y:int = int(i / w);
				var col:uint = trimedBmd.getPixel32(X*size, Y*size);
				
				if ((col>>24) != 0)
					//				if ((col>>24) != 0 && ( (col & 0xFFFFFF) != bgColor))
				{
					p = new BitmapDataParticle(size);
					p.color = col;
					p.x = xOffset + X*size + rect.left;
					p.y = yOffset + Y*size + rect.top;
					p.bmd.copyPixels(trimedBmd,new Rectangle(X*size,Y*size,size,size),new Point());
					
					p.vx = speed*(X-w/2)/w*2*Math.sin(angle*ANGLE_TO_RADIAN);
					p.vx = p.vx*unionRatio+p.vx*Math.random()*(1-unionRatio)*2;
					p.vy = speed*(Y-h/2)/h*2*Math.cos(angle*ANGLE_TO_RADIAN)-upwardForce;
					p.vy = p.vy*unionRatio+p.vy*Math.random()*(1-unionRatio)*2;
					prev.next = p;
					prev = p;
				}
				i ++;
			}
		}
		private function drawParticles():void{
			//bmd.fillRect(bmd.rect,0x00FFFFFF);
			if(!particles)
			{
				return;
			}
			
//			if(count>10)
//			{
//				bmd.fillRect(bmd.rect,0x00FFFFFF);
//				timer.stop();
//				timer.removeEventListener(TimerEvent.TIMER,onEnterFrame);
//				//				container.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
//				QuickSetter.removeSelf(canvasBitmap);
//				return;
//			}
			bmd.lock();
			if(blurAmount!=0){
				bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), blurFilter);
			}
			bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), colorMatrix);
			var p:BitmapDataParticle = particles;
			var temp:BitmapData;
			while ((p = p.next) != null)
			{
//				bmd.setPixel32(p.x, p.y, 0x00FFFFFF+(0xFF<<24));
				bmd.copyPixels(p.bmd,p.bmd.rect,new Point(p.x,p.y),null,null,true);
				p.x += p.vx;
				p.y += p.vy;
				p.vx += wind;
				p.vy += gravity;
				
				while (p.next != null && ((p.next.y > (rec.height) && p.next.vy > 0) || (p.next.x < 0 || p.next.x > rec.width)))
				{
					p.next = p.next.next;
				}
			}
			bmd.unlock();
			if(particles.next==null || particles.next.next == null){
				countDown--;
				if(countDown == 0){
					timer.stop();
					particles = null;
					trace("stop");
				}				
			}
		}
	}
}