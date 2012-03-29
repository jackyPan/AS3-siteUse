package com.horidream.display
{
	import com.greensock.TweenProxy;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.text.StaticText;
	import flash.utils.Dictionary;

	public class Follower
	{
		
		private static var list:Dictionary = new Dictionary();
		private static var _pause:Boolean = false;
		public static var xyFollow:Function = xyFollower;
		public static var mouseFollow:Function = mouseFollwer;
		public static function get pause():Boolean
		{
			return _pause;
		}

		public static function set pause(value:Boolean):void
		{
			_pause = value;
			if(_pause){
				Hori.enterFrame.add(onEnterFrame);
			}else{
				Hori.enterFrame.remove(onEnterFrame);
			}
		}
		public static function followMouse(target:DisplayObject,coordinateSpace:DisplayObject = null,centerPosition:Boolean = false,is3D:Boolean = false):void
		{
			var followFunc:Function = is3D?mouseFollwer3D:mouseFollow
			if(centerPosition){
				var proxy:TweenProxy = new TweenProxy(target);
				proxy.registration = proxy.getCenter();
				
				add(coordinateSpace || target.parent,proxy,followFunc);
			}else{
				add(coordinateSpace || target.parent,target,followFunc);
			}
		}
		public static function add(target:Object,follower:Object,rule:Function):void
		{
			Hori.enterFrame.add(onEnterFrame);
			if(!list[target]){
				list[target] = new Dictionary();
			}
			list[target][follower] = rule ;
		}
		public static function removeFollower(follower:Object):void{
			for (var o:Object in list){
				for(var w:Object in list[o]){
					if(w == follower){
						list[o][w] = null;
						delete list[o][w];
							
					}
				}
			}	
		}
		public static function removeTarget(target:Object):void{
			for (var o:Object in list){
				
				if(o == target){
					list[o] = null;
					delete list[o];
					
				}
				
			}	
		}
		public static function removeAll():void{
			for (var o:Object in list){
				list[o] = null
				delete list[o];
			}	
			Hori.enterFrame.remove(onEnterFrame);
		}
		private static function onEnterFrame():void
		{
			if(pause){
				return;
			}
			for (var o:Object in list){
				for(var w:Object in list[o]){
					list[o][w].apply(null,[o,w]);
				}
			}			
		}
		private static function xyFollower(m:Object,s:Object):void{
			s.x += (m.x - s.x)*.1;
			s.y += (m.y - s.y)*.1;
			var p1:Point = new Point(s.x,s.y);
			var p2:Point = new Point(m.x,m.y);
			var dis:Number = Point.distance(p1,p2);
			if(dis<=1){
				s.x = m.x;
				s.y = m.y;
				removeFollower(s);
			}
		}
		private static function mouseFollwer(m:Object,s:Object):void
		{
			s.x += (m.mouseX - s.x)*.1;
			s.y += (m.mouseY - s.y)*.1;
			
		}
		private static function mouseFollwer3D(m:Object,s:Object):void
		{
			s.x += (m.mouseX - s.x)*.1;
			s.y += (m.mouseY - s.y)*.1;
			s.z += (0 - s.z)*.1;
		}
		
	}
}