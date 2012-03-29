package com.horidream.core
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 31, 2011
	 */
	import com.horidream.interfaces.IUpdate;
	
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;
	
	public class ListItem extends MovieClip implements IUpdate
	{
		protected var _currentValue:Object;
		public var selected:Signal = new Signal(ListItem,Object);
		public function get currentValue():Object
		{
			return _currentValue;
		}


		public function ListItem()
		{
			
		}
		
		public function update(value:Object):void
		{
			if(_currentValue == value)
			{
				return;
			}
			_currentValue = value;
		}
	}
}