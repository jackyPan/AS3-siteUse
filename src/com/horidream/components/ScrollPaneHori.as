package com.horidream.components
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jul 11, 2011
	 */
	
	import com.greensock.TweenMax;
	import com.horidream.display.RollClip;
	import com.horidream.display.RollClipVertical;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	import mx.effects.Blur;
	
	public class ScrollPaneHori
	{
		private var slider:SliderHori;
		private var rec:Rectangle;
		private var easing:Boolean;
		private var freezeDraggerHeiht:Boolean;
		private var autoHide:Boolean;
		private var startValue:Number;
		private var contents:*;
		private var rail:Sprite;
		private var dragger:Sprite;
		private var scrollType:int;
		public static const HORIZONTAL:int = 1;
		public static const VERTICAL:int = 0;
		private var contentContainer:Sprite;
		
		public function ScrollPaneHori(
			dragger:Sprite,
			rail:Sprite,
			contentContainer:Sprite,
			rec:Rectangle = null,
			scrollType:int = 0,
			easing:Boolean = true,
			freezeDraggerHeiht:Boolean = false,
			autoHide:Boolean = false
		)
		{
			this.dragger = dragger;
			this.rail = rail;
			this.scrollType = scrollType;
			if(scrollType == VERTICAL){
				this.contents = new RollClipVertical(rec || contentContainer.getRect(contentContainer),contentContainer);
				this.slider = new SliderHori(dragger,rail,SliderHori.VERTICAL);
			}else{
				this.contents = new RollClip(rec || contentContainer.getRect(contentContainer),contentContainer);
				this.slider = new SliderHori(dragger,rail,SliderHori.HORIZONTAL);
			}
			this.contentContainer = contentContainer;
			this.easing = easing;
			this.freezeDraggerHeiht = freezeDraggerHeiht;
			this.autoHide = autoHide;
			
			
			
			slider.changed.add(onSliderChanged);
			if(scrollType == 0)
			{
				contentContainer.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			}
				
		}
		public function get content():*
		{
			return this.contents;
		}
		public function reset():void
		{
			slider.value = 0;
			if(scrollType == VERTICAL){
				contents.y = 0;
			}else{
				contents.x = 0;
			}
		}
		public function get value():Number{
			return slider.value;
		}
		public function set value(v:Number):void{
			slider.value = v;
		}
		private function onMouseWheel(e:MouseEvent):void
		{
			slider.value -= e.delta;
		}
		
		private function onSliderChanged(value:Number):void
		{
			
			if(scrollType == VERTICAL){
				if((contents.visibleHeight-contents.height)>0)
				{
					return;
				}else{
					if(easing){
						Hori.enterFrame.add(loop);
					}else{
						contents.y = value*(contents.visibleHeight-contents.height)/100;
					}
				}
			}else{
				if((contents.visibleWidth-contents.width)>0)
				{
					return;
				}else{
					if(easing){
						Hori.enterFrame.add(loop);
					}else{
						contents.x = value*(contents.visibleWidth-contents.width)/100;
					}
				}
			}
			
		}		
		private function loop():void
		{
			if(scrollType == VERTICAL){
				if(Math.abs(slider.value*(contents.visibleHeight-contents.height)/100-contents.y)<1){
					
					contents.y = slider.value*(contents.visibleHeight-contents.height)/100;
					Hori.enterFrame.remove(loop);
				}else{
					contents.y += (slider.value*(contents.visibleHeight-contents.height)/100-contents.y)*.1;
					
				}
			}else{
				if(Math.abs(slider.value*(contents.visibleWidth-contents.width)/100-contents.x)<1){
					contents.x = slider.value*(contents.visibleWidth-contents.width)/100;
					Hori.enterFrame.remove(loop);
				}else{
					contents.x += (slider.value*(contents.visibleWidth-contents.width)/100-contents.x)*.1;
				}
			}	
		}
		
		public function addContent(target:DisplayObject):void
		{
			contents.addClip(target);
			adjustDragger();
			adjustAutoHide();
		}
		public function addContentAt(target:DisplayObject,n:int):void
		{
			contents.addClipAt(target,n);
			adjustDragger();
			adjustAutoHide();
		}

		private function adjustAutoHide():void
		{
			if(scrollType == VERTICAL){
				if(autoHide && (contents.visibleHeight-contents.height)>0)
				{
					slider.visible = false;
				}else{
					slider.visible = true;
				}
			}else{
				if(autoHide && (contents.visibleWidth-contents.width)>0)
				{
					slider.visible = false;
				}else{
					slider.visible = true;
				}
		
			}
		}


		public function indexOf(target:DisplayObject):int
		{
			return contents.indexOf(target);
		}
		public function getContenAt(index:int):DisplayObject
		{
			return contents.getClipAt(index);
		}

		public function addGap(gapValue:Number):Shape {
			var shape:Shape = contents.addEmptyClip(gapValue);
			adjustDragger();
			return shape;
		}
		public function removeContent(target:DisplayObject):void
		{
			contents.removeClip(target);
			adjustDragger();
		}
		public function removeContentAt(n:int):void
		{
			contents.removeClipAt(n);
			adjustDragger();
		}
		public function removeAll():void
		{
			contents.removeAll();
			adjustDragger();
		}
			
		private function adjustDragger():void
		{
			if(!freezeDraggerHeiht)
			{
				if(scrollType == VERTICAL){
					dragger.height = rail.height*contents.visibleHeight/contents.height;
				}else{
					dragger.width = rail.width*contents.visibleWidth/contents.width;
				}
			}
			
			if(slider.parent)
				slider.parent.setChildIndex(slider,slider.parent.numChildren-1);
		}
	}
}