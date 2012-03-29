package com.horidream.core
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 25, 2011
	 */
	import com.horidream.interfaces.IDeluxShowView;
	import com.horidream.template.SpringSprite;
	
	import org.osflash.signals.Signal;
	
	public class ViewBase extends SpringSprite implements IDeluxShowView
	{
		public static const IDLE:int = 0;
		public static const SHOWING_IN:int = 1;
		public static const SHOWING_OUT:int = 2;
		
		private var _currentStatus:int = IDLE;
		public var statusChangedSignal:Signal = new Signal(int);
		public function ViewBase()
		{
			super();
		}
		
		public function get currentStatus():int
		{
			return _currentStatus;
		}
		
		public function showIn():void
		{
			_currentStatus = SHOWING_IN;
			statusChangedSignal.dispatch(_currentStatus);
			
		}
		public function onShowInComplete():void
		{
			_currentStatus = IDLE;
			statusChangedSignal.dispatch(_currentStatus);
		}
		public function showOut():void
		{
			_currentStatus = SHOWING_OUT;
			statusChangedSignal.dispatch(_currentStatus);
		}
		public function onShowOutComplete():void
		{
			_currentStatus = IDLE;
			statusChangedSignal.dispatch(_currentStatus);
		}
		public function reset():void
		{
			
		}
	}
}