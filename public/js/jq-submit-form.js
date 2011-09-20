$(document).ready(function(){
    $("form").submit(function(){
         //for (var key in this) { if(typeof this[key] != "function") { alert(key + ' = ' + this[key])  }}
         //alert(this["action"]);
         bodyContent = $.ajax({
            url: (this["action"]),
            global: false,
            type: "POST",
            data: ($(this).serialize()),
            dataType: "html",
            async:false,
            success: function(msg){
               //alert(msg);
               var contentDiv = document.getElementById("popupdivcontent");
               contentDiv.innerHTML = msg;
               $("#popupdiv").delay(1000).hide("scale","slow");
               setTimeout(function(){ $("#disablewindow").delay(1000).hide("highlight","slow");  },500);
               location.reload();
            }
        }).responseText;
        return false;
    });
});
