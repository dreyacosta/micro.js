(function(){var a;a=function(){"use strict";var b,c,d;return b=Array.prototype.forEach,c=Array.prototype.push,d=Array.prototype.slice,a=window.u=function(b){return this instanceof a?b?b instanceof a?b:"string"==typeof b?c.apply(this,d.call(document.querySelectorAll(b))):"function"==typeof b?a(document).ready(b):void 0:this:new a(b)},a.prototype={length:0,each:function(a){return b.call(this,function(b,c){return a.call(b,c)}),this},ready:function(b){return"complete"===document.readyState&&b(a),document.addEventListener("DOMContentLoaded",function(){return b(a)})},text:function(a){return this.each(function(){return this.textContent=a})},html:function(a){return this.each(function(){return this.innerHTML=a})},append:function(a){return this.each(function(){return this.appendChild(a)})},prepend:function(a){return this.each(function(){return this.insertBefore(a,this.firstChild)})},on:function(a,b){return this.each(function(){return this.addEventListener(a,b)})},off:function(a,b){return this.each(function(){return this.removeEventListener(a,b)})}},a}(),this.u=a}).call(this);
(function(){!function(a){"use strict";var b;return a.subscribers={},a.extend=function(a){var b;return b=Array.prototype.slice.call(arguments,1),b.forEach(function(b){var c,d;d=[];for(c in b)d.push(a[c]=b[c]);return d}),a},a.subscribe=function(b,c){a.subscribers[b]||(a.subscribers[b]=[]),-1===a.subscribers[b].indexOf(c)&&a.subscribers[b].push(c)},a.unsubscribe=function(b,c){var d,e;e=a.subscribers[b],e&&(d=e.indexOf(c),d>-1&&e.splice(d,1))},a.publish=function(b,c){var d,e,f,g,h;if(!a.subscribers[b])return!1;for(c.type||(c.type=b),e=a.subscribers[b],h=[],f=0,g=e.length;g>f;f++)d=e[f],h.push(d(c));return h},a.ajax=function(c){var d,e;return d={type:"GET",async:!0,success:function(){},error:function(){},contentType:"application/json",headers:{},crossDomain:!1,timeout:0},c=a.extend(d,c),c.data=a.serialize(c),e=new XMLHttpRequest,e.open(c.type,c.url,c.async),e.onload=function(){var a;return a=e.responseText,e.status>=200&&e.status<400&&"application/json"===c.dataType&&(a=JSON.parse(e.responseText)),c.success(a)},e.onerror=function(){return c.error("error")},b(e,c),e.send(c.data),e},a.serialize=function(a){return"application/json"===a.contentType?JSON.stringify(a.data):a.data},b=function(a,b){var c;b.contentType&&(b.headers["Content-Type"]=b.contentType),b.dataType&&(b.headers.Accept=b.dataType);for(c in b.headers)a.setRequestHeader(c,b.headers[c])}}(u)}).call(this);