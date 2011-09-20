/*!
 * jQuery Selectlist Plugin
 * version 1.0.0
 * @author rajasekhar@prtoch.com
 */

; (function($) {
	$.fn.selectList = function(listArr, selectedArr, inputName) {
		return this.each(function() {
			$(this).css("width", "97%");
			$(this).css("-moz-border-radius", "5px");
			$(this).css("-webkit-border-radius", "5px");
			$(this).css("padding", "5px");
			$(this).css("background-color", "#B5D9E5");
			$(this).css("-moz-box-shadow", "2px 2px 1px #888");
            $(this).css("-webkit-box-shadow", "2px 2px 1px #888");
            $(this).css("box-shadow", "2px 2px 1px #888");
            $(this).css("overflow", "hidden");
//			var selectedArr = [];
		/*	$.each(selectedArr, function(i,value){
				listArr = jQuery.grep(listArry, function(item){
					return item != value;
				});
			}); */
			
			$(this).append('<div style="display:block; background-color:#1E4262; -moz-border-radius:5px;-webkit-border-radius:5px; padding:5px; color:#ffffff; height:20px; text-align:center; vertical-align:center; font-wieght:bold; font-size:13px; font-family:lucida grande,tahoma,verdana,arial,sans-serif"> <span align="center">Select Groups</span> </div>');
			
			$(this).append('<div id="selected-list" style="border:1px solid #B5D9E5; border-style:inset; -moz-border-radius:5px;-webkit-border-radius:5px; padding:5px; overflow: auto; background-color:white; margin-top:5px;"></div>');
			$(this).append('<div id="unselected-list" style="border:1px solid #B5D9E5; border-style:inset; -moz-border-radius:5px;-webkit-border-radius:5px; padding:5px; overflow: auto; background-color:white; margin-top:3px;"></div>');
			
			//$(this).append('<div id="selec"></div>')
			if(listArr.length > 1){
				$('#unselected-list').append('<label id="select-all" style="display:block; background:#1E4262; color:#FFF; -moz-border-radius:3px;-webkit-border-radius:3px;"><input type="checkbox" value="" name="select-all" /><span>All</span></label>');
			}
			$.each(listArr, function(i, item){
				if( item ){
					$('#unselected-list').append('<label class="unselected-item" id="unselected-item-'+i+'" style="display:block"><input type="checkbox" value="" /><span>'+item+'</span></label>');
					if($.inArray(''+i, selectedArr) > -1 )
						$('#unselected-item-'+i).hide();
				}
			});
			$.each(listArr, function(i, item){
				if( item ){
					$('#selected-list').append('<label class="selected-item" id="selected-item-'+i+'" style="display:block">[x]&nbsp;<span>'+item+'</span></label>');
					if($.inArray(''+i, selectedArr) < 0 )
						$('#selected-item-'+i).hide();
				}
			});
//			$('.selected-item').hide();
			$(this).append('<input type="hidden" value="" id="selected-input" name="'+inputName+'" />');
			$('#selected-input').val(selectedArr);
			
			$('#select-all').click(function(){
				if($('input:[name=select-all]').is(':checked')){
					$.each(listArr, function(id, item){
						if($.inArray(id, selectedArr) < 0)
						    selectedArr.push(id);
						$('#selected-item-'+id).css('display', 'block');
						//$('#selected-item-'+id).show();
						$('#unselected-item-'+id).hide();
						$('#selected-input').val(selectedArr);
						//$('input', this).removeAttr('checked');
					});
				}else{
					$.each(listArr, function(id, item){
						selectedArr = jQuery.grep(selectedArr, function(value){
							return value != id;
						});
						//$('#unselected-item-'+id).show();
						$('#unselected-item-'+id).css('display', 'block');
						$('#selected-item-'+id).hide();
					});
				//	$('input[name='+inputName+']').val('');
				}
			});
			
			$('.unselected-item').click(function(){
				var id = $(this).attr('id').split('-');
				if($.inArray(id[2], selectedArr) < 0)
				    selectedArr.push(id[2]);
				$('#selected-item-'+id[2]).show();
				$(this).hide();
				$('#selected-input').val(selectedArr);
				$('input', this).removeAttr('checked');
			});
			$('.selected-item').click(function(){
				var id = $(this).attr('id').split('-');
				selectedArr = jQuery.grep(selectedArr, function(value){
					return value != id[2];
				});
				$('#unselected-item-'+id[2]).show();
				$(this).hide();
				$('input[name='+inputName+']').val(selectedArr);
				$('input:[name=select-all]').attr('checked', false);
			});
		});
		
		$('.selectcheck').click(function(){
			prevenDefault();
			$(this).removeAttr('checked');
		});
	};
})(jQuery);