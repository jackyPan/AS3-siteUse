package com.horidream.display
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Cover extends Sprite
	{
		private static const FREEZE_FRAME_RATE:Number = 0.000001;
		private var parentMovie:Sprite;
		private var text:String;
		private var textColor:uint;
		private var coverSquare:Sprite;
		private var coverText:TextField;
		private var blurredParent:Bitmap;
		
		private var stageW:Number; 
		private var stageH:Number;
		private var currentFrameRate:Number;
		public function Cover(parent:Sprite,text:String = null,textColor:uint=0x0)
		{
			parentMovie = parent;
			this.text = text;
			this.textColor = textColor;
			parent.addChild(this);
			if(parent.stage){
				Hori.initialize(parent.stage);
				stageW = parent.stage.stageWidth;
				stageH = parent.stage.stageHeight;
				getFrameRate();
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
			
			
			
		}

		private function init():void
		{
			// Build the "disabled" state
			// 构建暂停状态
			coverSquare = new Sprite();
			coverSquare.graphics.beginFill(0x000000,0.05);
			coverSquare.graphics.drawRect(0,0,stageW,stageH);
			coverSquare.graphics.endFill();
			addChild(coverSquare);
			
			// Prep for blurred parent
			// 准备模糊效果的父容器
			blurredParent = new Bitmap();
			this.addChild(blurredParent);
			
			// Create explanatory text
			// 生成提示文字
			var format1:TextFormat = new TextFormat();
			format1.color = textColor;
			format1.size = 12;
			format1.align = "left";
			coverText = new TextField();
			if(!text){
				coverText.text = "http://www.horidream.com/blog\n鼠标进入场景后激活动画";
			} else {
				coverText.text = text;
			}
			coverText.setTextFormat(format1);
			coverText.width = stageW;
			
			parentMovie.stage.addEventListener(Event.MOUSE_LEAVE,showCover);
			parentMovie.stage.addEventListener(MouseEvent.MOUSE_OVER,hideCover);
			this.addEventListener(Event.ENTER_FRAME,initCover);
			parentMovie.stage.addEventListener(Event.RESIZE,onAddedToStage);
		}


		private function onAddedToStage(event:Event):void
		{
			stageW = parent.stage.stageWidth;
			stageH = parent.stage.stageHeight;		
			getFrameRate();
			init();
		}
		private function getFrameRate(e:Event = null):void{
			if(parentMovie.stage.frameRate != FREEZE_FRAME_RATE)
				currentFrameRate = parentMovie.stage.frameRate;
		}
		private function hideCover(e:MouseEvent):void
		{
			if(e.stageX <= stageW && e.stageX >= 0 && e.stageY <= stageH && e.stageY >= 0){
				this.visible = false;
				e.updateAfterEvent();
			}
		}
		private function showCover(e:Event):void
		{
			
			if(!this.visible){
				refresh();
			}
			// Turn on cover
			// 关闭cover
			this.visible = true;
			
		}
		private function initCover(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,initCover);
			refresh();
			// Turn on cover
			// 打开cover
			this.visible = true;			
		}
		public function refresh():void
		{
			var bits:BitmapData = new BitmapData(stageW,stageH);
			bits.draw(coverSquare);
			bits.draw(parentMovie);
			var backgroundImage:Bitmap = new Bitmap(bits);
			backgroundImage.filters = new Array( new BlurFilter(6,6,4) );
			
			// Copy the blurred text and add the text
			// 复制并添加模糊文字
			var textOverlay:BitmapData = new BitmapData(stageW,stageW,false);
			textOverlay.draw(backgroundImage);
			textOverlay.draw(coverText,new Matrix(1,0,0,1),null,null,null,true);
			blurredParent.bitmapData = textOverlay;
		}
		override public function set visible(value:Boolean) : void{
			super.visible = value;
			if(stage){
				stage.frameRate = (value?FREEZE_FRAME_RATE:currentFrameRate);
			}
		}
	}
}