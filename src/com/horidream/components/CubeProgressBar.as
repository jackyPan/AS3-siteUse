package com.horidream.components
{
	import com.horidream.interfaces.IProgressBar;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created May 21, 2010 
	 */
	public class CubeProgressBar extends Sprite implements IProgressBar
	{
		private var cube:Cube;
		public function CubeProgressBar(width:Number = 30,height:Number = 100,container:DisplayObjectContainer = null,xPos:Number = 0,yPos:Number = 0)
		{
			cube = new Cube(width,height);
			var rec:Rectangle = cube.getRect(this);
			cube.x = 0;
			cube.y = (-rec.top - rec.bottom )/2 ;
			this.addChild(cube);
			if(container){
				container.addChild(this);
				this.x = xPos;
				this.y = yPos;
			}
			showProgress(0);
		}
		
		public function showProgress(percent:int):void
		{
			cube.progress(percent);
		}
	}
}


import flash.display.Sprite;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;

class Cube extends Sprite {
	private var cube:Sprite;
	private var _width:uint = 30;
	private var _height:uint = 30;
	private var corner:Number;
	private static var bColor:uint = 0xFFFFFF;
	private static var sColor:uint = 0x000000;
	private static var cColor:uint = 0x0099FF;
	private static var eColor:uint = 0xCCCCCCC;
	private static var s1Color:uint = 0x0000FF;
	private static var s2Color:uint = 0x0099FF;
	private static var cos:Number;
	private static var sin:Number;
	private var base:Shape;
	private var back:Shape;
	private var bottom:Shape;
	private var progBL:Shape;
	private var progBR:Shape;
	private var prog:Shape;
	private var progFL:Shape;
	private var progFR:Shape;
	private var maskBL:Shape;
	private var maskBR:Shape;
	private var maskFL:Shape;
	private var maskFR:Shape;
	private var surface:Sprite;
	private var top:Shape;
	private var frame:Shape;
	private var shade:DropShadowFilter;
	private var backShade:DropShadowFilter;
	private var matrixC:Matrix;
	private var matrixL:Matrix;
	private var matrixR:Matrix;
	private var baseLevel:Number;
	private var backLevel:Number;
	private var frontLevel:Number;
	private var _percent:Number = 50;
	
	public function Cube(w:uint, h:uint) {
		_width = w;
		_height = h;
		corner = _width*0.08;
		initialize();
	}
	
	private function initialize():void {
		shade = new DropShadowFilter(10, 90, sColor, 0.5, 16, 8, 2, 3, false, false);
		backShade = new DropShadowFilter(0, 90, sColor, 0.2, 4, 4, 1.5, 2, false, false);
		cos = Math.cos(60*Math.PI/180);
		sin = Math.sin(60*Math.PI/180);
		matrixC = new Matrix(sin, -cos, sin, cos, 0, 0);
		matrixL = new Matrix(sin, cos, 0, 1, 0, 0);
		matrixR = new Matrix(sin, -cos, 0, 1, 0, 0);
		draw();
		progress(percent);
	}
	private function draw():void {
		cube = new Sprite();
		addChild(cube);
		cube.y = _width*0.5- _height*0.5;
		base = new Shape();
		back = new Shape();
		bottom = new Shape();
		progBL = new Shape();
		progBR = new Shape();
		prog = new Shape();
		progFL = new Shape();
		progFR = new Shape();
		maskBL = new Shape();
		maskBR = new Shape();
		maskFL = new Shape();
		maskFR = new Shape();
		surface = new Sprite();
		top = new Shape();
		frame = new Shape();
		cube.addChild(base);
		cube.addChild(back);
		cube.addChild(bottom);
		cube.addChild(progBL);
		cube.addChild(progBR);
		cube.addChild(prog);
		cube.addChild(progFL);
		cube.addChild(progFR);
		cube.addChild(maskBL);
		cube.addChild(maskBR);
		cube.addChild(maskFL);
		cube.addChild(maskFR);
		cube.addChild(surface);
		cube.addChild(top);
		cube.addChild(frame);
		createBox(base, _width, _width, corner, sColor, 0.3);
		createPentagon(back, _width, _height, corner);
		createBox(bottom, _width, _width, corner, cColor);
		createProg(progBL, _width, _height);
		createProg(progBR, _width, _height);
		createTop(prog, _width+corner*0.5);
		createProg(progFL, _width, _height);
		createProg(progFR, _width, _height);
		createBox(maskBL, _width, _height, corner, sColor);
		createBox(maskBR, _width, _height, corner, sColor);
		createBox(maskFL, _width, _height, corner, sColor);
		createBox(maskFR, _width, _height, corner, sColor);
		createSurface(surface, _width, _height, corner);
		createBox(top, _width, _width, corner, eColor, 0.6);
		createFrame(frame, _width, _height, corner);
		base.transform.matrix = matrixC;
		bottom.transform.matrix = matrixC;
		progBL.transform.matrix = matrixR;
		progBR.transform.matrix = matrixL;
		prog.transform.matrix = matrixC;
		progFL.transform.matrix = matrixL;
		progFR.transform.matrix = matrixR;
		maskBL.transform.matrix = matrixR;
		maskBR.transform.matrix = matrixL;
		maskFL.transform.matrix = matrixL;
		maskFR.transform.matrix = matrixR;
		top.transform.matrix = matrixC;
		baseLevel = _height*cos - corner*0.5;
		backLevel = _width*cos - _width*sin + corner*1.5;
		frontLevel = _width - _width*sin + corner*1.5;
		base.y = baseLevel + corner*1.5;
		bottom.y = baseLevel + corner;
		progBL.x = maskBL.x = - _width*cos + corner*0.5;
		progBL.y = backLevel + corner*0.5;
		maskBL.y = backLevel;
		progBR.x = maskBR.x = _width*cos - corner*0.5;
		progBR.y = backLevel + corner*0.5;
		maskBR.y = backLevel;
		progFL.x = maskFL.x = - _width*cos + corner*0.5;
		progFL.y = maskFL.y = frontLevel;
		progFR.x = maskFR.x = _width*cos - corner*0.5;
		progFR.y = maskFR.y = frontLevel;
		top.y = - baseLevel - corner;
		base.filters = [shade];
		back.filters = [backShade];
		progBL.mask = maskBL;
		progBR.mask = maskBR;
		prog.mask = surface;
		progFL.mask = maskFL;
		progFR.mask = maskFR;
	}
	public function get percent():Number {
		return _percent;
	}
	public function set percent(param:Number):void {
		_percent = param;
	}
	public function progress(percent:Number):void {
		if (percent < 0) percent = 0;
		if (percent > 100) percent = 100;
		var level:Number = _height*0.5 - percent*(_height - corner*2)/100;
		progBL.y =  progBR.y = backLevel + level;
		prog.y = level;
		progFL.y =  progFR.y = frontLevel + level;
	}
	private function createBox(target:Shape, w:uint, h:uint, c:uint, color:uint, alpha:Number = 1):void {
		target.graphics.clear();
		target.graphics.beginFill(color, alpha);
		target.graphics.drawRoundRect(-w*0.5, -h*0.5, w, h, c*2);
		target.graphics.endFill();
	}
	private function createProg(target:Shape, w:uint, h:uint):void {
		target.graphics.clear();
		target.graphics.beginFill(eColor, 0.6);
		target.graphics.moveTo(-w*0.5, -h);
		target.graphics.lineTo(w*0.5, -h);
		target.graphics.lineTo(w*0.5, 0);
		target.graphics.lineTo(-w*0.5, 0);
		target.graphics.lineTo(-w*0.5, -h);
		target.graphics.endFill();
		var colors:Array = [s1Color, s2Color];
		var alphas:Array = [0.6, 0.6];
		var ratio:Array = [0, 255];
		var matrixP:Matrix = new Matrix();
		matrixP.createGradientBox(w, h, 0.5*Math.PI, 0, 0);
		target.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratio, matrixP, SpreadMethod.PAD, InterpolationMethod.RGB, 0.75);
		target.graphics.drawRect(-w*0.5, 0, w, h);
		target.graphics.endFill();
	}
	private function createTop(target:Shape, w:uint):void {
		target.graphics.clear();
		target.graphics.beginFill(s1Color, 0.4);
		target.graphics.drawRect(-w*0.5, -w*0.5, w, w);
		target.graphics.endFill();
	}
	private function createSurface(target:Sprite, w:uint, h:uint, c:Number):void {
		target.graphics.clear();
		var top:Shape = new Shape();
		var left:Shape = new Shape();
		var right:Shape = new Shape();
		target.addChild(top);
		target.addChild(left);
		target.addChild(right);
		createBox(top, w, w, c, sColor);
		createBox(left, w, h, c, sColor);
		createBox(right, w, h, c, sColor);
		top.transform.matrix = matrixC;
		left.transform.matrix = matrixL;
		right.transform.matrix = matrixR;
		top.y = - h*cos - c*0.5;
		left.x = - w*cos + c*0.5;
		left.y = w - w*sin + c*1.5;
		right.x = w*cos - c*0.5;
		right.y = w - w*sin + c*1.5;
	}
	private function createPentagon(target:Shape, w:uint, h:uint, c:Number):void {
		var pw:int = w+c;
		var ph:int = h+c;
		target.graphics.clear();
		target.graphics.beginFill(bColor);
		target.graphics.moveTo(-c*sin, -ph*0.5-pw*0.5+c*cos);
		target.graphics.curveTo(0, -ph*0.5-pw*0.5, c*sin, -ph*0.5-pw*0.5+c*cos);
		target.graphics.lineTo(pw*sin-c*sin, -ph*cos-c*cos);
		target.graphics.curveTo(pw*sin, -ph*cos, pw*sin, -ph*cos+c);
		target.graphics.lineTo(pw*sin, ph*cos-c);
		target.graphics.curveTo(pw*sin, ph*cos, pw*sin-c*sin, ph*cos+c*cos);
		target.graphics.lineTo(c*sin, ph*0.5+pw*0.5-c*cos);
		target.graphics.curveTo(0, ph*0.5+pw*0.5, -c*sin, ph*0.5+pw*0.5-c*cos);
		target.graphics.lineTo(-pw*sin+c*sin, ph*cos+c*cos);
		target.graphics.curveTo(-pw*sin, ph*cos, -pw*sin, ph*cos-c);
		target.graphics.lineTo(-pw*sin, -ph*cos+c);
		target.graphics.curveTo(-pw*sin, -ph*cos, -pw*sin+c*sin, -ph*cos-c*cos);
		target.graphics.endFill();
	}
	private function createFrame(target:Shape, w:uint, h:uint, c:Number):void {
		var ow:int = w+c;
		var oh:int = h+c;
		var iw:Number = w-c*0.5;
		var ih:Number = h-c*0.5;
		target.graphics.clear();
		target.graphics.beginFill(bColor);
		target.graphics.moveTo(c*sin, -ih*0.5+iw*0.5-c*cos-c*0.5);
		target.graphics.curveTo(0, -ih*0.5+iw*0.5-c*0.5, -c*sin, -ih*0.5+iw*0.5-c*cos-c*0.5);
		target.graphics.lineTo(-iw*sin+c*sin, -ih*cos+c*cos-c*0.5);
		target.graphics.curveTo(-iw*sin, -ih*cos-c*0.5, -iw*sin+c*sin, -ih*cos-c*cos-c*0.5);
		target.graphics.lineTo(-c*sin, -ih*0.5-iw*0.5+c*cos-c*0.5);
		target.graphics.curveTo(0, -ih*0.5-iw*0.5-c*0.5, c*sin, -ih*0.5-iw*0.5+c*cos-c*0.5);
		target.graphics.lineTo(iw*sin-c*sin, -ih*cos-c*cos-c*0.5);
		target.graphics.curveTo(iw*sin, -ih*cos-c*0.5, iw*sin-c*sin, -ih*cos+c*cos-c*0.5);
		target.graphics.moveTo(c*0.5*sin, -ih*0.5+iw*0.5+c+c*0.5*cos);
		target.graphics.curveTo(c*0.5*sin, -ih*0.5+iw*0.5+c*0.5*cos, c*sin+c*0.5*sin, -ih*0.5+iw*0.5-c*cos+c*0.5*cos);
		target.graphics.lineTo(iw*sin-c*sin+c*0.5*sin, -ih*cos+c*cos+c*0.5*cos);
		target.graphics.curveTo(iw*sin+c*0.5*sin, -ih*cos+c*0.5*cos, iw*sin+c*0.5*sin, -ih*cos+c+c*0.5*cos);
		target.graphics.lineTo(iw*sin+c*0.5*sin, ih*cos-c+c*0.5*cos);
		target.graphics.curveTo(iw*sin+c*0.5*sin, ih*cos+c*0.5*cos, iw*sin-c*sin+c*0.5*sin, ih*cos+c*cos+c*0.5*cos);
		target.graphics.lineTo(c*sin+c*0.5*sin, -ih*0.5+iw*0.5+ih-c*cos+c*0.5*cos);
		target.graphics.curveTo(c*0.5*sin, -ih*0.5+iw*0.5+ih+c*0.5*cos, c*0.5*sin, -ih*0.5+iw*0.5+ih-c+c*0.5*cos);
		target.graphics.moveTo(-c*sin-c*0.5*sin, -ih*0.5+iw*0.5-c*cos+c*0.5*cos);
		target.graphics.curveTo(-c*0.5*sin, -ih*0.5+iw*0.5+c*0.5*cos, -c*0.5*sin, -ih*0.5+iw*0.5+c+c*0.5*cos);
		target.graphics.lineTo(-c*0.5*sin, -ih*0.5+iw*0.5+ih-c+c*0.5*cos);
		target.graphics.curveTo(-c*0.5*sin, -ih*0.5+iw*0.5+ih+c*0.5*cos, -c*sin-c*0.5*sin, -ih*0.5+iw*0.5+ih-c*cos+c*0.5*cos);
		target.graphics.lineTo(-iw*sin+c*sin-c*0.5*sin, ih*cos+c*cos+c*0.5*cos);
		target.graphics.curveTo(-iw*sin-c*0.5*sin, ih*cos+c*0.5*cos, -iw*sin-c*0.5*sin, ih*cos-c+c*0.5*cos);
		target.graphics.lineTo(-iw*sin-c*0.5*sin, -ih*cos+c+c*0.5*cos);
		target.graphics.curveTo(-iw*sin-c*0.5*sin, -ih*cos+c*0.5*cos, -iw*sin+c*sin-c*0.5*sin, -ih*cos+c*cos+c*0.5*cos);
		target.graphics.moveTo(-c*sin, -oh*0.5-ow*0.5+c*cos);
		target.graphics.curveTo(0, -oh*0.5-ow*0.5, c*sin, -oh*0.5-ow*0.5+c*cos);
		target.graphics.lineTo(ow*sin-c*sin, -oh*cos-c*cos);
		target.graphics.curveTo(ow*sin, -oh*cos, ow*sin, -oh*cos+c);
		target.graphics.lineTo(ow*sin, oh*cos-c);
		target.graphics.curveTo(ow*sin, oh*cos, ow*sin-c*sin, oh*cos+c*cos);
		target.graphics.lineTo(c*sin, oh*0.5+ow*0.5-c*cos);
		target.graphics.curveTo(0, oh*0.5+ow*0.5, -c*sin, oh*0.5+ow*0.5-c*cos);
		target.graphics.lineTo(-ow*sin+c*sin, oh*cos+c*cos);
		target.graphics.curveTo(-ow*sin, oh*cos, -ow*sin, oh*cos-c);
		target.graphics.lineTo(-ow*sin, -oh*cos+c);
		target.graphics.curveTo(-ow*sin, -oh*cos, -ow*sin+c*sin, -oh*cos-c*cos);
		target.graphics.endFill();
	}
	
}