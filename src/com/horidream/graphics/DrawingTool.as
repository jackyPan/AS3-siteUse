package com.horidream.graphics
{
	import com.horidream.util.BitmapDataUtil;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.utils.BitmapUtil;
	

	public class DrawingTool
	{
		public static var clearBeforeDraw:Boolean = true;
		public function DrawingTool()
		{
			throw(new Error("Can't instanciate a static class"));
		}
		public static function drawPoly(container:DisplayObject,size:Number = 50,vertex:uint = 3,  color:uint = 0x000000, lineThickness:Number = 1, lineColor:Number = 0x000000) :void 
		{
			if (vertex < 2) { return};
			var sprite:*
			if(container is Shape || container is Sprite){
				sprite = container;
			}else{
				return;
			}
			if(clearBeforeDraw){
				sprite.graphics.clear();
			}
			sprite.graphics.beginFill(color);
			if (lineThickness != 0)
				sprite.graphics.lineStyle(lineThickness, lineColor);
			
			var angle:Number,i:uint;
			i=0;
			angle = Math.PI / 2 - (Math.PI / vertex + (2 * Math.PI / vertex) * i);
			sprite.graphics.moveTo(size * Math.cos(angle), size * Math.sin(angle));
			
			for (i = 1; i < vertex; i++ ) {
				angle = Math.PI / 2 - (Math.PI / vertex + (2 * Math.PI / vertex) * i);
				sprite.graphics.lineTo(size * Math.cos(angle), size * Math.sin(angle));
			}
			
			i=0;
			angle = Math.PI / 2 - (Math.PI / vertex + (2 * Math.PI / vertex) * i);
			sprite.graphics.lineTo(size * Math.cos(angle), size * Math.sin(angle));
			sprite.graphics.endFill();
			
			
		}
		public static function drawStar(container:DisplayObject, size:Number = 50, centerX:Number = 0, centerY:Number = 0,vertex:int = 5, pointSize:Number = .5,color:uint = 0xFF0000, lineThickness:Number = 1, lineColor:uint = 0x000000) :void 
		{
			if (size < 3) { return};
			var canvas:Graphics;
			if(container is Shape || container is Sprite){
				canvas = container['graphics'];
			}else if(container is DisplayObjectContainer){
				var shape:Shape = new Shape();
				(container as DisplayObjectContainer).addChild(shape);
				canvas = shape.graphics;
			}else{
				return;
				
			}
			
			var ro:Number;
			if (vertex%2==0) {
				ro = 0;
			} else {
				ro = Math.PI/(vertex*2);
			}
			var points:Array = [];
			for (var i:uint =0; i<vertex; i++) {
				var p:Point = new Point();
				var vertexDegree:Number = 360/vertex*i*Math.PI/180 - ro;
				p = Point.polar(size, vertexDegree);
				points.push(p);
				
				var p2:Point = new Point();
				var innerDegree:Number = 360/vertex*(i+.5)*Math.PI/180 - ro;
				p2 = Point.polar(size*pointSize, innerDegree);
				points.push(p2);
			}
			//使用lineTo等方法,连结各顶点
			var g:Graphics = canvas;
			if(clearBeforeDraw){
				g.clear();
			}
			if(lineThickness >= 0){
				g.lineStyle(lineThickness, lineColor,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			}
//			g.lineStyle(lineThickness,lineColor);
			g.beginFill(color);
			g.moveTo(points[0].x+centerX, points[0].y+centerY);
			for (i=1; i<points.length; i++) {
				g.lineTo(points[i].x+centerX, points[i].y+centerY);
			}
			g.lineTo(points[0].x+centerX, points[0].y+centerY);
			g.endFill();
			
		}
		public static function drawArc(container:DisplayObject, radius:Number = 50,centerX:Number = 0, centerY:Number = 0,beginAngle:Number=0,endAngle:Number=180 ,lineThickness:Number = 1, lineColor:uint = 0x000000) :void 
		{
			if (beginAngle == endAngle) { return};
			var canvas:Graphics;
			if(container is Shape || container is Sprite){
				canvas = container['graphics'];
			}else if(container is DisplayObjectContainer){
				var shape:Shape = new Shape();
				(container as DisplayObjectContainer).addChild(shape);
				canvas = shape.graphics;
			}else{
				return;
				
			}
			if(clearBeforeDraw){
				canvas.clear();
			}			
			canvas.lineStyle(lineThickness, lineColor,1,false,"normal",CapsStyle.NONE,JointStyle.MITER);
			
			if (Math.abs(beginAngle - endAngle) >= 360)
			{
				beginAngle = endAngle + 360;
			}
			var beginRadian:Number = beginAngle*Math.PI/180;
			var endRadian:Number = endAngle*Math.PI/180;
			canvas.moveTo(radius * Math.cos(beginRadian)+centerX, radius * Math.sin(beginRadian)+centerY);
			var long_radius:Number = radius / Math.cos(((endRadian - beginRadian) / 2) / 8);
			var angleDelta:Number = (endRadian - beginRadian) / 8;
			var angle:Number = beginRadian;
			
			for (var i:uint = 0; i < 8; i++ )
			{
				angle += angleDelta;
				var anchorX:Number = radius * Math.cos(angle);
				var anchorY:Number = radius * Math.sin(angle);
				var contrlX:Number = long_radius * Math.cos((angle + angle-angleDelta) / 2);
				var contrlY:Number = long_radius * Math.sin((angle + angle-angleDelta) / 2);
				canvas.curveTo(contrlX+centerX, contrlY+centerY, anchorX+centerX, anchorY+centerY);
			}
			
			
		}
		public static function drawCircle(container:DisplayObject, radius:Number = 50,centerX:Number = 0, centerY:Number = 0, filledColor:* = 0x000000,filledAlpha:Number = 0, lineThickness:Number = 1, lineColor:uint = 0x000000) :void 
		{
			var canvas:Graphics;
			if(container is Shape || container is Sprite){
				canvas = container['graphics'];
			}else if(container is DisplayObjectContainer){
				var shape:Shape = new Shape();
				(container as DisplayObjectContainer).addChild(shape);
				canvas = shape.graphics;
			}else{
				return;
				
			}
			if(clearBeforeDraw){
				canvas.clear();
			}	
			if(lineThickness != 0){
				canvas.lineStyle(lineThickness, lineColor);
			}
			if(filledColor is BitmapData){
				canvas.beginBitmapFill(filledColor as BitmapData);
			}else if(filledColor is Number){
				canvas.beginFill(filledColor,filledAlpha);
			}
			canvas.drawCircle(centerX,centerY,radius);
			canvas.endFill();
		}
		public static function drawRect(container:DisplayObject,rec:Rectangle,scale:Number = 1,xOffset:Number = 0, yOffset:Number = 0,  filledColor:* = 0x000000,filledAlpha:Number = 0, lineThickness:Number = 1, lineColor:uint = 0x000000) :void 
		{
			var canvas:Graphics;
			if(container is Shape || container is Sprite){
				canvas = container['graphics'];
			}else if(container is DisplayObjectContainer){
				var shape:Shape = new Shape();
				(container as DisplayObjectContainer).addChild(shape);
				canvas = shape.graphics;
			}else{
				return;
				
			}
			if(clearBeforeDraw){
				canvas.clear();
			}	
			if(lineThickness != 0){
				canvas.lineStyle(lineThickness, lineColor);
			}
			if(filledColor is BitmapData){
				canvas.beginBitmapFill((filledColor as BitmapData),new Matrix(scale,0,0,scale,(rec.x+xOffset),(rec.y+yOffset)),true,true);
			}else if(filledColor is Number){
				canvas.beginFill(filledColor,filledAlpha);
			}else if(filledColor is String)
			{
				var filledBmd:BitmapData = BitmapDataUtil.getPattern(filledColor,rec);
				if(filledBmd)
					canvas.beginBitmapFill(filledBmd,new Matrix(scale,0,0,scale,(rec.x+xOffset),(rec.y+yOffset)),true,true);
			}
			canvas.drawRect(rec.x*scale+xOffset,rec.y*scale+yOffset,rec.width*scale,rec.height*scale);
			canvas.endFill();
		}
		
		static public function drawGradientRect(container:DisplayObject,rec:Rectangle, colors:Array, alphas:Array, ratios:Array = null, rotation:Number = 0):DisplayObject {
			var graphics:Graphics;
			if(container is Shape || container is Sprite){
				graphics = container['graphics'];
			}else if(container is DisplayObjectContainer){
				var shape:Shape = new Shape();
				(container as DisplayObjectContainer).addChild(shape);
				graphics = shape.graphics;
			}else{
				return null;
				
			}
			
			var i:int, rts:Array = new Array();
			if(ratios == null) for (i = 0; i < colors.length; i++) rts.push(int(255 * i / (colors.length - 1)));
			else rts = ratios;
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(rec.width, rec.height, Math.PI / 180 * rotation, rec.x, rec.y);
			if (colors.length == 1 && alphas.length == 1) graphics.beginFill(colors[0], alphas[0]);
			else graphics.beginGradientFill("linear", colors, alphas, rts, mtx);
			graphics.drawRect(rec.x, rec.y, rec.width, rec.height);
			graphics.endFill();
			return container;
		}
	}
}