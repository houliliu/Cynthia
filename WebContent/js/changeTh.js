//2011-1-21
//www.cnblogs.com/xxfss2

 var lineMove = false;
 var currTh = null;
 $(document).ready(function() {//function(event) { $(this).css({ 'cursor': '/web/Page/frameset/images/splith.cur' }

	$("body").bind("selectstart", function() { return !lineMove; });
	
    $("body").append("<div id=\"line\" style=\"width:1px;height:900px; z-index:999999; border-left:1px solid #00000000; position:absolute;display:none\" ></div> ");
	 
	/*
    $("body").bind("mousemove", function(event) {
         if (lineMove == true) {
             $("#line").css({ "left": event.clientX }).show();
         }
    });
	*/
	 
	$("th").live("mousemove",function(event){
	
		if (lineMove == true) {
             var pos = currTh.offset();
             var index = currTh.prevAll().length;
             currTh.width(event.clientX - pos.left);
             var top = pos.top;
             var height = currTh.parent().parent().height();
             $("#line").css({ "height": height, "top": top,"left":event.clientX,"display":"" });
			 $("#main-grid-header").find("colgroup col:eq('"+index+"')").width(event.clientX - pos.left);
			 $("#main-grid-content").find("colgroup col:eq('"+index+"')").width(event.clientX - pos.left);
        }else{
			var th = $(this);
			if (th.prevAll().length <= 1 || th.nextAll().length < 1) {
				 return;
			}
			var left = th.offset().left;
		
			$.each($("#main-grid-header").find("thead th"),function(index,node){
				$(node).css({'border-right':''});
			});
			
			th.css({'border-right':'1px solid #CCCCCC'});	
			
			if (event.clientX - left < 8 || (th.width() - (event.clientX - left)) < 8) {
				th.css({ 'cursor': 'w-resize' , 'border-right':'1px solid #CCCCCC'});
			}else if(lineMove) {
				th.css({ 'cursor': 'w-resize'});
			}else {
				th.css({ 'cursor': 'default' });
			}
		}
    }).live("mouseout",function(event){
		$.each($("#main-grid-header").find("thead th"),function(index,node){
				$(node).css({'border-right':''});
		});	
    }).live("mousedown",function(event){

        var th = $(this);
        if (th.prevAll().length <= 1 || th.nextAll().length < 1) {
             return;
        }
        var pos = th.offset();
        if (event.clientX - pos.left < 4 || (th.width() - (event.clientX - pos.left)) < 4) {

             var height = th.parent().parent().height();
             var top = pos.top;
             $("#line").css({ "height": height, "top": top,"left":event.clientX,"display":"" });
             lineMove = true;
             if (event.clientX - pos.left < th.width() / 2) {
                 currTh = th.prev();
             }
             else {
                 currTh = th;
             }
         }
    });
	
     $("body").bind("mouseup", function(event) {

        if (lineMove == true) {
            $("#line").hide();
		     lineMove = false;		 
			 
			 var pos = currTh.offset();
		     var index = currTh.prevAll().length;
		     currTh.width(event.clientX - pos.left);
		     $("#main-grid-header").find("colgroup col:eq('"+index+"')").width(event.clientX - pos.left);
			 $("#main-grid-content").find("colgroup col:eq('"+index+"')").width(event.clientX - pos.left);
			 onWindowResize();
        }
     });
     
 });