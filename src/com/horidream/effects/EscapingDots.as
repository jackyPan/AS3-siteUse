package com.horidream.effects
{
	import com.horidream.interfaces.IEffect;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created May 24, 2010 
	 */
	public class EscapingDots extends Sprite implements IEffect
	{
		public var effectLayer:Bitmap;
		private var canvas:BitmapData;
		private var _playing:Boolean = false;
		private var _color:uint;
		
		private var tw:uint = 420;
		private var th:uint = 200;
		private static var accuracy:uint = 2;
		private var detection:DetectDot;
		private var _source:DisplayObject;
		private var area:Rectangle;
		private static var threshold:uint = 0x80FFFFFF;
		private var map:Array;
		private var dots:Array;
		private static var radius:uint = 150;
		private static var acceleration:Number = 0.1;
		private static var deceleration:Number = 0.2;
		
		private var rec:Rectangle;
		public function EscapingDots(src:Sprite,color:uint = 0xFFFFFF,rec:Rectangle = null)
		{
			this.rec = rec;
			this._source = src;
			this._color = color;
			if(stage){
				onAddedToStage()
			}else{
				addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}

		private function onAddedToStage(event:Event = null):void
		{
			if(rec == null){
				rec = _source.getRect(stage);
				rec.inflate(30,30);
			}
			init();
			this.source = _source;
			
		}
		

		public function destroy():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, draw);
			}
			if(effectLayer.parent == this){
				this.removeChild(effectLayer);
			}
		}


		public function get playing():Boolean
		{
			return _playing;
		}


		public function start():void
		{
			if(!playing){
				addEventListener(Event.ENTER_FRAME, draw, false, 0, true);
				_playing = true;
			}
		}

		public function stop():void
		{
			if(playing){
				removeEventListener(Event.ENTER_FRAME, draw);
				_playing = false;
			}
		}

		public function set source(src:DisplayObject):void {
			removeChild(effectLayer);
			this._source = src;
			rec = _source.getRect(stage);
			rec.inflate(30,30);
			init();
			tw = src.width;
			th = src.height;
			area = new Rectangle(0, 0, tw, th);
			detection.search(src, area, threshold);
			map = detection.pixels();
			createDots();
			start();
		}
		public function get source():DisplayObject{
			return _source;
		}
		private function init():void {
			detection = new DetectDot(accuracy);
			canvas = new BitmapData(rec.width, rec.height, true, 0x00000000);
			effectLayer = new Bitmap(canvas);
			effectLayer.x = rec.x;
			effectLayer.y = rec.y;
			addChild(effectLayer);
		}
		private function createDots():void {
			dots = new Array();
			var dw:uint = uint(tw + _source.x*2);
			var dh:uint = uint(th + _source.y*2);
			for (var n:uint = 0; n < map.length; n++) {
				var tx:uint = map[n].x + _source.x + accuracy/2 ;
				var ty:uint = map[n].y + _source.y + accuracy/2;
				var dot:Dot = new Dot(tx, ty);
				dot.id = n;
				dot.x = Math.floor(Math.random()*dw);
				dot.y = Math.floor(Math.random()*dh);
				dots.push(dot);
			}
		}
		private function draw(evt:Event):void {
			if(!stage){
				return;
			}
			canvas.lock();
			canvas.fillRect(canvas.rect, 0x00000000);
			for (var n:uint = 0; n < dots.length; n++) {
				var dot:Dot = dots[n];
				var angle:Number = Math.atan2(dot.y - mouseY, dot.x - mouseX);
				var distance:Number = Math.sqrt(Math.pow(mouseX - dot.x, 2) + Math.pow(mouseY  - dot.y, 2));
				var circle:Number = radius/distance;
				if (distance < 50) {
					dot.x += circle*Math.cos(angle) + (dot.tx - dot.x)*acceleration;
					dot.y += circle*Math.sin(angle) + (dot.ty - dot.y)*acceleration;
				} else {
					dot.x += (dot.tx - dot.x)*deceleration;
					dot.y += (dot.ty - dot.y)*deceleration;
					if (Math.abs(dot.tx - dot.x) < 0.5 && Math.abs(dot.ty - dot.y) < 0.5) {
						dot.x = dot.tx;
						dot.y = dot.ty;
					}
				}
				canvas.setPixel32(dot.x - rec.x, dot.y - rec.y, 0xFF000000+_color);
			}
			canvas.unlock();
		}
	}
}
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class DetectDot extends Sprite {
	private var target:DisplayObject;
	private var rect:Rectangle;
	private var map:BitmapData;
	private var mapList:Array;
	private var accuracy:uint;
	private var threshold:uint = 0x80FFFFFF;
	
	public function DetectDot(a:uint = 1) {
		accuracy = a;
	}
	
	public function search(t:DisplayObject, r:Rectangle, th:uint = 0x80FFFFFF):void {
		target = t;
		rect = r;
		threshold = th;
		var w:uint = rect.width/accuracy;
		var h:uint = rect.height/accuracy;
		detect(w, h);
	}
	private function detect(w:uint, h:uint):void {
		map = new BitmapData(w, h, true, 0x00000000);
		var matrix:Matrix = new Matrix();
		matrix.scale(1/accuracy, 1/accuracy);
		map.lock();
		map.draw(target, matrix);
		map.unlock();
		mapList = new Array();
		for (var x:uint = 0; x < w; x++) {
			for (var y:uint = 0; y < h; y++) {
				var color:uint = map.getPixel32(x, y);
				if (color >= threshold) {
					var px:int = x*accuracy + rect.x;
					var py:int = y*accuracy + rect.y;
					var point:Point = new Point(px, py);
					mapList.push(point);
				}
			}
		}
	}
	public function pixels():Array {
		return mapList;
	}
	
}


class Dot {
	public var id:uint;
	public var x:Number = 0;
	public var y:Number = 0;
	public var tx:Number = 0;
	public var ty:Number = 0;
	
	public function Dot(px:Number, py:Number) {
		tx = px;
		ty = py;
	}
	
}