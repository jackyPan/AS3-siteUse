package com.horidream.core
{
	import com.horidream.interfaces.ICommand;
	
	public class Command implements ICommand
	{
		protected var target:*;
		public function Command(target:* = null, autoExecute:Boolean = false)
		{
			this.target = target;
			if(autoExecute){
				execute();
			}
		}
		public function execute():void
		{
		}
	}
}