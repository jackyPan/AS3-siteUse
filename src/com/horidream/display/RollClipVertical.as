package com.horidream.display
{
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 22, 2011
	 */
	public class RollClipVertical
	{
		private var clips:Array = [];
		private var _y:Number = 0;
		private var _height:Number = 0;
		private var viewRec:Rectangle;
		public var viewport:DisplayObjectContainer;
		private var autoFillEmptyClip:Shape;
		public function RollClipVertical(viewRec:Rectangle,viewport:DisplayObjectContainer = null)
		{
			this.viewport = (viewport || new Sprite());
			this.viewRec = viewRec;
			this.viewport.scrollRect = viewRec;
		}
		
		public function get visibleHeight():Number
		{
			return viewRec.height;
		}
		public function get height():Number
		{
			if(autoFillEmptyClip && (clips.indexOf(autoFillEmptyClip)>-1))
			{
				return _height - autoFillEmptyClip.height;
			}else{
				return _height;
			}
		}

		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			update();
		}
		
		private function update():void
		{
			var yPos:Number = y;
			var len:int = clips.length;
			for(var i:int = 0;i<len;i++)
			{
				var clip:DisplayObject = clips[i];
				clip.y = HoriMath.getValidPeriodValue(yPos,viewRec.y+0-clip.height,viewRec.y + _height-clip.height);
				if(clip.y>(viewRec.y+viewRec.height)){
					clip.visible = false;
				}else{
					clip.visible = true;
				}
				yPos +=clip.height;
				
			}
		}
		
		public function addClip(clip:DisplayObject,forceHeight:Number = 0):void
		{
			var clipHeight:Number = clip.height;
			removeAutoFillGap();
			clips.push(clip);
			viewport.addChild(clip);
			addAutoFillGap();
			initPosition();
			
			if(forceHeight>clipHeight)
			{
				addEmptyClip(forceHeight-clipHeight);
			}
		}
		public function addEmptyClip(clipHeight:Number):Shape
		{
			var emptyClip:Shape = new Shape();
			emptyClip.graphics.beginFill(0,1);
			emptyClip.graphics.drawRect(0,0,0,clipHeight);
			emptyClip.graphics.endFill();
			emptyClip.visible = false;
			clips.push(emptyClip);
			viewport.addChild(emptyClip);
			initPosition();
			
			return emptyClip;
		}
		public function addAutoFillGap():void{
			var minHeight:Number;
			var maxHeight:Number = 0;
			for (var i:int = 0; i < clips.length; i++)
			{
				var element:DisplayObject = clips[i] as DisplayObject;
				maxHeight = Math.max(maxHeight,element.height);
			}
			if(clips.length>1){
				if(height<viewRec.height){
					minHeight = viewRec.height;
				}else{
					minHeight= viewRec.height+maxHeight;
				}
			}else{
				minHeight = viewRec.height;
			}
			if(height< minHeight){
				autoFillEmptyClip = addEmptyClip(minHeight-height);
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
			var ypos:Number = 0;
			for(var i:int = 0;i<len;i++){
				var clip:DisplayObject = clips[i];
				clip.y = ypos;
				ypos += clip.height;
			}
			
			_height = ypos;
			
			update();
		}
	}
}