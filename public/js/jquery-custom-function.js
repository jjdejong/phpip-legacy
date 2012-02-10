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

   $('#matter-search').keypress(function(event){
	var keycode = (event.keyCode ? event.keyCode : event.which);
 	if(keycode == '13'){
        var term = $('#matter-search').val();
        var option = $('#matter-option').val();
        var url = '/matter/filter/'+option+'/'+term;            
        $(location).attr('href', url);
	}
   });


   $('#matter-ref-search').click(function(){
      var term = $('#matter-search').val();
      var option = $('#matter-option').val();
      var url = '/matter/filter/'+option+'/'+term;
      $(location).attr('href', url);
   });
   /*$('#clear-matter-filters').click(function(){
      $(location).attr('href', '/matter');
   });*/
   $('.matter-navigation').click(function(){
      var rid = $(this).attr('id');
      var url = '/matter/matter-nav/rid/'+rid;
      $(location).attr('href', url);
   });
});
