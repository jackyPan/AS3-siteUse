package com.horidream.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Oct 5, 2010 4:17:53 PM
	 */
	public class Cast
	{
		public static function bitmapData(data:*):BitmapData
		{
			if (data is String)
			{
				try{
					data = getDefinitionByName(data) as Class;
				}catch(e:Error){
					data = BitmapDataUtil.getPattern(data,new Rectangle(0,0,640,480));
				}
			}
			if  (data is Number)
			{
				data = BitmapDataUtil.getPattern(data,new Rectangle(0,0,640,480));
			}
			if (data == null)
				return null;
			if (data is Class)
			{
				try
				{
					data = new data();
				}
				catch (bitmaperror:ArgumentError)
				{
					data = new data(0,0);
				}
			}
			
			if (data is BitmapData){
				if(data.transparent){	
					return data;
				}else{
					data = new Bitmap(data);
				}
			}
			
			if (data is Bitmap)
				if ((data as Bitmap).hasOwnProperty("bitmapData")) // if (data is BitmapAsset)
					if((data as Bitmap).bitmapData.transparent){
						return (data as Bitmap).bitmapData;
					}
			
			var rec:Rectangle;
			if (data is DisplayObject)
			{
				var ds:DisplayObject = data as DisplayObject;
				var filters:Array = ds.filters.concat();
				ds.filters = [];
//				if(ds.parent){
////					rec = ds.getBounds(ds.parent);
//					rec = RecUtil.getVisibleBounds(ds,ds.parent);
//				}else{
//					rec = ds.getBounds(ds);
					rec = RecUtil.getVisibleBounds(ds);
//				}
				if(rec.isEmpty()){
					return null;
				}
				var bmd:BitmapData = new BitmapData(rec.width, rec.height, true, 0x00FFFFFF);
				var mat:Matrix = new Matrix();
//				var mat:Matrix = ds.transform.matrix.clone();
//				mat.tx = 0;
//				mat.ty = 0;
				mat.tx = -rec.x;
				mat.ty = -rec.y;
//				rec.x = rec.y = 0;
				bmd.draw(ds, mat, ds.transform.colorTransform, ds.blendMode, null, true);
//				var filteredBmd:BitmapData = new BitmapData(rec.width+200,rec.height+200,true,0x00FFFFFF);
//				if(filters.length>0){
//					filteredBmd.copyPixels(bmd,bmd.rect,new Point(100,100));
//					for(var i:int = 0;i<filters.length;i++){
//						filteredBmd.applyFilter(filteredBmd,filteredBmd.rect,new Point(),filters[i]);
//					}
//					var rect:Rectangle = filteredBmd.getColorBoundsRect(0xFF000000, 0x00000000,false);
//					var finalBmd:BitmapData = new BitmapData(rect.width,rect.height,true,0x00FFFFFF);
//					finalBmd.copyPixels(filteredBmd,rect,new Point());
//					bmd = finalBmd;
//				}
				return bmd;
			}
			
			throw new Error("Can't cast to bitmapData: "+data);
		}
		public static function bitmap(data:*):Bitmap
		{
			if(data is Bitmap){
				return data as Bitmap;
			}
			var bm:Bitmap = new Bitmap(Cast.bitmapData(data),"auto",true);
//			if(Object(data).hasOwnProperty("transform")){
//				bm.transform = data["transform"];
//				trace(data['transform'].matrix);
//			}
			return bm;
		}
		public static function movieClip(data:*):MovieClip
		{
			if(data is MovieClip){
				return data as MovieClip;
			}
			var movieCanvas:MovieClip = new MovieClip();
			if (data is String)
			{
				try{
					data = getDefinitionByName(data) as Class;
				}catch(e:Error){return null}
			}
			if (data == null)
				return null;
			if (data is Class)
			{
				try
				{
					data = new data();
				}
				catch (bitmaperror:ArgumentError)
				{
					data = new data(0,0);
				}
			}
			if (data is MovieClip){
				return data;
			}
			
			if (data is BitmapData){
				movieCanvas.addChild(new Bitmap(data));
				return movieCanvas;
			}
			
			if (data is DisplayObject){
				var tempObj:DisplayObject = data as DisplayObject;
				if(tempObj.parent){
					var index:int = tempObj.parent.getChildIndex(tempObj);
					tempObj.parent.addChildAt(movieCanvas,index);
				}
				movieCanvas.addChild(tempObj);
				return movieCanvas;
			}
			throw new Error("Can't cast to bitmapData: "+data);
		}
		public static function replaceWithBitmap(target:DisplayObject,rec:Rectangle = null):Bitmap
		{
			if(target is Bitmap)
			{
				return target as Bitmap;
			}
			if(!target.parent){
				return null;
			}
			var visibleRec:Rectangle = RecUtil.getVisibleBounds(target,target.parent);
			var m:Matrix = target.transform.matrix.clone();
			var bmd:BitmapData;
			var bm:Bitmap;
			if(rec){
				m.tx -= rec.x;
				m.ty -= rec.y;
				bmd =new BitmapData(rec.width,rec.height,true,0xFFFF0000);
				bmd.draw(target,m,null,null,null,true);
				bm = new Bitmap(bmd);
				bm.x += rec.x;
				bm.y += rec.y;
				
			}else{
				rec = new Rectangle(0,0,visibleRec.width,visibleRec.height);
				bmd =new BitmapData(rec.width,rec.height,true,0);
				m.tx -= visibleRec.x;
				m.ty -= visibleRec.y;
				bmd.draw(target,m,null,null,null,true);
				bm = new Bitmap(bmd);
				bm.x += visibleRec.x;
				bm.y += visibleRec.y;
			}
			QuickSetter.swapDisplayObject(bm,target);
			return bm;
		}
//		public static function replaceWithBitmapAccordingStage(target:DisplayObject):Bitmap
//		{
//			if(target.stage){
//				trace(RecUtil.globalToLocal(RecUtil.getStageRec(target.stage),target.parent));
//				return replaceWithBitmap(target,RecUtil.globalToLocal(RecUtil.getStageRec(target.stage),target.parent));
//			}
//			return null;
//		}
	}
}