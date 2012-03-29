package com.horidream.components
{
	import com.greensock.TweenMax;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jul 8, 2010 3:22:32 PM
	 */
	public final class SimpleScrollPane extends MovieClip
	{
		private var slider:MovieClip;
		private var dragger:MovieClip;
		private var rail:MovieClip;
		private var dragRec:Rectangle;
		private var _content:DisplayObject;
		private var easing:Boolean;
		private var _contentHeight:Number;
		private var _numPerPage:Number;
		private var _height:Number;
		private var _value:Number;
		private var _minimum:Number;
		private var _maximum:Number;
		private var tempValue:Number;
		private var interplateValue:Number;
		private var freezeDraggerHeiht:Boolean;
		private var autoHide:Boolean;
		public function SimpleScrollPane(dragger:MovieClip,
										 rail:MovieClip,
										 content:DisplayObject,
										 container:DisplayObjectContainer = null,
										 easing:Boolean = true,
										 freezeDraggerHeiht:Boolean = false,
										 autoHide:Boolean = false,
										 startValue:Number = 0)
		{
			
			this.dragger = dragger;
			dragger.buttonMode = true;
			this.rail = rail;
			this.rail.x = int(this.rail.x);
			dragger.x = rail.x + (rail.width-dragger.width)/2;
			dragger.y = rail.y;
			_content = content;
			_contentHeight = content.height;
			_value = startValue;
			this.easing = easing;
			this.freezeDraggerHeiht = freezeDraggerHeiht;
			this.autoHide = autoHide;
			
			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
			if(container){
				container.addChild(this);
			}
			
		}
		


		public function get content():DisplayObject
		{
			return _content;
		}

		public function set content(value:DisplayObject):void
		{
			QuickSetter.removeSelf(_content);
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_content = value;
			_content.scrollRect = null;
			_contentHeight = content.height;
			_value = 0;
			dragger.y = rail.y;
			init();
		}

		public function get value():Number
		{
			return _value/(_contentHeight - rail.height);
		}

		public function set value(value:Number):void
		{
			_value = Math.max(0,Math.min((_maximum-_minimum),value*(_contentHeight - rail.height)));
			dragger.y = _value*(rail.height-dragger.height)/(_maximum-_minimum)+rail.y;
			tempValue = content.scrollRect.y;
			if(easing){
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else{
				content.scrollRect = new Rectangle(0,_value,content.width,_numPerPage);
			}
		}
		public function refresh():void{
			
			_content.scrollRect = null;
			var rec:Rectangle = RecUtil.getVisibleBounds(content);
			_contentHeight = rec.height;
			dragger.x = rail.x + (rail.width-dragger.width)/2;
			dragger.y = rail.y;
			init();
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE,init);
//			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			
			_minimum = 0;
			_maximum = Math.max(0,content.height-rail.height);
			_height = rail.height;
			
			_numPerPage = rail.height;
			dragger.height = freezeDraggerHeiht?dragger.height:Math.min(_numPerPage/content.height*rail.height,rail.height);
//			dragger.height = _numPerPage/(_maximum-_minimum)*rail.height;
			dragRec = new Rectangle(dragger.x,dragger.y,0,rail.height-dragger.height);
			
			slider = new MovieClip();
			slider.addChild(rail);
			slider.addChild(dragger);
			addChild(content);
			addChild(slider);
			content.scrollRect = new Rectangle(0,0,content.width,_numPerPage);
			if(_numPerPage >= _contentHeight)
			{
				if(autoHide)
					slider.visible = false;
			}else{
				slider.visible = true;
				dragger.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				
			}
			
			
		}

//		private function onRemovedFromStage(event:Event):void
//		{
//			dragger.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//		}

		private function onMouseDown(event:MouseEvent):void
		{
			dragger.startDrag(false,dragRec);
			dragger.mouseEnabled = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			event.stopImmediatePropagation();
		}

		private function onMouseUp(event:MouseEvent):void
		{
			
			dragger.stopDrag();
			onMouseMove();
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
			event.stopImmediatePropagation();
			dragger.mouseEnabled = true;
		}

		private function onMouseMove(event:MouseEvent = null):void
		{
			_value = (dragger.y-rail.y)/(rail.height-dragger.height)*(_maximum-_minimum) ;
			tempValue = content.scrollRect.y;
			if(easing){
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else{
				content.scrollRect = new Rectangle(0,_value,content.width,_numPerPage);
			}
			
			
		}

		private function onEnterFrame(event:Event):void
		{
			tempValue = tempValue+(_value-tempValue)*.15;
			content.scrollRect = new Rectangle(0,tempValue,content.width,_numPerPage);
			if(Math.abs(tempValue - _value)<=1){
				content.scrollRect = new Rectangle(0,_value,content.width,_numPerPage);
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				
			}
		}
	}
}