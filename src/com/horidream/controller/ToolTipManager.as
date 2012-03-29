package com.horidream.controller
{
	import com.horidream.display.HoriText;
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 14, 2011
	 */
	public class ToolTipManager
	{
		private var target:InteractiveObject;
		private var msg:String;
		private var msgText:TextField;
		private var msgBox:MessageBox;
		private var offset:Point;
		private static var tipList:Dictionary = new Dictionary();
		private static var fontName:String = "";
		private static var fontSize:int = 12;
		private static var fontColor:uint = 0;
		private static var boxWidth:Number = 150;
		public function ToolTipManager(target:InteractiveObject, msg:String, msgText:TextField = null)
		{
			this.target = target;  
			this.msg = msg;  
			if(msgText){
				this.msgText = msgText;  
			}else{
				this.msgText = HoriText.addText(null,msg,fontSize,boxWidth,fontColor,fontName);
				msgBox = new MessageBox(this.msgText);
				QuickSetter.set(this.msgText,{x:MessageBox.roundCorner/4+3,y:5});
				msgBox.addChild(this.msgText);
				offset = new Point(-msgBox.width/2,-msgBox.height-10);
			}
			target.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			target.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		public function dispose():void{
			target.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			target.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			QuickSetter.removeSelf(msgBox);
		}
		private function onRollOut(e:MouseEvent):void
		{
			msgText.text = "";
			if(msgBox){
				QuickSetter.removeSelf(msgBox);
			}
			target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			showTip();
		}
		public function showTip():void {
			msgText.text = msg;
			if(msgBox && target.stage){
				target.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				target.stage.addChild(msgBox);
				var p:Point = new Point(target.stage.mouseX,target.stage.mouseY);
				QuickSetter.set(msgBox,{x:p.x+offset.x,y:p.y+offset.y});
			}
			onMouseMove(null);
		}
		private function onMouseMove(e:MouseEvent):void
		{
			var p:Point = new Point(target.mouseX,target.mouseY);
			p = target.localToGlobal(p);
			p = p.add(offset);
			var stageTopLeft:Point = new Point();
			var stageBottomRight:Point = new Point(target.stage.stageWidth,target.stage.stageHeight);
			stageBottomRight = stageBottomRight.subtract(new Point(msgBox.width,msgBox.height));
			QuickSetter.set(msgBox,{x:HoriMath.bound(p.x,stageTopLeft.x,stageBottomRight.x),y:HoriMath.bound(p.y,stageTopLeft.y,stageBottomRight.y)});
			msgBox.update(msgBox.mouseX,msgBox.mouseY);
			if(e)
				e.updateAfterEvent();
		}
		
		
		public static function addTip(target:InteractiveObject,msg:String,msgText:TextField = null):ToolTipManager
		{
			if((!msg) || (msg.replace(" ","") =="")){
				return null;
			}
			if(tipList[target]){
				(tipList[target] as ToolTipManager).dispose();
			}
			tipList[target] = new ToolTipManager(target,msg,msgText);
			if(target.getRect(target).contains(target.mouseX,target.mouseY))
			{
				(tipList[target] as ToolTipManager).showTip();
			}
			return tipList[target] as ToolTipManager;
		}
		public static function removeTip(target:InteractiveObject):void{
			if(tipList[target]){
				(tipList[target] as ToolTipManager).dispose();
				delete tipList[target];
			}
		}
		public static function changeStyle(style:Object):void{
			fontName = style.fontName || fontName;
			fontSize = style.fontSize || fontSize;
			fontColor = style.fontColor == null? fontColor:style.fontColor;
			boxWidth = style.boxWidth || boxWidth;
			MessageBox.boxColor = style.boxColor == null? MessageBox.boxColor:style.boxColor;
			MessageBox.roundCorner = style.roundCorner == null? MessageBox.roundCorner:style.roundCorner;
		}
	}
}
import com.horidream.display.HoriText;
import com.horidream.util.QuickSetter;

import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;

class MessageBox extends Sprite{
	private var shape:Shape = new Shape();
	private var w:Number;
	private var h:Number;
	private var currentBoxColor:uint = 0xFFFFFF;
	public static var boxColor:uint = 0xFFFFFF;
	public static var roundCorner:Number = 8;
	
	public function MessageBox(textField:TextField):void{
		this.blendMode = "layer";
		this.alpha = .9;
		var rec:Rectangle = textField.getBounds(textField);
		QuickSetter.disableMouse(this);
		w = rec.x+rec.width+roundCorner/2+6;
		h = rec.y+rec.height+10;
		this.graphics.beginFill(boxColor);
		currentBoxColor = boxColor;
		this.graphics.drawRoundRect(0,0,w,h,roundCorner,roundCorner);
		this.graphics.endFill();
		
		addChild(shape);
		this.filters = [new DropShadowFilter(2)];
	}
	public function update(xpos:Number,ypos:Number):void{
		
		shape.graphics.clear();
		shape.graphics.moveTo(w/2-18,h);
		shape.graphics.beginFill(currentBoxColor);
		shape.graphics.lineTo(xpos,ypos);
		shape.graphics.lineTo(w/2,h);
		shape.graphics.endFill();
	}
}
