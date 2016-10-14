(function() {
	"use strict";
	function initPage() {

        $('.data-table.exports-index').DataTable({
            "aoColumns": [
                {"bSortable": false},
                {"bSortable": false},
                {"bSortable": false},
                {"bSortable": false}
            ],
            paging: false,
            searching: false,
            info: false
        });

        // enable the date picker...
        $( '.date-picker' ).datepicker({
            dateFormat: "yy-mm-dd"
        });

        $("#work-export").on("click", function(ev) {

            ev.preventDefault();
            //alert( "click" );
        });
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
