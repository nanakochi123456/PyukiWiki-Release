/* "PyukiWiki" version 0.1.9-p1 $$ */
/* $Id$ */

var d=document;var ie=d.selection?1:0;var moz=(d.getSelection&&!window.opera)?1:0;function addec_link(e){var b=cs.indexOf(e.charAt(0))*cs.length+cs.indexOf(e.charAt(1));for(var h="",a=2;a<e.length;a+=2){var f=cs.indexOf(e.charAt(a)),g=f*cs.length+cs.indexOf(e.charAt(a+1))-b;h=h+String.fromCharCode(g)}if(confirm("New mail creation as address\n>>"+h)){location=h}}function addec_text(e){var b=cs.indexOf(e.charAt(0))*cs.length+cs.indexOf(e.charAt(1));for(var h="",a=2;a<e.length;a+=2){var f=cs.indexOf(e.charAt(a)),g=f*cs.length+cs.indexOf(e.charAt(a+1))-b;h=h+String.fromCharCode(g)}document.write(h)}function openURI(b,c){window.open(b,c);return false}function getClientWidth(){if(self.innerWidth){return self.innerWidth}else{if(d.documentElement&&d.documentElement.clientWidth){return d.documentElement.clientWidth}else{if(d.body){return d.body.clientWidth}}}}function getClientHeight(){if(self.innerHeight){return self.innerHeight}else{if(d.documentElement&&d.documentElement.clientHeight){return d.documentElement.clientHeight}else{if(d.body){return d.body.clientHeight}}}}function getDocHeight(){var a;if(d.documentElement&&d.body){a=Math.max(d.documentElement.scrollHeight,d.documentElement.offsetHeight,d.body.scrollHeight)}else{a=d.body.scrollHeight}return(arguments.length==1)?a+"px":a}function getScrollY(){if(typeof window.pageYOffset!="undefined"){return window.pageYOffset}else{if(d.body&&typeof d.body.scrollTop!="undefined"){if(d.compatMode=="CSS1Compat"){return d.documentElement.scrollTop}return d.body.scrollTop}else{if(d.documentElement&&typeof d.documentElement.scrollTop!="undefined"){return d.documentElement.scrollTop}}}return 0}var imgPop=null;imagePop=function(e,path,w,h){if(imgPop==null){imgPop=d.createElement("IMG");imgPop.src=path;with(imgPop.style){position="absolute";left=Math.round((getClientWidth()-w)/2)+"px";top=Math.round((getClientHeight()-h)/2+getScrollY())+"px";margin="0";zIndex=1000;border="4px groove Teal";display="none"}d.body.appendChild(imgPop);if(imgPop.complete){imgPop.style.display="block"}else{window.status="画像読み込み中…"}imgPop.onload=function(){imgPop.style.display="block";window.status=""};imgPop.onclick=function(){d.body.removeChild(imgPop);imgPop=null};imgPop.title="Close for mouse click"}};hackFirefoxToolTip=function(e){var aa=d.getElementsByTagName("A");var tT=d.createElement("DIV");var sd=d.createElement("DIV");with(tT.style){position="absolute";backgroundColor="ivory";border="1px solid #333";padding="1px 3px 1px 3px";font="500 11px arial";zIndex=10000;top="-100px"}with(sd.style){position="absolute";MozOpacity=0.3;MozBorderRadius="3px";background="#000";zIndex=tT.style.zIndex-1}for(i=0,l=aa.length;i<l;i++){if(aa[i].getAttribute("title")!=null||aa[i].getAttribute("alt")!=null){aa[i].onmouseover=function(e){var _title=this.getAttribute("title")!=null?this.getAttribute("title"):this.getAttribute("alt");this.setAttribute("title","");_title=_title.replace(/[\r\n]+/g,"<br/>").replace(/\s/g,"&nbsp;");if(_title==""){return}tT.style.left=20+e.pageX+"px";tT.style.top=10+e.pageY+"px";tT.innerHTML=_title;with(sd.style){width=tT.offsetWidth-2+"px";height=tT.offsetHeight-2+"px";left=parseInt(tT.style.left)+5+"px";top=parseInt(tT.style.top)+5+"px"}};aa[i].onmouseout=function(){this.setAttribute("title",tT.innerHTML.replace(/<br\/>/g,"&#13;&#10;").replace(/&nbsp;/g," "));tT.style.top="-1000px";sd.style.top="-1000px";tT.innerHTML=""}}}d.body.appendChild(sd);d.body.appendChild(tT)};window.onload=function(){if(moz){hackFirefoxToolTip()}};
