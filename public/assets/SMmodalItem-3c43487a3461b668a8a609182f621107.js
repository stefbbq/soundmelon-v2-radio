SMmodalItem=function(n,t){function e(){i()}function i(){s.click(o),$(document).mouseup(function(n){u(n)})}function o(){if(r())l.hide(),f();else{if(l.show(),a(),console.log(r()),c())return!1;l.find(".spinner").show()}}function c(){return!l.find(".main-content .content").is(":empty")}function u(n){l.is(n.target)||0!==l.has(n.target).length||(l.hide(),f())}function a(){g=!0}function f(){g=!1}function r(){return g}var d,s,l,h,m,g;return h=t,g=!1,d=this,s=n,m=s.attr("data-modal"),l=$("#"+m),{enable:e,activate:a,deactivate:f,index:h}};