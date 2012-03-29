package com.horidream.util
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 30, 2011
	 */
	public class SocialSharing
	{
		public static const REN_REN:String = "renren";
		public static const SINA:String = "sina";
		public static const KAI_XIN:String = "kaixin";
		public static const DOU_BAN:String = "douban";
		public static const QQ:String = "qq";
		
		
		public static function share(siteName:String,vars:Object = null):void
		{
			
			vars = vars || new Object;
			var url:String = vars.url || null;
			var link:String = vars.link || null;
			var title:String = vars.title || "";
			var content:String = vars.content || "";
			var picture:String = vars.picture || null;
			
			var address:String = "";
			
			switch(siteName)
			{
				case "renren":
				{
					
					address += ("link="+encodeURIComponent(url || title));
					address += ("&title="+encodeURIComponent(title));
					address += ("&content="+encodeURIComponent(content));
//					address += ("&title="+escape(title));
					navigateToURL(new URLRequest("http://share.renren.com/share/buttonshare.do?"+address), "_blank");
					break;
				}
				case "sina":
				{
//					address += "appkey=312479806";
					address += ("title="+encodeURIComponent(title+content));
					address += ("&content="+encodeURIComponent(title+content));
					address += (url?("&url="+encodeURIComponent(url)):"");
					address += (picture?("&pic="+encodeURIComponent(picture)):"");
					address += (link?"&source=&sourceUrl="+link:"&source="+encodeURIComponent(url));
					
					navigateToURL(new URLRequest("http://v.t.sina.com.cn/share/share.php?" + address), "_blank");
					break;
				}
				case "kaixin":
				{
					address += ("rtitle="+encodeURIComponent(title));
					address += ("&rcontent="+encodeURIComponent(content));
					address += (url?"&rurl="+url:"");
					navigateToURL(new URLRequest("http://www.kaixin001.com/repaste/share.php?" + address), "_blank");
					break;
				}
				case "douban":
				{
					address += ("title="+encodeURIComponent(title));
					address += (url?"&rurl="+url:"");
					address += ("&v=1");
					navigateToURL(new URLRequest("http://www.douban.com/recommend/?"+address), "_blank");
					break;
				}
				case "qq":
				{
					address += ("title="+encodeURIComponent(title));
					address += ("&url="+url);
					address += ("&appkey="+encodeURIComponent("appkey"));
					address += ("&site="+url);
					address += (picture?("&pic="+picture):"");
					
					navigateToURL(new URLRequest("http://v.t.qq.com/share/share.php?"+address), "_blank");
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
	}
}