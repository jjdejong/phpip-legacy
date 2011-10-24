/*
$(document).keypress(function(e) { 
    //alert(e.keyCode);
    alert(e["which"]);
    //for (var key in e) { if(typeof e[key] != "function") { alert(key + ' = ' + e[key])  }}
    if (e.which == 13) { $('.save').click(); }    // enter (works as expected)
    if (e.which == 27) { $('.cancel').click(); }  // esc   (does not work)
});
*/

$(document).ready(function(){
	
    $("#disablewindow").hide();
    $("#popupdiv").hide();
    
    $(".navigation > li").click(function(){
    	$(location).attr("href", $(this).find('a').attr("href"));
    });

    $('.dialog-close').click(function(){
      $('.flake-dialog').css('display', 'none');
      $('#facade').css('display', 'none');
    });
/*
    $('#delete-matter').click(function(){
        var mid = $(this).attr('mid');
        $.ajax({
          url:'/matter/delete',
          type: 'POST',
          data: { matter_id: mid },
          success: function(data){
            if(data == "true"){
              $(location).attr("href", '/matter');
            }else{
              alert(data);
            }
          }
        });
    });
*/

/*    $('#show-containers').click(function(){
        $(location).attr('href', '/matter/index/filter/Ctnr/value/1');
    });

    $('#show-all').click(function(){
        $(location).attr('href', '/matter');
    }); */

/*
   $('#matter-search').change(function(){
      var ref = $('#matter-search').val();
      var url = '/matter/filter/Ref/'+ref;
      $(location).attr('href', url);
   });
*/
   $('#matter-search').keypress(function(event){
	var keycode = (event.keyCode ? event.keyCode : event.which);
 	if(keycode == '13'){
            var ref = $('#matter-search').val();
            var url = '/matter/filter/Ref/'+ref;
            $(location).attr('href', url);
	}
   });


   $('#matter-ref-search').click(function(){
      var ref = $('#matter-search').val();
      var url = '/matter/filter/Ref/'+ref;
      $(location).attr('href', url);
   });
   $('#clear-matter-filters').click(function(){
      $(location).attr('href', '/matter');
   });
   $('.matter-navigation').click(function(){
      var rid = $(this).attr('id');
      var url = '/matter/matter-nav/rid/'+rid;
      $(location).attr('href', url);
   });
});
