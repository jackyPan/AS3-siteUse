package
{
	import com.horidream.components.DebugPanel;
	import com.horidream.graphics.DrawingTool;
	import com.horidream.util.HoriDebug;
	import com.horidream.util.QuickSetter;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 29, 2010 10:11:06 AM
	 */
	public class Hori
	{
		
		public static const AUTHOR				:String = "Horidream (Baoli Zhai)";
		public static const SITE				:String = "http://www.horidream.com";
		public static const EMAIL				:String = "horidream@gmail.com";
		public static const PROJECT_NAME		:String = "HoriLibs";
		public static const VERSION				:String = "1.00.00";
		
		
		public static var debug:Boolean;
		public static var stage:Stage;
		public static var params:Object = new Object();
		private static var _enterFrame:Signal;
		public static var resize:Signal = new Signal();
		public static var keyDown:Signal = new Signal(int);
		public static var keyUp:Signal = new Signal(int);
		
		private static var debugSelected:Boolean;
		private static var _debugPanel:DebugPanel;
		private static var _initialized:Boolean = false;
		private static var menuItem:ContextMenuItem;
		private static const dispatcher:Shape = new Shape()


		public static function get enterFrame():Signal
		{
			if(!_enterFrame){
				_enterFrame = new Signal();
				dispatcher.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
			return _enterFrame;
		}

		public static function set enterFrame(value:Signal):void
		{
			_enterFrame = value;
		}

		public static function get debugPanel():DebugPanel
		{
			return _debugPanel;
		}

		public static function initialize(stage:Stage,backgroundColor:* = null,debug:Boolean = false,version:String = ""):void{
			if(_initialized){
				return;
			}
			_initialized = true;
			Hori.debug = debug;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Hori.stage = stage;
			
			stage.addEventListener(Event.RESIZE,function(e:Event):void{resize.dispatch()});
			
			var shape:Sprite = new Sprite();
			stage.addChildAt(shape,0);
			var menu:ContextMenu = new ContextMenu();
			
			
			if(backgroundColor !=null)
			{
				DrawingTool.drawRect(shape,new Rectangle(0,0,stage.stageWidth,stage.stageHeight),1,0,0,backgroundColor,1,0);
				resize.add(function():void{DrawingTool.drawRect(shape,new Rectangle(0,0,stage.stageWidth,stage.stageHeight),1,0,0,backgroundColor,1,0);});
			}
			if(debug){
				debugSelected = false;
				_debugPanel = new DebugPanel(stage.stageWidth,stage.stageHeight);
				menuItem = new ContextMenuItem("Show Debug Panel");
				menu.customItems.push(menuItem);
//				(stage.getChildAt(0) as Sprite).contextMenu = menu;
				
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuItemSelect);
				addKeyboardSignal();
				keyUp.add(onKeyUpSignal);
				resize.add(function():void{_debugPanel.setSize(stage.stageWidth,stage.stageHeight)});
			}
			if(version != "")
			{
				menuItem = new ContextMenuItem(version);
				menu.customItems.push(menuItem);
			}
			shape.contextMenu = menu;
			
		}
		public static function addKeyboardSignal(isKeyDown:Boolean = true,isKeyUp:Boolean = true):void
		{
			if(isKeyDown && Hori.stage){
				Hori.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			}
			if(isKeyUp && Hori.stage){
				Hori.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			}
		}

		private static function onKeyUp(e:KeyboardEvent):void
		{
			keyUp.dispatch(e.keyCode);
		}

		private static function onKeyDown(e:KeyboardEvent):void
		{
			keyDown.dispatch(e.keyCode);			
		}

		private static function onEnterFrame(e:Event):void
		{
			if(enterFrame.numListeners<1){
				dispatcher.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				enterFrame = null;
			}else{
				enterFrame.dispatch();
			}
		}

		private static function onKeyUpSignal(n:int):void
		{
			switch(n){
				case 48:
					menuItem.dispatchEvent(new ContextMenuEvent(ContextMenuEvent.MENU_ITEM_SELECT));
					break;
				case 57:
					HoriDebug.paused = !HoriDebug.paused;
					break;
				
			}
		}

		private static function onMenuItemSelect(event:ContextMenuEvent):void
		{
			debugSelected = !debugSelected;
			if(debugSelected){
				(event.currentTarget as ContextMenuItem).caption = "Hide Debug Panel";
				stage.addChild(debugPanel);
				debugPanel.reset();
			}else{
				(event.currentTarget as ContextMenuItem).caption = "Show Debug Panel";
				QuickSetter.removeSelf(debugPanel);
			}
		}
	}
}