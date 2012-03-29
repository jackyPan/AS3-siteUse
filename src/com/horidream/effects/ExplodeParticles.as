package com.horidream.effects
{
	import com.horidream.display.ShowManager;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Aug 22, 2010 4:21:30 PM
	 */
	public class ExplodeParticles
	{
		public var particles:Particle;
		private var bgColor:int = 0;
		private var source:BitmapData;
		private var rec:Rectangle;
		private var gravity:Number = .5;
		private var wind:Number = 0;
		private var speed:Number;
		private var angle:Number;
		private var countDown:int = 0xFF;
		private var xOffset:int = 0;
		private var yOffset:int = 0;
		private var bmd:BitmapData;
		private var canvasBitmap:Bitmap
		private var target:DisplayObject;
		private var container:DisplayObjectContainer;
		private const ANGLE_TO_RADIAN:Number = Math.PI/180;
		private var timer:Timer;
		
		private var count:int = 0;
		
		public var unionRatio:Number = .6;
		public var upwardForce:Number = 5; 
		public var blurAmount:uint = 8;
		public var completed:Signal = new Signal();
		public function ExplodeParticles(target:DisplayObject,container:DisplayObjectContainer,blendMode:String = null)
		{
			this.target = target;
			this.container = container;
			this.timer = new Timer(40);
			var targetRec:Rectangle = target.getBounds(target.parent);
			this.source = new BitmapData(targetRec.width,targetRec.height,true,0x00FFFFFF);
			var m:Matrix = target.transform.matrix;
			m.tx = -target.getRect(target).x*m.a;
			m.ty = -target.getRect(target).y*m.d;
			source.draw(target,m);
			if(container is Stage){
				var stage:Stage = container as Stage;
				this.rec = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			}else{
				this.rec = container.getRect(container);
				if((this.rec.isEmpty() || this.rec.equals(targetRec)) && container.stage){
					this.rec = new Rectangle(0,0,container.stage.stageWidth,container.stage.stageHeight);
				}
			}
			
			bmd = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			canvasBitmap = new Bitmap(bmd);
			if(blendMode)
				canvasBitmap.blendMode = blendMode;
			xOffset = target.x+target.getRect(target).x*m.a-container.x;
			yOffset = target.y+target.getRect(target).y*m.d-container.y;
			
			
		}
		public function get viewport():Bitmap
		{
			return canvasBitmap;
		}
		public static function explode(target:DisplayObject,container:DisplayObjectContainer = null,vars:Object = null):ExplodeParticles
		{
			if(!target.stage)
			{
				return null;
			}
			container = container || target.stage;
			vars = vars || {};
			var p:ExplodeParticles = new ExplodeParticles(target,container,null);
			var size:uint = vars.size || Math.ceil(Math.max(target.width/100,target.height/100));
			var speed:Number = vars.speed || 10;
			var angle:Number = vars.angle || 45;
			var gravity:Number = vars.gravity == null? .5:vars.gravity;
			var wind:Number = vars.wind || 0;
			p.upwardForce = vars.upwardForce || p.upwardForce;
			p.unionRatio = vars.unionRatio == null? p.unionRatio:vars.unionRatio;
			p.blurAmount = vars.blurAmount==null? p.blurAmount:vars.blurAmount;
			p.explode(size,speed,angle,gravity,wind);
			return p;
		}
		
		public function explode(particleSize:uint = 2,speed:Number = 5,angle:Number = 15,gravity:Number = .5,wind:Number = 0):void{
//			if(target.parent){
//				target.parent.removeChild(target);
//				
//			}
			count = 0;
//			QuickSetter.removeSelf(target);
//			container.addChild(canvasBitmap);
			QuickSetter.swapDisplayObject(canvasBitmap,target);
//			container.addChild(canvasBitmap);
			this.gravity = gravity;
			this.wind = wind;
			this.speed = speed;
			this.angle = angle;
			createParticle(particleSize);
			timer.addEventListener(TimerEvent.TIMER,onEnterFrame);
			timer.start();
			onEnterFrame(null);
//			container.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(event:TimerEvent):void
		{
			drawParticles();
		}
		private function createParticle(size:uint = 10):void{
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
			var prev:Particle = new Particle(size);
			if(!particles){
				particles = prev;
			}else{
				var tempPar:Particle = particles.next;
				while(tempPar.next!=null){
					tempPar = tempPar.next;
				}
				tempPar.next = prev;
			}
			var p:Particle;
			while(i<=n){
				var X:int = i % w ;
				var Y:int = int(i / w);
				var col:uint = trimedBmd.getPixel32(X*size, Y*size);
				
				if ((col>>24) != 0)
//				if ((col>>24) != 0 && ( (col & 0xFFFFFF) != bgColor))
				{
					p = new Particle(size);
					p.color = col;
					p.x = xOffset + X*size + rect.left;
					p.y = yOffset + Y*size + rect.top;
					p.bmd.copyPixels(trimedBmd,new Rectangle(X*size,Y*size,size,size),new Point());
					
					p.vx = speed*(X-w/2)/w*2*Math.sin(angle*ANGLE_TO_RADIAN);
					p.vx = p.vx*unionRatio+p.vx*Math.random()*(1-unionRatio)*2;
					p.vy = speed*(Y-h/2)/h*2*Math.cos(angle*ANGLE_TO_RADIAN)-upwardForce;
					p.vy = p.vy*unionRatio+p.vy*Math.random()*(1-unionRatio)*2;
//					p.vx = speed*Math.random()*Math.sin(-angle/180*Math.PI+Math.random()*2*angle/180*Math.PI);
//					p.vy = -speed*Math.random()*Math.cos(-angle/180*Math.PI+Math.random()*2*angle/180*Math.PI);
//					p.vx = speed*Math.random()*Math.sin(-angle/180*Math.PI+Math.random()*2*angle/180*Math.PI);
//					p.vy = -speed*Math.random()*Math.cos(-angle/180*Math.PI+Math.random()*2*angle/180*Math.PI);
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
			if(particles.next==null || particles.next.next == null){
					countDown = 0xFF;
					count++;
			}
			
			if(count>10)
			{
				var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0x00000000,false);
				if((!rect) || (rect.width == 0) || (rect.height == 0))
				{
					
					bmd.fillRect(bmd.rect,0x00FFFFFF);
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,onEnterFrame);
					QuickSetter.removeSelf(canvasBitmap);
					completed.dispatch();
					return;
				}
					
			}
			bmd.lock();
			if(blurAmount!=0){
				bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), new BlurFilter(blurAmount,blurAmount));
			}
			bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), new ColorMatrixFilter(
				[
					.9,0,0,0,0,
					0,.9,0,0,0,
					0,0,.9,0,0,
					0,0,0,.8,0
					]
				)
			);
			var p:Particle = particles;
				var temp:BitmapData;
			while ((p = p.next) != null)
			{
//				bmd.setPixel32(p.x, p.y, 0x00FFFFFF+(countDown<<24));
//				p.bmd.applyFilter(p.bmd,p.bmd.rect,new Point(0,0),new ColorMatrixFilter(
//					[
//						.9,0,0,0,0,
//						0,.9,0,0,0,
//						0,0,.9,0,0,
//						0,0,0,.97,0
//					]));
				bmd.copyPixels(p.bmd,p.bmd.rect,new Point(p.x,p.y),null,null,true);
				p.x += p.vx;
				p.y += p.vy;
				p.vx += wind;
				p.vy += gravity;
				
				while (p.next != null && ((p.next.y > rec.x+rec.height && p.next.vy > 0) || (p.next.x < rec.x || p.next.x > rec.x+rec.width) || countDown<20))
				{
					p.next = p.next.next;
				}
			}
			bmd.unlock();
			
		}
	}
}
import flash.display.BitmapData;

class Particle
{
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public var next:Particle;
	public var color:uint;
	public var bmd:BitmapData;
//	public var fadeOut:Number;
	public function Particle(size:uint){ 
		bmd = new BitmapData(size,size,true,0x00FFFFFF);
//		this.fadeOut = .85;
	}
}