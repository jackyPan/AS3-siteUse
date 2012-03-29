package com.horidream.core
{
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Mar 30, 2011
	 */
	public class AbstractList
	{
		
		public var list:Array = [];
		protected var typeClass:Class;
		public var updateSignal:Signal = new Signal();
		public function AbstractList(typeClass:Class)
		{
			if(this['constructor'] == AbstractList){
				throw new Error("This abstract Class can't be constructed.")
			}
			this.typeClass = typeClass;
		}
		
		
		
		public function add(item:Object):void
		{
			if(item is typeClass)
			{
				if(!contain(item))
				{
					list.push(item);
					updateSignal.dispatch();
				}
			}else{
				throw new Error("The added item is not correct type");
			}
		}
		public function getItemAt(index:int):Object
		{
			if(index>=0 && index<list.length)
			{
				return list[index];
			}
			return null
		}
		public function remove(item:Object):void
		{
			var index:int = list.indexOf(item);
			if(index != -1)
			{
				list.splice(index,1);
				updateSignal.dispatch();
			}
		}
		public function removeAt(index:int):void
		{
			if(index>=0 && index<list.length)
			{
				list.splice(index,1);
				updateSignal.dispatch();
			}
		}
		public function removeAll():void
		{
			list = [];
			updateSignal.dispatch();
		}
		public function get length():int
		{
			return list.length;
		}
		
		public function contain(item:Object):Boolean
		{
			return list.indexOf(item)!=-1;
		}
		public function indexOf(item:Object):int
		{
			return list.indexOf(item);
		}
		
		public function toString():String
		{
			return "list:[" + list + "]";
		}


	}
}