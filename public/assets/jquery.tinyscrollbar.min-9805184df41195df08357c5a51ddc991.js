!function(t){function o(o,s){function a(){return l.update(),i(),l}function e(){var t=v.toLowerCase();j.obj.css(p,w/h.ratio),m.obj.css(p,-w),g.start=j.obj.offset()[p],h.obj.css(t,x[s.axis]),x.obj.css(t,x[s.axis]),j.obj.css(t,j[s.axis])}function i(){y?d.obj[0].ontouchstart=function(t){1===t.touches.length&&(n(t.touches[0]),t.stopPropagation())}:(j.obj.bind("mousedown",n),x.obj.bind("mouseup",r)),s.scroll&&window.addEventListener?(b[0].addEventListener("DOMMouseScroll",u,!1),b[0].addEventListener("mousewheel",u,!1)):s.scroll&&(b[0].onmousewheel=u)}function n(o){t("body").addClass("noSelect");var s=parseInt(j.obj.css(p),10);g.start=f?o.pageX:o.pageY,M.start="auto"==s?0:s,y?(document.ontouchmove=function(t){t.preventDefault(),r(t.touches[0])},document.ontouchend=c):(t(document).bind("mousemove",r),t(document).bind("mouseup",c),j.obj.bind("mouseup",c))}function u(o){if(m.ratio<1){var a=o||window.event,e=a.wheelDelta?a.wheelDelta/120:-a.detail/3;w-=e*s.wheel,w=Math.min(m[s.axis]-d[s.axis],Math.max(0,w)),j.obj.css(p,w/h.ratio),m.obj.css(p,-w),(s.lockscroll||w!==m[s.axis]-d[s.axis]&&0!==w)&&(a=t.event.fix(a),a.preventDefault())}}function r(t){m.ratio<1&&(M.now=s.invertscroll&&y?Math.min(x[s.axis]-j[s.axis],Math.max(0,M.start+(g.start-(f?t.pageX:t.pageY)))):Math.min(x[s.axis]-j[s.axis],Math.max(0,M.start+((f?t.pageX:t.pageY)-g.start))),w=M.now*h.ratio,m.obj.css(p,-w),j.obj.css(p,M.now))}function c(){t("body").removeClass("noSelect"),t(document).unbind("mousemove",r),t(document).unbind("mouseup",c),j.obj.unbind("mouseup",c),document.ontouchmove=document.ontouchend=null}var l=this,b=o,d={obj:t(".viewport",o)},m={obj:t(".overview",o)},h={obj:t(".scrollbar",o)},x={obj:t(".track",h.obj)},j={obj:t(".thumb",h.obj)},f="x"===s.axis,p=f?"left":"top",v=f?"Width":"Height",w=0,M={start:0,now:0},g={},y="ontouchstart"in document.documentElement;return this.update=function(t){d[s.axis]=d.obj[0]["offset"+v],m[s.axis]=m.obj[0]["scroll"+v],m.ratio=d[s.axis]/m[s.axis],h.obj.toggleClass("disable",m.ratio>=1),x[s.axis]="auto"===s.size?d[s.axis]:s.size,j[s.axis]=Math.min(x[s.axis],Math.max(0,"auto"===s.sizethumb?x[s.axis]*m.ratio:s.sizethumb)),h.ratio="auto"===s.sizethumb?m[s.axis]/x[s.axis]:(m[s.axis]-d[s.axis])/(x[s.axis]-j[s.axis]),w="relative"===t&&m.ratio<=1?Math.min(m[s.axis]-d[s.axis],Math.max(0,w)):0,w="bottom"===t&&m.ratio<=1?m[s.axis]-d[s.axis]:isNaN(parseInt(t,10))?w:parseInt(t,10),e()},a()}t.tiny=t.tiny||{},t.tiny.scrollbar={options:{axis:"y",wheel:40,scroll:!0,lockscroll:!0,size:"auto",sizethumb:"auto",invertscroll:!1}},t.fn.tinyscrollbar=function(s){var a=t.extend({},t.tiny.scrollbar.options,s);return this.each(function(){t(this).data("tsb",new o(t(this),a))}),this},t.fn.tinyscrollbar_update=function(o){return t(this).data("tsb").update(o)}}(jQuery);