package com.horidream.components
{
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
	public final class SimpleScrollPaneHorizontal extends MovieClip
	{
		private var slider:MovieClip;
		private var dragger:MovieClip;
		private var rail:MovieClip;
		private var dragRec:Rectangle;
		private var _content:DisplayObject;
		private var easing:Boolean;
		private var _contentWidth:Number;
		private var _numPerPage:Number;
		private var _width:Number;
		private var _value:Number;
		private var _minimum:Number;
		private var _maximum:Number;
		private var tempValue:Number;
		private var interplateValue:Number;
		private var freezeDraggerHeiht:Boolean;
		private var autoHide:Boolean;
		public function SimpleScrollPaneHorizontal(dragger:MovieClip,
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
			dragger.y = rail.y + (rail.height-dragger.height)/2;
			dragger.x = rail.x;
			_content = content;
			_contentWidth = content.width;
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
			_contentWidth = content.width;
			_value = 0;
			dragger.x = rail.x;
			init();
		}
		
		public function get value():Number
		{
			return _value/(_contentWidth - rail.width);
		}
		
		public function set value(value:Number):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
//			_value = value*(_contentWidth - rail.width);
			_value = Math.min(1,value)*(_contentWidth - rail.width);
			dragger.x = _value*(rail.width-dragger.width)/(_maximum-_minimum)+rail.x;
			tempValue = content.scrollRect.x;
			if(easing){
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else{
				content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
			}
		}
		public function setContentValue(value:Number):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_value = value/(_contentWidth - rail.width);
			dragger.x = _value*(rail.width-dragger.width)/(_maximum-_minimum)+rail.x;
			tempValue = content.scrollRect.x;
			if(easing){
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else{
				content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
			}
		}
		private function setValue(value:Number):void
		{
			_value = Math.min(1,value)*(_contentWidth - rail.width);
			dragger.x = _value*(rail.width-dragger.width)/(_maximum-_minimum)+rail.x;
			tempValue = content.scrollRect.x;
			content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
		}


		public function refresh():void{
			_content.scrollRect = null;
			var rec:Rectangle = RecUtil.getVisibleBounds(content);
			_contentWidth = rec.width;
//			dragger.x = rail.x;
			init();
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE,init);
			//			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			
			_minimum = 0;
			_maximum = content.width-rail.width;
			_contentWidth = content.width;
			_width = rail.width;
			
			_numPerPage = rail.width;
			dragger.width = freezeDraggerHeiht?dragger.width:Math.min(_numPerPage/content.width*rail.width,rail.width);
			//			dragger.height = _numPerPage/(_maximum-_minimum)*rail.height;
			dragRec = new Rectangle(rail.x,dragger.y,rail.width-dragger.width,0);
			
			slider = new MovieClip();
			slider.addChild(rail);
			slider.addChild(dragger);
			addChild(content);
			addChild(slider);
			content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
			if(_numPerPage >= _contentWidth)
			{
				if(autoHide)
					slider.visible = false;
			}else{
				
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
			_value = (dragger.x-rail.x)/(rail.width-dragger.width)*(_maximum-_minimum) ;
			tempValue = content.scrollRect.x;
			if(easing){
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else{
				content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
			}
			
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			tempValue = tempValue+(_value-tempValue)*.15;
			content.scrollRect = new Rectangle(tempValue,0,_numPerPage,content.height);
			if(Math.abs(tempValue - _value)<=1){
				content.scrollRect = new Rectangle(_value,0,_numPerPage,content.height);
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				
			}
		}
	}
}