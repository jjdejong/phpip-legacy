$(document).ready(function(){
    var listArray = [];

    $("#edit-list-button").hide();
    $("div.listrow-tab-selected").hide();
    $("div.listrow-tab-select").click(function(){
        var selectedGroupID = $(this).attr('id').split("-");
        $("#list-" + selectedGroupID[1]).hide("slow");
        $("#list-2-" + selectedGroupID[1]).show("slow");
        listArray.push(selectedGroupID[1]);
    });

    if(typeof groupid == "undefined") {
    } else {
        $("#list-2-" + groupid).show("slow");
    }

    $("div.listrow-tab-selected").click(function(){
        var selectedGroupID = $(this).attr('id').split("-");
        $("#list-2-" + selectedGroupID[2]).hide("slow");
        $("#list-" + selectedGroupID[2]).show("slow");
        listArray = jQuery.grep(listArray, function(value) {
            return value != selectedGroupID[2];
        });
    });

    $("#next-list-button").click(function(){
        contentDiv = $("#selected-group-list");
        contentDivList = $("#group-list");
        //contentDiv.html();
        document.getElementById("group-list").innerHTML = contentDiv.html();
        //contentDivList.innerHTML = contentDiv.html();
        document.getElementById("selected-group-list").innerHTML = "";
        $("#disablewindow").hide('slow');
        $("#popupdiv").hide('slow');
        $("#edit-list-button").show('slow');
        //$("#group-array").value = listArray;
        $("#group-array").val(listArray);
    });

    $("#edit-list-button").click(function(){
        //alert("hi");
        //contentDiv = $("#selected-group-list");
        //contentDivList = $("#group-list");
        //contentDiv.html();
        //document.getElementById("selected-group-list").innerHTML = contentDivList.html();
        //contentDivList.innerHTML = contentDiv.html();
        document.getElementById("group-list").innerHTML = "";
        $("#disablewindow").show('slow');
        $("#popupdiv").show('slow');
        $("#edit-list-button").hide('slow');
        loadUrlSelect = "/contact/group/listall"; //note: Double Quotes are to convert event.target into string ;) JV 
        $('#popupdivcontent').load(loadUrlSelect);
        //$("#group-array").value = listArray;
        //$("#group-array").val(listArray);
    });

    //$("#member-add-form").submit(function(event){
        //alert("hi");
        //alert(listArray);
        //$("#group-array").value = listArray;
        //alert($("#group-array").value);
        //event.preventDefault();
        
    //});

});
