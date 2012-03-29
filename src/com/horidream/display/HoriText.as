package com.horidream.display
{
	import com.horidream.util.BitmapDataUtil;
	import com.horidream.util.Cast;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 29, 2010 11:13:13 PM
	 */
	public class HoriText
	{
		/*Mac OS
		华文细黑STHeiti Light [STXihei]\534E\6587\7EC6\9ED1华文细黑
		华文黑体STHeiti\534E\6587\9ED1\4F53华文黑体
		华文楷体STKaiti\534E\6587\6977\4F53华文楷体
		华文宋体STSong\534E\6587\5B8B\4F53华文宋体
		华文仿宋STFangsong\534E\6587\4EFF\5B8B华文仿宋
		丽黑 ProLiHei Pro Medium\4E3D\9ED1 Pro丽黑 Pro
		丽宋 ProLiSong Pro Light\4E3D\5B8B Pro丽宋 Pro
		标楷体BiauKai\6807\6977\4F53标楷体
		苹果丽中黑Apple LiGothic Medium\82F9\679C\4E3D\4E2D\9ED1苹果丽中黑
		苹果丽细宋Apple LiSung Light\82F9\679C\4E3D\7EC6\5B8B苹果丽细宋
		Windows
		新细明体PMingLiU\65B0\7EC6\660E\4F53新细明体
		细明体MingLiU\7EC6\660E\4F53细明体
		标楷体DFKai-SB\6807\6977\4F53标楷体
		黑体SimHei\9ED1\4F53黑体
		宋体SimSun\5B8B\4F53宋体
		新宋体NSimSun\65B0\5B8B\4F53新宋体
		仿宋FangSong\4EFF\5B8B仿宋
		楷体KaiTi\6977\4F53楷体
		仿宋_GB2312FangSong_GB2312\4EFF\5B8B_GB2312仿宋_GB2312
		楷体_GB2312KaiTi_GB2312\6977\4F53_GB2312楷体_GB2312
		微软正黑体Microsoft JhengHei\5FAE\x8F6F\6B63\9ED1\4F53微软正黑体
		微软雅黑Microsoft YaHei\5FAE\8F6F\96C5\9ED1微软雅黑
		Office
		隶书LiSu\96B6\4E66隶书
		幼圆YouYuan\5E7C\5706幼圆
		华文细黑STXihei\534E\6587\7EC6\9ED1华文细黑
		华文楷体STKaiti\534E\6587\6977\4F53华文楷体
		华文宋体STSong\534E\6587\5B8B\4F53华文宋体
		华文中宋STZhongsong\534E\6587\4E2D\5B8B华文中宋
		华文仿宋STFangsong\534E\6587\4EFF\5B8B华文仿宋
		方正舒体FZShuTi\65B9\6B63\8212\4F53方正舒体
		方正姚体FZYaoti\65B9\6B63\59DA\4F53方正姚体
		华文彩云STCaiyun\534E\6587\5F69\4E91华文彩云
		华文琥珀STHupo\534E\6587\7425\73C0华文琥珀
		华文隶书STLiti\534E\6587\96B6\4E66华文隶书
		华文行楷STXingkai\534E\6587\884C\6977华文行楷
		华文新魏STXinwei\534E\6587\65B0\9B4F华文新魏*/
		private static var chineseFontNameArr:Array = [
			"华文细黑",
			"华文仿宋",
			"华文黑体",
			"华文琥珀",
			"微软雅黑",
			"幼圆",
			"黑体",
			"楷体",
			"宋体",
			"方正准圆简体",
			""
			];
		private static var chineseFontFamilyArr:Array = [
			"STXihei",
			"STSong",
			"STHeiti",
			"STHupo",
			"Microsoft YaHei",
			"YouYuan",
			"SimHei",
			"KaiTi",
			"SimSun",
			"FZZhunYuan-M02S",
			""
		];
		
		
		public static const HEI:String = "微软雅黑,华文黑体,华文细黑,Hei";
		
		private static var fontArr:Array;

		/**
		 * 快速添加一个文本 
		 * @param container		文本的容器
		 * @param text			文本内容
		 * @param fontSize		文本字号
		 * @param width			文本的宽度
		 * @param fontColor		文本颜色
		 * @param fontName		文本字体名称
		 * @param fontBold		文本是否为粗体
		 * @return 				返回添加的TextField
		 * 
		 */
		public static function addText(
									   container:DisplayObjectContainer = null,
									   text:String = "",
									   fontSize:uint = 12,
									   width:Number = 550,
									   fontColor:uint = 0x0,
									   fontName:String = "",
									   fontBold:Boolean = false
		):TextField
		{
			var tf:TextField = new TextField();
			tf.width = width;
			tf.wordWrap = true;
			tf.autoSize = "left";
			tf.text = text;
			tf.selectable = false;
			
			
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.size = fontSize;
			format.color = fontColor;
			format.bold = fontBold;
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			
			if(container){
				container.addChild(tf);
			}
			return tf;
		}
		public static function creatText(
									   vars:Object,
									   container:DisplayObjectContainer = null
		):TextField
		{
			var tf:TextField = new TextField();
			tf.width = vars.width || 550;
			tf.wordWrap = vars.wordWrap || true;
			tf.autoSize = vars.autoSize || "left";
			if(vars.htmlText){
				tf.htmlText = vars.htmlText;
			}else{
				tf.text = vars.text || "";
			}
			tf.selectable = vars.selectable || false;
			
			
			if(vars){
			var format:TextFormat = createTextFormat(vars);
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			}
			if(container){
				container.addChild(tf);
			}
			return tf;
		}
		public static function createBitmapText(
			vars:Object,
			fillPattern:* ,
			container:DisplayObjectContainer = null
		):Bitmap
		{
			var textBmd:BitmapData = Cast.bitmapData(creatText(vars));
			if(!textBmd){
				return new Bitmap;
			}
			var trimedRec:Rectangle = textBmd.getColorBoundsRect(0xFF000000,0x00000000,false);
			var trimTextBmd:BitmapData = new BitmapData(trimedRec.width,trimedRec.height,true,0x00FFFFFF);
			trimTextBmd.copyPixels(textBmd,trimedRec,new Point());
			var bg:BitmapData;
			if(fillPattern is Number || fillPattern is String){
				bg = BitmapDataUtil.getPattern(fillPattern,trimTextBmd.rect);
			}else{
				bg = Cast.bitmapData(fillPattern);
			}
			var finalBg:BitmapData = new BitmapData(trimTextBmd.width,trimTextBmd.height,true,0x00FFFFFF);
			finalBg.draw(bg,new Matrix(finalBg.width/bg.width,0,0,finalBg.height/bg.height),null,null,null,true);
			var p:Point = new Point();
			finalBg.copyChannel(trimTextBmd,trimTextBmd.rect,p,8,8);
			var finalText:Bitmap = new Bitmap(finalBg);
			if(container){
				container.addChild(finalText);
			}
			return finalText;
		}
		public static function addBitmapText(
			fillPattern:* ,
			container:DisplayObjectContainer = null,
			text:String = "",
			fontSize:uint = 12,
			width:Number = 550,
			fontName:String = "",
			fontBold:Boolean = false
		):Bitmap
		{
			var textBmd:BitmapData = Cast.bitmapData(addText(null,text,fontSize,width,0,fontName,fontBold));
			var trimedRec:Rectangle = textBmd.getColorBoundsRect(0xFF000000,0x00000000,false);
			var trimTextBmd:BitmapData = new BitmapData(trimedRec.width,trimedRec.height,true,0x00FFFFFF);
			trimTextBmd.copyPixels(textBmd,trimedRec,new Point());
			var bg:BitmapData;
			if(fillPattern is Number || fillPattern is String){
				bg = BitmapDataUtil.getPattern(fillPattern,trimTextBmd.rect);
			}else{
				bg = Cast.bitmapData(fillPattern);
			}
			var finalBg:BitmapData = new BitmapData(trimTextBmd.width,trimTextBmd.height,true,0x00FFFFFF);
			finalBg.draw(bg,new Matrix(finalBg.width/bg.width,0,0,finalBg.height/bg.height),null,null,null,true);
			var p:Point = new Point();
			finalBg.copyChannel(trimTextBmd,trimTextBmd.rect,p,8,8);
			var finalText:Bitmap = new Bitmap(finalBg);
			if(container){
				container.addChild(finalText);
			}
			return finalText;
		}
		/**
		 * 截取一个TextField指定位置字符的TextField片段 
		 * @param textField 被截取的TextField
		 * @param index		截取的位置
		 * @return 			截取出的TextField
		 * 
		 */
		public static function getTextFieldAt(textField:TextField,index:int):TextField {
			var t:TextField = new TextField();
			t.selectable=false;
			t.embedFonts=textField.embedFonts;
			t.text=textField.text.charAt(index);
			t.filters = textField.filters;
			var format:TextFormat = textField.getTextFormat(index,index+1);
			t.setTextFormat(format,0,1);
			t.defaultTextFormat = format;
			var rect:Rectangle=textField.getCharBoundaries(index);
			var tRect:Rectangle=t.getCharBoundaries(0);
			if (rect&&tRect) {
				t.x = rect.x - tRect.x + textField.x ;
				t.y = rect.y - tRect.y + textField.y ;
			}
			return t;
		}
		public static function setTextFormat(textField:TextField,format:TextFormat,pattern:RegExp = null):void
		{
			
			var text:String = textField.text;
			var len:int = text.length;
			if(!pattern)
			{
				textField.setTextFormat(format,0,len);
				return;
			}	
//			if(!pattern.global)
//			{
//				while(--len >=0)
//				{
//					if(pattern.test(text.charAt(len)) != inverse)
//					{
//						textField.setTextFormat(format,len,len+1);
//					}
//				}
//			}else{
				var result:Object = pattern.exec(text);
				while(result != null){
					textField.setTextFormat(format,result.index,result.index+result[0].length);
					if(pattern.global){
						result = pattern.exec(text);
					}else{
						result = null;
					}
				}
//			}
		}
		public static function createTextFormat(vars:Object = null):TextFormat
		{
			var vars:Object = vars || {};
			var fontName:String = "";
			var fontFamily:String = vars.fontFamily;
			if(fontFamily)
			{
				fontFamily = fontFamily.replace(/\s*,\s*/g,",");
				var fontPriorityArr:Array = vars.fontFamily.split(",");
				var len:int = fontPriorityArr.length;
				var i:int = 0;
				while(i<len){
					if(hasFont(fontPriorityArr[i]))
					{
						fontName = fontPriorityArr[i];
//						trace(fontName);
						var index:int = chineseFontNameArr.indexOf(fontName);
						if(index>-1)
							fontName = chineseFontFamilyArr[index];
						break;
					}
					i++;
				}
			}
			var format:TextFormat = new TextFormat(fontName,
				vars.size,vars.color,vars.bold,vars.italic,
				vars.underline,vars.url,vars.target,vars.align,
				vars.leftMargin,vars.rightMargin,vars.indent,vars.leading);
			return format;
		}
		public static function hasFont(fontName:String):Boolean
		{
			if(!fontArr){
				fontArr = Font.enumerateFonts(true);
			}
			return fontArr.some(checkFont);
			function checkFont(item:*, index:int, array:Array):Boolean
			{
				if(item.fontName == fontName)
				{
					return true;
				}else
				{
					return false;
				}
			}
		}
	}
}