/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package com.horidream.util
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import spark.primitives.Rect;
	
	public class QuickSetter
	{
		/**
		 * static function to set a series of parameters
		 * 
		 *  
		 * @param o The object to be set
		 * @param props A object holds all parameters to be set
		 */
		public static function set(o:*, props:Object):* {
			var msg:String = "";
			for (var n:String in props) {
				if(o.hasOwnProperty(n) || isDynamic(o)){
					try{
						o[n] = props[n];
					}catch(e:Error){
						if(o[n] && o[n] is Function){
							if(o[n].length == 0)
							{
								o[n]();
							}else{
								if(!(props[n] is Array))
								{
									props[n] = [props[n]];
								}
								
								o[n].apply(null,props[n]);
							}
						}
					}
				}
			}
			return o;
		}
//		public static function set(o:*, props:Object):* {
//			var msg:String = "";
//			for (var n:String in props) {
//				if(o.hasOwnProperty(n) || isDynamic(o)){
//					try{
//						o[n] = props[n];
//					}catch(e:Error){
//						if(o[n]!=null){
//							try{
//								o[n](props[n]);
//							}catch(e:Error){
//								o[n].apply(null,props[n]);
//							}
//						}else{
//							try{
//								o[n]();
//							}catch(e:Error){}
//						}
//					}
//				}else{
//					msg += (n+" ");
//				}
//			}
//			if(msg != ""){
//			}
//			return o;
//		}
		/**
		 * 克隆一个对象的属性 
		 * @param target		操作对象
		 * @param base			被克隆对象
		 * @param properties	克隆的属性名称，以“,”分隔开，支持.语法，如transform.matrix
		 * 
		 */
		public static function cloneProperty(target:Object,base:Object,properties:String = "x,y"):void
		{
			var arr:Array = properties.split(",");
			var len:int = arr.length;
			if(len<1){
				return;
			}
			for each(var tag:String in arr)
			{
				if(tag.indexOf(".")>-1){
					var tagArr:Array = tag.split(".");
					var propertyName:String = tagArr.shift();
					if(base.hasOwnProperty(propertyName) && target.hasOwnProperty(propertyName)){
						cloneProperty(target[propertyName],base[propertyName],tagArr.toString());
					}else{
						//trace("[Attention]: can't find the property: '"+propertyName+"'");
					}
				}else{
					if(base.hasOwnProperty(tag) && target.hasOwnProperty(tag)){
						target[tag] = base[tag];
					}else{
						//trace("[Attention]: can't find the property: '"+tag+"'");
					}
				}
			}
		}
		public static function isDynamic(object:*):Boolean
		{
			try {
				object.newHoriProperty = 0;
			} catch (e:Error) {
				return false
			}
			delete object.newHoriProperty;
			return true
		}
		public static function removeSelf(target:DisplayObject):void{
			if(target && target.parent){
				target.parent.removeChild(target);
			}
		}
		public static function removeChildren(container:DisplayObjectContainer):void{
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
		}
		/**
		 * 交换两个显示对象的容器，深度保持不变
		 * @param target1	进行交换的对象1
		 * @param target2	进行交换的对象2
		 * 
		 */
		public static function swapDisplayObject(target1:DisplayObject,target2:DisplayObject):void{
			var index1:int = -1;
			var index2:int = -1;
			var mother1:DisplayObjectContainer;
			var mother2:DisplayObjectContainer;
			if(target1.parent){
				mother1 = target1.parent as DisplayObjectContainer;
				index1 = mother1.getChildIndex(target1);
			}
			if(target2.parent){
				mother2 = target2.parent as DisplayObjectContainer;
				index2 = mother2.getChildIndex(target2);
			}
			if(mother1 && mother2 && (mother1 == mother2)){
				mother1.swapChildren(target2,target1);
				return;
			}
			if(index1>=0){
				mother1.removeChild(target1);
				mother1.addChildAt(target2,index1);
			}
			if(index2>=0){
				if(index1<0)
					mother2.removeChild(target2);
				mother2.addChildAt(target1,index2);
			}
			
		}
		
		/**
		 * 复制一个显示对象，复制该对象时，该对象的子对象也会被一并复制。
		 * （其中Shape的复制方式采用BitmapData.draw方法，因为使用代码在代码上绘图虽然可以使用copyFrom方法，
		 * 但如果是在Flash IDE环境下使用工具画出的Shape则无法通过copyFrom复制，
		 * 在FlashPlayer10以上的运行环境下且又不是Shape的情况时则使用copyFrom方法复制其graphics对象。
		 * 因此要完全复制显示对象，应尽量避免使用Shape）
		 * @param target			复制对象
		 * @param autoAdd			是否自动添加至显示列表
		 * @param autoAddParent		如提供此参数则添加为autoAddParent的子显示对象，否则添加为target父对象的子对象，如条件都不满足则不自动添加
		 * @return 					复制后的显示对象
		 * 
		 */
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false,autoAddParent:DisplayObjectContainer = null):DisplayObject {
			// create duplicate
			var duplicate:DisplayObject;
			try{
				var targetClass:Class = Object(target).constructor;
				duplicate = new targetClass();
			}catch(e:Error){
				duplicate = new MovieClip();
			}
			if(duplicate is Bitmap){
				Bitmap(duplicate).bitmapData = Bitmap(target).bitmapData;
			}
			if(target is Shape ||(target.hasOwnProperty('graphics') && (VersionDetails.major<10))){
				duplicate = new Sprite();
				var rec:Rectangle = RecUtil.getVisibleBounds(target);
				var bmd:BitmapData = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
				var matrix:Matrix = new Matrix(1,0,0,1,-rec.x,-rec.y); 
				bmd.draw(target,matrix);
				var shapeBm:Bitmap = new Bitmap(bmd);
				matrix.invert();
				shapeBm.transform.matrix = matrix;
				Sprite(duplicate).addChild(shapeBm);		
				
			}else if(target.hasOwnProperty("graphics")){
				duplicate['graphics']['copyFrom'](target['graphics']);
			}
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
				// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			
			
			
			
			
			
			/*dupulicate the child DisplayObject*/
			
			var doc:DisplayObjectContainer = target as DisplayObjectContainer;
			if(doc){
				for(var i:int = 0;i<doc.numChildren;i++){
					duplicateDisplayObject(doc.getChildAt(i),true,duplicate as DisplayObjectContainer);
				}
			}
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd) {
				if(autoAddParent){
					autoAddParent.addChild(duplicate);
				}else{
					if(target.parent)
						target.parent.addChild(duplicate);
				}
			}
			duplicate.name = target.name;
			return duplicate;
		}
		/**
		 * 删除显示容器中除某一子元素外的其他元素 
		 * @param container	执行操作的显示容器 
		 * @param child		不会被移除的显示对象
		 * 
		 */
		public static function removeChildrenExcept(container:DisplayObjectContainer,child:DisplayObject):void{
			while(container.numChildren>1){
				if(container.getChildAt(0) == child){
					
					container.removeChildAt(1);
				}else{
					container.removeChildAt(0);
					
				}
			}
			if(container.getChildAt(0) != child){
				container.removeChildAt(0);
			}
		}
	
//		public static function align(target:DisplayObject,baseObject:DisplayObject,pattern:int = 5,alignPoint:Point = null,forceBaseObjectRec:Rectangle = null,assignValue:Boolean = true):Point{
//			var tempParent:DisplayObjectContainer;
//			var index:int;
//			if(!target.parent || target == baseObject){
//				return null;
//			}else{
//				/*为防止target是baseObject的子元素影响计算，先将其移除，待计算baseObject后再添加回来*/
//				tempParent = target.parent;
//				index = tempParent.getChildIndex(target);
//				tempParent.removeChild(target);
//			}
//			var rec:Rectangle;
//			if(baseObject is Stage){
//				rec = forceBaseObjectRec || new Rectangle(0,0,(baseObject as Stage).stageWidth,(baseObject as Stage).stageHeight);
//			}else
//			{
//				rec = forceBaseObjectRec || baseObject.getRect(baseObject);
//			}
//			var targetPoint:Point;
//			switch(pattern){
//				case 1:
//					targetPoint = new Point(rec.x,rec.y);
//					break;
//				case 2:
//					targetPoint = new Point(rec.x+rec.width/2,rec.y);
//					break;
//				case 3:
//					targetPoint = new Point(rec.x+rec.width,rec.y);
//					break;
//				case 4:
//					targetPoint = new Point(rec.x,rec.y+rec.height/2);
//					break;
//				case 5:
//					targetPoint = new Point(rec.x+rec.width/2,rec.y +rec.height/2);
//					break;
//				case 6:
//					targetPoint = new Point(rec.x+rec.width,rec.y +rec.height/2);
//					break;
//				case 7:
//					targetPoint = new Point(rec.x,rec.y +rec.height);
//					break;
//				case 8:
//					targetPoint = new Point(rec.x+rec.width/2,rec.y +rec.height);
//					break;
//				case 9:
//					targetPoint = new Point(rec.x+rec.width,rec.y +rec.height);
//					break;
//				default:
//					throw new Error("提供的pattern不支持，请使用1~9整数");
//					return;
//			}
//			
//			var p:Point;
//			if(baseObject is Rectangle){
//				p = targetPoint;
//			}else{
//				p = baseObject.localToGlobal(targetPoint);
//				p = tempParent.globalToLocal(p);
//			}
//			
//			var rec2:Rectangle = alignPoint?new Rectangle(alignPoint.x,alignPoint.y) : target.getRect(target);
//			if(assignValue){
//				
//				target.x = p.x - (rec2.x + rec2.width/2)*target.transform.matrix.a;
//				target.y= p.y - (rec2.y + rec2.height/2)*target.transform.matrix.d;
//				//target.transform.matrix = matrix;
//			}
//			tempParent.addChildAt(target,index);
//			return new Point(p.x - (rec2.x + rec2.width/2)*target.transform.matrix.a,
//				p.y - (rec2.y + rec2.height/2)*target.transform.matrix.d);
//		}
		//Test another way to align
		/**
		 * 对齐显示对象的方法
		 * @param target 			待对齐的显示对象，该显示对象需被添加到显示列表
		 * @param baseObject 		对齐的基准对象（包括坐标系）
		 * @param pattern 			对方方式，按照小键盘1-9的方式对齐，5为居中，1为左上，2为左中，3为右上……
		 * @param targetOffset 		对齐点的偏移值t
		 * @param restrictBaseRect 	强制对齐到以baseObject为基准坐标系的该矩形区域
		 * @param assignValue		是否更新对齐后的坐标值。
		 * 
		 */
		public static function autoAlign(target:DisplayObject,baseObject:DisplayObject,pattern:int = 5,targetOffset:Point = null,restrictBaseRect:Rectangle = null,ease:Object = null):Point{
			var tempParent:DisplayObjectContainer;
			var index:int;
			var baseParent:DisplayObjectContainer;
			var baseIndex:int;
			var basePoint:Point;
			if((!target.parent) || (target == baseObject) ){
				return null;
			}
			
			/*为防止target是baseObject的子元素影响计算，先将其移除，待计算baseObject后再添加回来*/
			tempParent = target.parent;
			baseParent = baseObject.parent;
			var root:DisplayObject = baseObject;
			var targetRec:Rectangle = target.getRect(root);
			if(baseParent){
				basePoint = baseParent.localToGlobal(new Point(baseObject.x,baseObject.y));
			}
			index = tempParent.getChildIndex(target);
			tempParent.removeChild(target);
			if(baseObject is Stage){
				var stage:Stage = baseObject as Stage;
				restrictBaseRect = restrictBaseRect || new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			}
			var baseRec:Rectangle = restrictBaseRect || baseObject.getRect(root);
			tempParent.addChildAt(target,index);
			var tp1:Point = tempParent.globalToLocal(root.localToGlobal(targetRec.topLeft));
			var bp1:Point = tempParent.globalToLocal(root.localToGlobal(baseRec.topLeft));
			var tp9:Point = tempParent.globalToLocal(root.localToGlobal(targetRec.bottomRight));
			var bp9:Point = tempParent.globalToLocal(root.localToGlobal(baseRec.bottomRight));
			
			//计算其他参数
			var tp5:Point = new Point((tp1.x + tp9.x)/2,(tp1.y + tp9.y)/2);
			var bp5:Point = new Point((bp1.x + bp9.x)/2,(bp1.y + bp9.y)/2);
			
			var offset:Point = new Point();
			switch(pattern){
				case 1:
					offset = bp1.subtract(tp1);
					break;
				case 2:
					var tp2:Point = new Point(tp5.x,tp1.y);
					var bp2:Point = new Point(bp5.x,bp1.y);
					offset = bp2.subtract(tp2);
					break;
				case 3:
					var tp3:Point = new Point(tp9.x,tp1.y);
					var bp3:Point = new Point(bp9.x,bp1.y);
					offset = bp3.subtract(tp3);
					break;
				case 4:
					var tp4:Point = new Point(tp1.x,tp5.y);
					var bp4:Point = new Point(bp1.x,bp5.y);
					offset = bp4.subtract(tp4);
					break;
				case 5:
					offset = bp5.subtract(tp5);
					break;
				case 6:
					var tp6:Point = new Point(tp9.x,tp5.y);
					var bp6:Point = new Point(bp9.x,bp5.y);
					offset = bp6.subtract(tp6);
					break;
				case 7:
					var tp7:Point = new Point(tp1.x,tp9.y);
					var bp7:Point = new Point(bp1.x,bp9.y);
					offset = bp7.subtract(tp7);
					break;
				case 8:
					var tp8:Point = new Point(tp5.x,tp9.y);
					var bp8:Point = new Point(bp5.x,bp9.y);
					offset = bp8.subtract(tp8);
					break;
				case 9:
					offset = bp9.subtract(tp9);
					break;
				default:
					throw new Error("提供的pattern不支持，请使用1~9整数");
					return;
			}
			var finalPoint:Point = new Point(target.x + offset.x ,target.y + offset.y);
			if(targetOffset){
				finalPoint = finalPoint.add(targetOffset);
			}
			if(ease){
				var time:Number = ease.duration;
				delete ease.duration;
				ease.x = finalPoint.x;
				ease.y = finalPoint.y;
				TweenMax.to(target,time,ease);
			}else{
				
				target.x = finalPoint.x;
				target.y = finalPoint.y;
			}
			if(baseParent){
				basePoint = baseParent.globalToLocal(basePoint);
				baseObject.x = basePoint.x;
				baseObject.y = basePoint.y;
			}
			return finalPoint;
		}
		public static function align(target:DisplayObject,baseObject:DisplayObject,pattern:int = 5,targetOffset:Point = null,restrictBaseRect:Rectangle = null,ease:Object = null):Point{
			var tempParent:DisplayObjectContainer;
			var index:int;
			var baseParent:DisplayObjectContainer;
			var baseIndex:int;
			var basePoint:Point;
			if((!target.parent) || (target == baseObject) ){
				return null;
			}
			
			/*为防止target是baseObject的子元素影响计算，先将其移除，待计算baseObject后再添加回来*/
			tempParent = target.parent;
			baseParent = baseObject.parent;
			var root:DisplayObject = baseObject;
			//			if(baseParent){
			//				baseIndex = baseParent.getChildIndex(baseObject);
			//				baseParent.removeChild(baseObject);
			//			}
			var targetRec:Rectangle = RecUtil.localToGlobal(new Rectangle(),target);
			if(baseParent){
				//				baseParent.addChildAt(baseObject,baseIndex);
				basePoint = baseParent.localToGlobal(new Point(baseObject.x,baseObject.y));
			}
			index = tempParent.getChildIndex(target);
			tempParent.removeChild(target);
			if(baseObject is Stage){
				var stage:Stage = baseObject as Stage;
				restrictBaseRect = restrictBaseRect || new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			}
			var baseRec:Rectangle = restrictBaseRect || RecUtil.localToGlobal(baseObject.getRect(baseObject),baseObject);
			tempParent.addChildAt(target,index);
			var tp1:Point = tempParent.globalToLocal(root.localToGlobal(targetRec.topLeft));
			var bp1:Point = tempParent.globalToLocal(root.localToGlobal(baseRec.topLeft));
			var tp9:Point = tempParent.globalToLocal(root.localToGlobal(targetRec.bottomRight));
			var bp9:Point = tempParent.globalToLocal(root.localToGlobal(baseRec.bottomRight));
			
			//计算其他参数
			var tp5:Point = new Point((tp1.x + tp9.x)/2,(tp1.y + tp9.y)/2);
			var bp5:Point = new Point((bp1.x + bp9.x)/2,(bp1.y + bp9.y)/2);
			
			var offset:Point = new Point();
			switch(pattern){
				case 1:
					offset = bp1.subtract(tp1);
					break;
				case 2:
					var tp2:Point = new Point(tp5.x,tp1.y);
					var bp2:Point = new Point(bp5.x,bp1.y);
					offset = bp2.subtract(tp2);
					break;
				case 3:
					var tp3:Point = new Point(tp9.x,tp1.y);
					var bp3:Point = new Point(bp9.x,bp1.y);
					offset = bp3.subtract(tp3);
					break;
				case 4:
					var tp4:Point = new Point(tp1.x,tp5.y);
					var bp4:Point = new Point(bp1.x,bp5.y);
					offset = bp4.subtract(tp4);
					break;
				case 5:
					offset = bp5.subtract(tp5);
					break;
				case 6:
					var tp6:Point = new Point(tp9.x,tp5.y);
					var bp6:Point = new Point(bp9.x,bp5.y);
					offset = bp6.subtract(tp6);
					break;
				case 7:
					var tp7:Point = new Point(tp1.x,tp9.y);
					var bp7:Point = new Point(bp1.x,bp9.y);
					offset = bp7.subtract(tp7);
					break;
				case 8:
					var tp8:Point = new Point(tp5.x,tp9.y);
					var bp8:Point = new Point(bp5.x,bp9.y);
					offset = bp8.subtract(tp8);
					break;
				case 9:
					offset = bp9.subtract(tp9);
					break;
				default:
					throw new Error("提供的pattern不支持，请使用1~9整数");
					return;
			}
			var finalPoint:Point = new Point(target.x + offset.x ,target.y + offset.y);
			if(targetOffset){
				finalPoint = finalPoint.add(targetOffset);
			}
			if(ease){
				var time:Number = ease.duration;
				delete ease.duration;
				ease.x = finalPoint.x;
				ease.y = finalPoint.y;
				TweenMax.killTweensOf(target);
				TweenMax.to(target,time,ease);
			}else{
				
				target.x = finalPoint.x;
				target.y = finalPoint.y;
			}
			if(baseParent){
				basePoint = baseParent.globalToLocal(basePoint);
				baseObject.x = basePoint.x;
				baseObject.y = basePoint.y;
			}
			return finalPoint;
		}
		public static function instantiate(className:*,...args):*{
			var instance:*;
			var TempClass:Class;
			if(className is Class)
			{
				TempClass = className;
			}else if(className is String)
			{
				TempClass = getDefinitionByName(className) as Class;
				if(!TempClass){
					return null;
				}
			}else{
				return null;
			}
			if(args == null){
				return new TempClass();
			}
			switch(args.length){
				case 0:
					instance = new TempClass();
					break;
				case 1:
					instance = new TempClass(args[0]);
					break;
				case 2:
					instance = new TempClass(args[0],args[1]);
					break;
				case 3:
					instance = new TempClass(args[0],args[1],args[2]);
					break;
				case 4:
					instance = new TempClass(args[0],args[1],args[2],args[3]);
					break;
				case 5:
					instance = new TempClass(args[0],args[1],args[2],args[3],args[4]);
					break;
				case 6:
					instance = new TempClass(args[0],args[1],args[2],args[3],args[4],args[5]);
					break;
				case 7:
					instance = new TempClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
					break;
				case 8:
					instance = new TempClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
					break;
				case 9:
					instance = new TempClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
					break;
				default:
					throw new Error("实例化参数超过10个！");
				
					
					
			}
			return instance;
		}
		public static function disableMouse(target:DisplayObjectContainer):void{
			target.mouseEnabled = target.mouseChildren = false;
		}
		
		
		public static function stopAllPlayHead(mc:MovieClip):void
		{
			mc.stop();
			var num:int = mc.numChildren;
			for(var i:int= 0;i<num;i++)
			{
				if(mc.getChildAt(i) is MovieClip)
				{
					stopAllPlayHead(mc.getChildAt(i) as MovieClip);
				}
			}
		}
		public static function changeCoordinateSpace(target:DisplayObject,container:DisplayObjectContainer):void
		{
			if(target.parent && (target.parent != container)){
				var p:Point = PointUtil.changeCoordinate(target.parent,container,new Point(target.x,target.y));
				target.x = p.x;
				target.y = p.y;
			container.addChild(target);
			}
		}

	}
}