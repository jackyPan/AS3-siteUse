package com.horidream.util
{

	/**
	 * Copyright 2011. All rights reserved.
	 *
	 * @author 	horidream
	 * @since 	Aug 31, 2011
	 */
	public class XMLUtil
	{
		public static function sortXML(source:XML, elementName:Object, fieldName:Object, options:Object = null):XML
		{
			// list of elements we're going to sort
			var list:XMLList = source.elements("*").(name() == elementName);

			// list of elements not included in the sort -
			// we place these back into the source node at the end
			var excludeList:XMLList = source.elements("*").(name() != elementName);

			list = sortXMLList(list, fieldName, options);
			list += excludeList;

			source.setChildren(list);
			return source;
		}

		public static function sortXMLList(list:XMLList, fieldName:Object, options:Object = null):XMLList
		{
			var arr:Array = new Array();
			var ch:XML;
			for each (ch in list)
			{
				arr.push(ch);
			}
			var resultArr:Array = fieldName == null ? options == null ? arr.sort() : arr.sort(options) : arr.sortOn(fieldName, options);

			var result:XMLList = new XMLList();
			for (var i:int = 0; i < resultArr.length; i++)
			{
				result += resultArr[i];
			}
			return result;
		}
		public static function reverseXMLList(list:XMLList):XMLList
		{
			var result:XMLList = new XMLList();
			var ch:XML;
			for each (ch in list)
			{
				result = ch + result;
			}
			return result;
		}
	}
}
