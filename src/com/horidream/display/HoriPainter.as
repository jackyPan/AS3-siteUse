package com.horidream.display
{
	import com.horidream.graphics.DrawingTool;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Mar 3, 2011
	 */
	public class HoriPainter
	{
		static public function createCloud(width:int, height:int, seed:int, contrast:Number = 1, color:uint = 0xFFFFFF, light:uint = 0xFFFFFF, shadow:uint = 0xDDDDDD):BitmapData {
			var gradiation:Sprite = new Sprite();
			var drawMatrix:Matrix = new Matrix();
			drawMatrix.createGradientBox(width, height);
			gradiation.graphics.beginGradientFill("radial", [0x000000, 0x000000], [0, 1], [0, 255], drawMatrix);
			gradiation.graphics.drawRect(0, 0, width, height);
			gradiation.graphics.endFill();
			var alphaBmp:BitmapData = new BitmapData(width, height);
			alphaBmp.perlinNoise(width / 3, height / 2.5, 5, seed, false, true, 1|2|4, true);
			var zoom:Number = 1 + (contrast - 0.1) / (contrast + 0.9);
			if (contrast < 0.1) zoom = 1;
			if (contrast > 2.0) zoom = 2;
			var ctMatrix:Array = [contrast + 1, 0, 0, 0, -128 * contrast, 0, contrast + 1, 0, 0, -128 * contrast, 0, 0, contrast + 1, 0, -128 * contrast, 0, 0, 0, 1, 0];
			alphaBmp.draw(gradiation, new Matrix(zoom, 0, 0, zoom, -(zoom - 1) / 2 * width, -(zoom - 1) / 2 * height));
			alphaBmp.applyFilter(alphaBmp, alphaBmp.rect, new Point(), new ColorMatrixFilter(ctMatrix));
			var image:BitmapData = new BitmapData(width, height, true, 0xFF << 24 | color);
			image.copyChannel(alphaBmp, alphaBmp.rect, new Point(), 4, 8);
			image.applyFilter(image, image.rect, new Point(), new GlowFilter(light, 1, 4, 4, 1, 3, true));
			var bevelSize:Number = Math.min(width, height) / 30;
			image.applyFilter(image, image.rect, new Point(), new BevelFilter(bevelSize, 45, light, 1, shadow, 1, bevelSize/5, bevelSize/5, 1, 3));
			var image2:BitmapData = new BitmapData(width, height, true, 0);
			image2.draw(DrawingTool.drawGradientRect(new Shape(),new Rectangle(0,0,width, height), [light, color, shadow], [1, 0.2, 1], null, 90), null, null, BlendMode.MULTIPLY);
			image2.copyChannel(alphaBmp, alphaBmp.rect, new Point(), 4, 8);
			image.draw(image2, null, null, BlendMode.MULTIPLY);
			alphaBmp.dispose();
			return image;
		}
	}
}