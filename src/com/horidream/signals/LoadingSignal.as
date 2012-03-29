package com.horidream.signals
{
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	zhaib
	 * @since 	Nov 19, 2010
	 */
	import com.horidream.vo.ProgressVO;
	
	import org.osflash.signals.Signal;
	
	public class LoadingSignal extends Signal
	{
		public function LoadingSignal(...parameters)
		{
			super(ProgressVO);
		}
	}
}