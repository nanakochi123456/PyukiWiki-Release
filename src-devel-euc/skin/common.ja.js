/* "PyukiWiki" version 0.2.0-p2 $$ */
/* $Id: common.ja.js,v 1.527 2012/03/01 10:39:23 papu Exp $ */

var w=window,d=w.document,n=navigator,x=-1,u=n.userAgent.toLowerCase(),op=(u.indexOf("opera")>x),ie=(u.indexOf("msie")>x&&!op),ff=(u.indexOf("firefox")>x),moz=(u.indexOf("gecko")>x||ff),gc=(u.indexOf("chrome")>x),sa=(u.indexOf("safari")>x),p="px";function addec_link(a){var b=ae(a);if(confirm("送信先を\n>> "+b+"\nとして新規にメールを作成します.")){w.location=b}}function addec_text(a,b){d.getElementById(b).innerHTML=ae(a)}function ae(e){for(var h="",b=0;b<e.length;b+=4){var a=cs.indexOf(e.charAt(b))*cs.length+cs.indexOf(e.charAt(b+1)),f=cs.indexOf(e.charAt(b+2)),g=f*cs.length+cs.indexOf(e.charAt(b+3))-a;h=h+String.fromCharCode(g)}return h}function ou(b,c){window.open(b,c);return false}function keyCode(a){var a=w.event||a;if(d.all){return a.keyCode}else{if(d.getElementById){return a.keyCode?a.keyCode:a.charCode}else{if(d.layers){return a.which}}}}function escpress(a){if(!ie){return true}if(a==null){return true}if(d.all&&keyCode(a)==27){return false}return true}function getClientWidth(){if(self.innerWidth){return self.innerWidth}else{if(d.documentElement&&d.documentElement.clientWidth){return d.documentElement.clientWidth}else{if(d.body){return d.body.clientWidth}}}}function getClientHeight(){if(self.innerHeight){return self.innerHeight}else{if(d.documentElement&&d.documentElement.clientHeight){return d.documentElement.clientHeight}else{if(d.body){return d.body.clientHeight}}}}function getDocHeight(){var a;if(d.documentElement&&d.body){a=Math.max(d.documentElement.scrollHeight,d.documentElement.offsetHeight,d.body.scrollHeight)}else{a=d.body.scrollHeight}return(arguments.length==1)?a+p:a}function getScrollY(){var a="undefined";if(typeof w.pageYOffset!=a){return w.pageYOffset}else{if(d.body&&typeof d.body.scrollTop!=a){if(d.compatMode=="CSS1Compat"){return d.documentElement.scrollTop}return d.body.scrollTop}else{if(d.documentElement&&typeof d.documentElement.scrollTop!=a){return d.documentElement.scrollTop}}}return 0}var iP=null;imagePop=function(e,path,w,h){if(iP==null){iP=d.createElement("img");iP.src=path;with(iP.style){position="absolute";left=Math.round((getClientWidth()-w)/2)+p;top=Math.round((getClientHeight()-h)/2+getScrollY())+p;margin="0";zIndex=1000;border="4px groove Teal";display="none"}d.body.appendChild(iP);if(iP.complete){iP.style.display="block"}else{w.status="Loading image..."}iP.onload=function(){iP.style.display="block";w.status=""};iP.onclick=function(){d.body.removeChild(iP);iP=null};iP.title="マウスクリックで閉じます"}};hF=function(e){var aa=d.getElementsByTagName("a"),tT=d.createElement("div"),sd=d.createElement("div");with(tT.style){position="absolute";backgroundColor="ivory";border="1px solid #333";padding="1px 3px 1px 3px";font="500 11px arial";zIndex=10000;top="-100px"}with(sd.style){position="absolute";MozOpacity=0.3;MozBorderRadius="3px";background="#000";zIndex=tT.style.zIndex-1}for(i=0,l=aa.length;i<l;i++){if(aa[i].getAttribute("title")!=null||aa[i].getAttribute("alt")!=null){aa[i].onmouseover=function(e){var _title=this.getAttribute("title")!=null?this.getAttribute("title"):this.getAttribute("alt");this.setAttribute("title","");_title=_title.replace(/[\r\n]+/g,"<br/>").replace(/\s/g,"&nbsp;");if(_title==""){return}tT.style.left=20+e.pageX+p;tT.style.top=10+e.pageY+p;tT.innerHTML=_title;with(sd.style){width=tT.offsetWidth-2+p;height=tT.offsetHeight-2+p;left=parseInt(tT.style.left)+5+p;top=parseInt(tT.style.top)+5+p}};aa[i].onmouseout=function(){this.setAttribute("title",tT.innerHTML.replace(/<br\/>/g,"&#13;&#10;").replace(/&nbsp;/g," "));tT.style.top="-1000px";sd.style.top="-1000px";tT.innerHTML=""}}}d.body.appendChild(sd);d.body.appendChild(tT)};w.onload=function(){if(moz){hF(event)}};
