package com.horidream.fp10
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	May 5, 2011
	 */
	import com.horidream.util.Cast;
	import com.horidream.vo.PointHori;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class TrianglePlane extends Sprite
	{
		private var segW:int;
		private var segH:int;
		private var _bmd:BitmapData;
		private var _origin:PointHori;
		private var _isChanged:Boolean;
		private var uvtData:Vector.<Number>;
		private var indices:Vector.<int>;
		private var vertices:Vector.<Number>;
		public function TrianglePlane(bmd:BitmapData,segW:int = 10,segH:int = 10)
		{
			this.segW = segW;
			this.segH = segH;
			
			indices = new Vector.<int>();
			for (var i:int = 0; i < segH; i++) {
				for (var j:int = 0; j < segW; j++) {
					indices.push(i * (segW+1) + j, i * (segW+1) + j + 1, (i + 1) * (segW+1) + j);
					indices.push(i * (segW+1) + j + 1, (i + 1) * (segW+1) + 1 + j, (i + 1) * (segW+1) + j);
				}
			}
			bitmapData = bmd;
			
		}

		public function dispose():void {
			Hori.enterFrame.remove(draw);
			_origin = null;
		}
		public function get origin():PointHori
		{
			return _origin;
		}
		public function get bitmapData():BitmapData
		{
			return _bmd || null;
		}
		public function set bitmapData(bmd:BitmapData):void
		{
			this._bmd = bmd;
			var w:int = bmd.width;
			var h:int = bmd.height;
			uvtData = new Vector.<Number>();
			var temp:PointHori = _origin = new PointHori(0,0);
			for (var i:int = 0; i <= segH; i++) {
				for (var j:int = 0; j <= segW; j++) {
					uvtData[uvtData.length] = j / segW;
					uvtData[uvtData.length] = i / segH;
					var p:PointHori = new PointHori(j/segW*w,i/segH*h);
					p.update.add(onPointUpdateHandler);
					temp.next = p;
					temp = p;
				}
			}
			
			draw();
			
		}
		public function attachDisplayObject(doj:DisplayObject,forceRender:Boolean = false):void
		{
//			if(!doj.parent){
//				return;
//			}
//			var rec:Rectangle = RecUtil.getVisibleBounds(doj,doj.parent);
			var bmd:BitmapData = _bmd.clone();
			bmd.fillRect(_bmd.rect,0x00FFFFFF);
			
			bmd.draw(doj,doj.transform.matrix);
			this._bmd = bmd;
			if(forceRender)
				draw();
		}
		private function onPointUpdateHandler():void
		{
			Hori.enterFrame.addOnce(draw);
		}

		public function draw():void
		{
//			Hori.enterFrame.remove(draw);
			if(!_origin){
				return;
			}
			vertices = new Vector.<Number>();
			var temp:PointHori = _origin;
			var p:PointHori;
			while(temp.next){
				p = temp.next;
				vertices[vertices.length] = p.x;
				vertices[vertices.length] = p.y;
				temp = temp.next;
			}
			var g:Graphics = this.graphics;
			g.clear();
			g.beginBitmapFill(_bmd);
			g.drawTriangles(vertices, indices, uvtData);
			g.endFill();
		}
		public function reset():void
		{
			var p:PointHori = _origin;
			while(p.next){
				p.x = p.initX;
				p.y = p.initY;
				p = p.next;
			}
			
		}

	}
}