/* "PyukiWiki" version 0.2.0 $$ */
/* $Id$ */
var ef="editform";function pencf(c,b,e){var a;if(c.value==""){return}b.value=penc(utf16to8(c.value),utf16to8(e.value));c.value=""}function penc(g,f){var e,a,c,b;c="";for(e=0;e<g.length;e++){b=(Math.floor(Math.random()*127)+e)%127;c=c+f.substr(b/16,1)+f.substr(b%16,1);a=g.charCodeAt(e)+b;c=c+f.substr(a/16,1)+f.substr(a%16,1)}return c}function getid(a){return d.getElementById(a)}function keypress(b){if(b==null){return true}var a=keyCode(b);if(a==32||a==13){return true}return false}function fsubmit(f,a,b){if(keypress(b)==false){return}var c="mypassword_";pencf(getid(c+a),getid(c+a+"_enc"),getid(c+a+"_token"));fsubmitdelay(f,b)}function fsubmitdelay(b,a){if(keypress(a)==false){return}fid=b;setTimeout("fsub();",30)}function fsub(){getid(fid).submit()}function editpost(a,c){var b=getid(ef);if(b.mypreviewjs_adminedit){b.mypreviewjs_adminedit.value="";if(a==0){b.mypreviewjs_adminedit.value="1"}}if(b.mypreviewjs_edit){b.mypreviewjs_edit.value="";if(a==0){b.mypreviewjs_edit.value="1"}}if(b.mypreviewjs_write){b.mypreviewjs_write.value="";if(a==1){b.mypreviewjs_write.value="1"}}if(b.mypreviewjs_cancel){b.mypreviewjs_cancel.value="";if(a==2){b.mypreviewjs_cancel.value="1"}}fsubmit(ef,"frozen",c)}function utf16to8(f){var b,e,a,g;b="";a=f.length;for(e=0;e<a;e++){g=f.charCodeAt(e);if((g>=1)&&(g<=127)){b+=f.charAt(e)}else{if(g>2047){b+=String.fromCharCode(224|((g>>12)&15));b+=String.fromCharCode(128|((g>>6)&63));b+=String.fromCharCode(128|((g>>0)&63))}else{b+=String.fromCharCode(192|((g>>6)&31));b+=String.fromCharCode(128|((g>>0)&63))}}}return b};