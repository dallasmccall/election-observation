

function toggleMenu(){
	toggle_visibility("navbarMenu");
	$.mobile.fixedToolbars.show(true);
}

function hideMenu(){
	hide_visibility("navbarMenu");
	$.mobile.fixedToolbars.show(true);
}

function getElementsByClassName(node,classname) {
  if (node.getElementsByClassName) { // use native implementation if available
    return node.getElementsByClassName(classname);
  } else {
    return (function getElementsByClass(searchClass,node) {
        if ( node == null )
          node = document;
        var classElements = [],
            els = node.getElementsByTagName("*"),
            elsLen = els.length,
            pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)"), i, j;

        for (i = 0, j = 0; i < elsLen; i++) {
          if ( pattern.test(els[i].className) ) {
              classElements[j] = els[i];
              j++;
          }
        }
        return classElements;
    })(classname, node);
  }
}


function toggle_visibility(className) {
	   var elements = getElementsByClassName(document, className),
	       n = elements.length;
	   for (var i = 0; i < n; i++) {
	     var e = elements[i];

	     if(e.style.display == 'block') {
	       e.style.display = 'none';
	     } else {
	       e.style.display = 'block';
	     }
	  }
	}


function hide_visibility(className) {
	   var elements = getElementsByClassName(document, className),
	       n = elements.length;
	   for (var i = 0; i < n; i++) {
	     var e = elements[i];
	       e.style.display = 'none';	  }
	}


$( document ).live( 'pagebeforechange',function(event, ui){
	hide_visibility("navbarMenu");
	$.mobile.fixedToolbars.show(true);
});




function selectButtonDescription(id){
	$("#" + id).show().siblings().hide();
}

function hideButtonDescriptions(){
	$("#buttonDescriptionMenu").show().siblings().hide();
	$("#buttonDescriptionButtonMenu").addClass("ui-btn-active");
}


/*
  $(document).ready(function() {
		hide_visibility("navbarMenu");
		$.mobile.fixedToolbars.show(true);
  });
*/
