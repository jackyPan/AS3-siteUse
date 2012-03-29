package com.horidream.display
{
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Feb 25, 2011
	 */
	public class RollClip
	{
		private var clips:Array = [];
		private var _x:Number = 0;
		private var _width:Number = 0;
		private var viewRec:Rectangle;
		public var viewport:DisplayObjectContainer;
		private var autoFillEmptyClip:Shape;
		public var y:Number = 0;
		
		public function RollClip(viewRec:Rectangle,viewport:DisplayObjectContainer = null)
		{
			this.viewport = (viewport || new Sprite());
			this.viewRec = viewRec;
			this.viewport.scrollRect = viewRec;
		}

		public function get visibleWidth():Number
		{
			return viewRec.width;
		}

		public function get width():Number
		{
			if(autoFillEmptyClip && (clips.indexOf(autoFillEmptyClip)>-1))
			{
				return _width - autoFillEmptyClip.width;
			}else{
				return _width;
			}
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			update();
		}

		private function update():void
		{
			var xPos:Number = x;
			var len:int = clips.length;
			for(var i:int = 0;i<len;i++)
			{
				var clip:DisplayObject = clips[i];
				clip.x = HoriMath.getValidPeriodValue(xPos,viewRec.x+0-clip.width,viewRec.x + _width-clip.width);
				if(clip.x>viewRec.x+viewRec.width){
					clip.visible = false;
				}else{
					clip.visible = true;
				}
				xPos +=clip.width;
			}
		}

		public function addClip(clip:DisplayObject,forceWidth:Number = 0):void
		{
			var clipWidth:Number = clip.width;
			removeAutoFillGap();
			clips.push(clip);
			viewport.addChild(clip);
			addAutoFillGap();
			initPosition();
			
			if(forceWidth>clipWidth)
			{
				addEmptyClip(forceWidth-clipWidth);
			}
		}
		public function addEmptyClip(clipWidth:Number):Shape
		{
			var emptyClip:Shape = new Shape();
			emptyClip.graphics.beginFill(0,1);
			emptyClip.graphics.drawRect(0,0,clipWidth,0);
			emptyClip.graphics.endFill();
			emptyClip.visible = false;
			clips.push(emptyClip);
			viewport.addChild(emptyClip);
			initPosition();
			
			return emptyClip;
		}
		public function addAutoFillGap():void{
			var minWidth:Number;
			var maxWidth:Number = 0;
			for (var i:int = 0; i < clips.length; i++)
			{
				var element:DisplayObject = clips[i] as DisplayObject;
				maxWidth = Math.max(maxWidth,element.width);
			}
			if(clips.length>1){
				if(width<viewRec.width){
					minWidth = viewRec.width;
				}else{
					minWidth= viewRec.width+maxWidth;
				}
			}else{
				minWidth = viewRec.width;
			}
			if(width< minWidth){
				autoFillEmptyClip = addEmptyClip(minWidth-width);
			}
		}
		public function addMultiClips(...multiClips):void{
			var len:int = multiClips.length;
			for(var i:int = 0;i<len;i++){
				addClip(multiClips[i]);
			}
		}

		public function addClipAt(clip:DisplayObject,index:int):void
		{
			removeAutoFillGap();
			clips.splice(index,0,clip);
			viewport.addChildAt(clip,index);
			addAutoFillGap();
			initPosition();
		}
		public function getClipAt(index:int):DisplayObject
		{
			if(clips[index])
			{
				return clips[index];
			}
			return null;
		}
		public function removeClip(clip:DisplayObject):void
		{
			var index:int = clips.indexOf(clip);
			if(index>-1)
			{
				removeClipAt(index);
			}
		}
		public function removeClipAt(index:int):void{
			QuickSetter.removeSelf(clips[index]);
			clips.splice(index,1);
			
			initPosition();
		}
		public function removeAll():void{
			while(clips.length>0)
			{
				removeClipAt(0);
			}
			QuickSetter.removeChildren(viewport);
		}
		public function removeAutoFillGap():void{
			if(autoFillEmptyClip){
				var index:int = clips.indexOf(autoFillEmptyClip);
				if(index != -1){
					removeClipAt(index);
					autoFillEmptyClip = null;
				}
			}
		}
		public function indexOf(target:DisplayObject):int
		{
			return clips.indexOf(target);
		}
		private function initPosition():void
		{
			var len:int = clips.length;
			var xpos:Number = 0;
			for(var i:int = 0;i<len;i++){
				var clip:DisplayObject = clips[i];
				clip.x = xpos;
				xpos += clip.width;
			}
			_width = xpos;
			update();
		}
	}
}