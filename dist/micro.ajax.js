(function(){!function(a){"use strict";var b;return a.ajax=function(c){var d,e;return d={type:"GET",async:!0,success:function(){},error:function(){},contentType:"application/json",headers:{},crossDomain:!1,timeout:0},c=a.extend(d,c),c.data=a.serialize(c),e=new XMLHttpRequest,e.open(c.type,c.url,c.async),e.onload=function(){var a;return a=e.responseText,e.status>=200&&e.status<400&&"application/json"===c.contentType&&(a=JSON.parse(e.responseText)),c.success(a)},e.onerror=function(){return c.error("error")},b(e,c),e.send(c.data),e},a.serialize=function(a){return"application/json"===a.contentType?JSON.stringify(a.data):a.data},b=function(a,b){var c;b.contentType&&(b.headers["Content-Type"]=b.contentType),b.contentType&&(b.headers.Accept=b.contentType);for(c in b.headers)a.setRequestHeader(c,b.headers[c])}}(u)}).call(this);