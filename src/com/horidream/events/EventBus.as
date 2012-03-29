package com.horidream.events
{
	import com.horidream.core.Command;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created May 19, 2010 
	 */
	public class EventBus extends EventDispatcher
	{
		
		private static var mapList:Array = [];
		protected static var pausedList:Dictionary = new Dictionary();
		protected static var oneShotList:Dictionary = new Dictionary();
		protected static const DEFAULT_GROUP_NAME:String = "Horidream";
		protected static var listNeedClone:Boolean;
		public static function map(target:IEventDispatcher,type:String,commandClassOrFunction:*,group:String = "Horidream",oneShot:Boolean = false,eventClass:Class= null):void {
			var mapListItem:Object = ({"target":target,"type":type,"commandClassOrFunction":commandClassOrFunction,"group":group,"eventClass":eventClass});
			if(getListIndex(target,type,commandClassOrFunction,group) != -1)
			{
				return;
			}
			if(commandClassOrFunction is Class || commandClassOrFunction is Function){
				target.addEventListener(type,commandListener);
				mapList[mapList.length] = mapListItem;
				if(oneShot){
					oneShotList[mapListItem] = true;
				}
			}else{
				throw new Error(
					"\n" +
					"commandClassOrFunction parameter should be a Class or a Function" +
					"\n" +
					"commandClassOrFunction 参数应提供 Command 类或方法");
			}
		}
		public static function unmap(target:IEventDispatcher= null,type:String = null,commandClassOrFunction:* = null,group:String = null): void{
			var index:int = getListIndex(target,type,commandClassOrFunction,group);
			if(index != -1){
				if(listNeedClone){
					mapList = mapList.slice();
					listNeedClone = false;
				}
				mapList.splice(index,1);
				delete oneShotList[mapList[index]];
				unmap(target,type,commandClassOrFunction,group);
			}
		}
		
		public static function unmapGroup(group:String):void{
			if(group == null){
				return;
			}
			unmap(null,null,null,group);
		}

		public static function pause(target:IEventDispatcher= null,type:String = null,commandClassOrFunction:* = null,group:String = null): void{
			var indexArr:Array = getListIndexArrayOf(target,type,commandClassOrFunction,group);
			for(var i:int = indexArr.length;i--;)
				pausedList[mapList[indexArr[i]]] = true;
		}
		public static function resume(target:IEventDispatcher= null,type:String = null,commandClassOrFunction:* = null,group:String = null): void{
			var indexArr:Array = getListIndexArrayOf(target,type,commandClassOrFunction,group);
			for(var i:int = indexArr.length;i--;)
				delete pausedList[mapList[indexArr[i]]];
		}
		public static function toString():String
		{
			var message:String = "";
			for (var i:int = 0; i < mapList.length; i++) {
				var element:Object = mapList[i] as Object;
				message += "[+]No."+ i
					+"  | target->"+element.target
					+"  | type->"+element.type 
					+"  | listener->"+ getQualifiedClassName(element.commandClassOrFunction)
					+"  | group->"+element.group
				if(pausedList[mapList[i]])
				{
					message += "  | pausing"
				}
				message += "\n";
				
			}
			return message;
		}

				
		private static function commandListener(e:Event):void {
			var indexArr:Array = getListIndexArray(e);
			var command:Command;
			listNeedClone = true;
			for (var i:int = 0; i < indexArr.length; i++) {
				var index:int = indexArr[i] as int;
				
				if(index == -1 || pausedList[mapList[index]] || (mapList[index].eventClass!= null && e['constructor'] != mapList[index].eventClass)){
					continue;
				}
				
				if(mapList[index].commandClassOrFunction is Class){
					command = new mapList[index].commandClassOrFunction(e,true);
				}else if(mapList[index].commandClassOrFunction is Function){
					mapList[index].commandClassOrFunction(e);
				}else{
					throw new Error(
						"\n" +
						"commandClassOrFunction parameter should be a Class or a Function" +
						"\n" +
						"commandClassOrFunction 参数应提供 Command 类或方法");
				}
				
			}
			/*删除所有只执行一次的映射*/
			for (i = indexArr.length; i--;) {
				index = indexArr[i] as int;
				if(oneShotList[mapList[index]]){
					mapList.splice(index,1);
					delete oneShotList[mapList[index]];
				}
			}
		}



		private static function getListIndex(target:IEventDispatcher,type:String,commandClassOrFunction:*,group:String):int {
			var index:int = -1;
			for (var i:int = 0; i < mapList.length; i++) {
				var element:Object = mapList[i] as Object;
				if(element && (element.target == target || target == null)
					&& (element.type == type || type==null) 
					&& (element.commandClassOrFunction == commandClassOrFunction || commandClassOrFunction == null) 
					&& (element.group == group || group == null)){
					index = i;
					return index;
				}
			}
			return index;
		}
		private static function getListIndexArray(e:Event):Array {
			var indexArr:Array = [];
			for (var i:int = 0; i < mapList.length; i++) {
				var element:Object = mapList[i] as Object;
				if(element && element.target == e.currentTarget && (element.type == null || element.type == e.type)){
					indexArr.push(i);
				}
			}
			return indexArr;
		}
		private static function getListIndexArrayOf(target:IEventDispatcher,type:String,commandClassOrFunction:*,group:String):Array{
			var indexArr:Array = [];
			for (var i:int = 0; i < mapList.length; i++) {
				var element:Object = mapList[i] as Object;
				if(element && (element.target == target || target == null)
					&& (element.type == type || type==null) 
					&& (element.commandClassOrFunction == commandClassOrFunction || commandClassOrFunction == null) 
					&& (element.group == group || group == null))
				{
					indexArr.push(i);
				}
			}
			return indexArr;
		}
	}
}