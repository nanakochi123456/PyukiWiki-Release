/* "PyukiWiki" version 0.2.0 $$ */
/* $Id: instag.js,v 1.171 2011/12/31 13:06:16 papu Exp $ */

var noOverwrite=false,alertText,clientPC=navigator.userAgent.toLowerCase(),is_gecko=((clientPC.indexOf("gecko")!=-1)&&(clientPC.indexOf("spoofer")==-1)&&(clientPC.indexOf("khtml")==-1)&&(clientPC.indexOf("netscape/7.0")==-1)),is_safari=((clientPC.indexOf("AppleWebKit")!=-1)&&(clientPC.indexOf("spoofer")==-1));function insTag(j,a,b){var l=d.editform.mymsg;if(d.selection&&!is_gecko){var m=d.selection.createRange().text;if(!m){m=b}l.focus();if(m.charAt(m.length-1)==" "){m=m.substring(0,m.length-1);d.selection.createRange().text=j+m+a+" "}else{d.selection.createRange().text=j+m+a}}else{if(l.selectionStart||l.selectionStart=="0"){var k=l.selectionStart,c=l.selectionEnd,f=l.scrollTop,e=(l.value).substring(k,c);if(!e){e=b}if(e.charAt(e.length-1)==" "){subst=j+e.substring(0,(e.length-1))+a+" "}else{subst=j+e+a}l.value=l.value.substring(0,k)+subst+l.value.substring(c,l.value.length);l.focus();var o=k+(j.length+e.length+a.length);l.selectionStart=o;l.selectionEnd=o;l.scrollTop=f}else{var i=alertText,h=new RegExp("\\$1","g"),g=new RegExp("\\$2","g"),n;i=i.replace(h,b);i=i.replace(g,j+b+a);if(b){n=prompt(i)}else{n=""}if(!n){n=b}n=j+n+a;d.infoform.infobox.value=n;if(!is_safari){l.focus()}noOverwrite=true}}if(l.createTextRange){l.caretPos=d.selection.createRange().duplicate()}};