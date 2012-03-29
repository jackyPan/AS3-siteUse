package com.horidream.controller
{
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Dec 30, 2010
	 */
	public class DragManager
	{
		private var currentTarget:Sprite;
		private var viewportRec:Rectangle;
		private var viewportCoordinateSpace:DisplayObject;
		private var easing:Number;
		
		
		private var isDraging:Boolean = false;
		private var startPoint:Point;
		private var startRect:Rectangle;
		private var targetRec:Rectangle;
		private var targetParent:DisplayObjectContainer;
		private var p:Point;

		private static var singleInstance:DragManager;
		public function DragManager(internalInstance:InternalClass){
			if(internalInstance == null){
				throw new Error("the parameter provided can't be null");
			}
		}

		public static function startDrag(target:Sprite,viewportRec:Rectangle,viewportCoordinateSpace:DisplayObject,easing:Number = .3):void{
			getInstance().addTarget(target,viewportRec,viewportCoordinateSpace,easing);
		}
		public static function get targetRec():Rectangle{
			return getInstance().targetRec;
		}
		public static function get targetScrollRec():Rectangle{
			return getInstance().currentTarget.scrollRect;
		}
		private static function getInstance():DragManager{
			singleInstance ||= new DragManager(new InternalClass());
			return singleInstance;
		}
		private function addTarget(target:Sprite,viewportRec:Rectangle,viewportCoordinateSpace:DisplayObject,easing:Number):void
		{
			if(currentTarget){
				if(currentTarget == target){
					return;
				}else{
					deactivate();
				}
			}
			isDraging = false;
			currentTarget = target;
			this.viewportRec = viewportRec;
			this.easing = easing;
			this.viewportCoordinateSpace = viewportCoordinateSpace;
			targetRec = currentTarget.getBounds(currentTarget);
			activate();
		}
		private function activate():void
		{
			if(stage){
				onAddedToStage();
			}else{
				currentTarget.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}


		private function deactivate():void
		{
			currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		private function onAddedToStage(e:Event = null):void
		{
			if(e){
				e.currentTarget.removeEventListener(e.type, arguments.callee);
			}
			currentTarget.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			
			var rec:Rectangle = RecUtil.localToGlobal(viewportRec,viewportCoordinateSpace);
			rec = RecUtil.globalToLocal(rec,currentTarget);
			
			rec.x = HoriMath.bound(rec.x,targetRec.x,targetRec.x+targetRec.width-rec.width);
			rec.y = HoriMath.bound(rec.y,targetRec.y,targetRec.y+targetRec.height-rec.height);
			currentTarget.scrollRect = rec;
			targetParent = currentTarget.parent;
			
			var position:Point = viewportCoordinateSpace.localToGlobal(viewportRec.topLeft);
			position = targetParent.globalToLocal(position);
			QuickSetter.set(currentTarget,{x:position.x,y:position.y});
		}



		private function onMouseDown(e:MouseEvent):void
		{
			isDraging = true;
			startPoint = new Point(targetParent.mouseX,targetParent.mouseY);
			startRect = currentTarget.scrollRect.clone();
			currentTarget.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{
			if(isDraging){
				p = new Point(targetParent.mouseX,targetParent.mouseY);
				p = startPoint.subtract(p);
				p.x = p.x/currentTarget.transform.matrix.a;
				p.y = p.y/currentTarget.transform.matrix.d;
			}
			var rec:Rectangle = startRect.clone();
			rec.offsetPoint(p);
			rec.x = HoriMath.bound(rec.x,targetRec.x,targetRec.x+targetRec.width-rec.width);
			rec.y = HoriMath.bound(rec.y,targetRec.y,targetRec.y+targetRec.height-rec.height);
			var currentRec:Rectangle = currentTarget.scrollRect;
			var finalRec:Rectangle = currentRec.clone();
			finalRec.x = currentRec.x+(rec.x - currentRec.x)*easing;
			finalRec.y = currentRec.y+(rec.y - currentRec.y)*easing;
			currentTarget.scrollRect = finalRec;
			if(!isDraging){
				if(Point.distance(currentTarget.scrollRect.topLeft,rec.topLeft)<=1){
					currentTarget.scrollRect = rec;
					currentTarget.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			isDraging = false;
		}
		private function get stage():Stage
		{
			if(currentTarget && currentTarget.stage){
				return currentTarget.stage;
			}else{
				return null;
			}
		}
	}
}
class InternalClass{
	public function InternalClass(){}
}