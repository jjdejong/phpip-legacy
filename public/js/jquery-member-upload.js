$(document).ready(function(){
    loadUrlSelect = "/contact/group/listall"; //note: Double Quotes are to convert event.target into string ;) JV 
    $('#popupdivcontent').load(loadUrlSelect);
    $("#disablewindow").show();
    $("#popupdivcancel").hide();
    $("#popupdiv").show();
});
 
