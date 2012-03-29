package com.horidream.components
{
	import com.horidream.core.ListItem;
	import com.horidream.display.RollClipVertical;
	import com.horidream.interfaces.IUpdate;
	import com.horidream.util.HoriDebug;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 31, 2011
	 */
	public class ListHori
	{
		private var rollClip:RollClipVertical;
		private var slider:SliderHori;
		private var listItemClass:Class;
		private var itemNumber:int;
		private var totalItemNumber:int;
		private var _dataValue:Object = null;
		private var itemHeight:Number;
		private var targetY:Number;
		
		public var selected:Signal = new Signal(int,Object);
		private var itemArr:Array;
		private var amplifier:Number;
		
		
		public static function createList(
			dragger:Sprite,
			rail:Sprite,
			contentContainer:Sprite,
			listItemClass:Class,
			mouseWheelSensor:InteractiveObject = null
			):ListHori
		{
			var rc:RollClipVertical = new RollClipVertical(contentContainer.getRect(contentContainer),contentContainer);
			var slider:SliderHori = new SliderHori(dragger,rail,SliderHori.VERTICAL);
			
			return new ListHori(rc,slider,listItemClass,mouseWheelSensor);
		}
		
		public function ListHori(rollClip:RollClipVertical,slider:SliderHori,listItemClass:Class,mouseWheelSensor:InteractiveObject)
		{
			if(!(new listItemClass is ListItem))
			{
				throw new Error("The listItemClass parameter should be a sub class of ListItem");
			}
			this.rollClip = rollClip;
			this.slider = slider;
			this.listItemClass = listItemClass;
			if(mouseWheelSensor){
				mouseWheelSensor.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				mouseWheelSensor.addEventListener(MouseEvent.CLICK,onWheelSensorClicked);
			}
			
			slider.visible = false;
			setup();
		}

		private function onWheelSensorClicked(e:MouseEvent):void
		{
			trace("mouse snesor clicked"+e);
		}

		private function onMouseWheel(e:MouseEvent):void
		{
			slider.value -= e.delta;
		}

		
		public function set data(dataValue:Object):void
		{
			if(dataValue is Array){
				this.totalItemNumber = dataValue.length;
			}else if(dataValue is XMLList)
			{
				this.totalItemNumber = dataValue.length();
			}else{
				return;
			}
			slider.value = 0;
			slider.visible = true;
			this._dataValue = dataValue;
			amplifier = totalItemNumber/itemNumber;
			slider.maximum = rollClip.height*amplifier - rollClip.visibleHeight;
			updateItem();
		}
		public function refresh():void
		{
			updateItem();
		}
		private function setup():void
		{
			rollClip.removeAll();
			
			
			var item:ListItem = new listItemClass();
			itemArr = [];
			itemHeight = item.height;
			itemNumber = Math.ceil(rollClip.visibleHeight/item.height)+2;
			for(var i:int = 0;i<itemNumber;i++)
			{
				item = new listItemClass();
//				var itemBtn:SingleFrameButton = new SingleFrameButton(item);
//				rollClip.addClip(itemBtn);
				rollClip.addClip(item);
				itemArr.push(item);
				item.selected.add(onItemSelected);
//				itemBtn.addEventListener(MouseEvent.CLICK,onItemBtnClicked);
			}
			slider.changed.add(onSliderChanged);
		}
		
		protected function onItemSelected(target:ListItem,value:Object):void
		{
			var i:int = itemArr.indexOf(target);
			var round:int = int((rollClip.height-rollClip.y-(i+1)*itemHeight)/rollClip.height);
			var index:int = i+round*itemNumber;
			selected.dispatch(index,value);
		}
		protected function onSliderChanged(num:Number):void
		{
			if(amplifier<1)
			{
				return;
			}
			targetY = -slider.value;
			Hori.enterFrame.add(loop);
			
		}
		
		private function loop():void
		{
			
			rollClip.y += (targetY-rollClip.y)*.1;
			if(Math.abs(rollClip.y-targetY)<1)
			{
				rollClip.y = targetY;
				Hori.enterFrame.remove(loop);
			}
			
			updateItem();
			
		}		
		
		private function updateItem():void
		{
			for (var i:int = 0; i<itemNumber; i++)
			{
				var round:int = int((rollClip.height-rollClip.y-(i+1)*itemHeight)/rollClip.height);
				var index:int = i+round*itemNumber;
				if(_dataValue && _dataValue[index]){
					IUpdate(rollClip.getClipAt(i)).update(_dataValue[index]);
				}else{
					IUpdate(rollClip.getClipAt(i)).update(null);
				}
			}
			
			
		}
		
	}
}