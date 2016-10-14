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

        // export handlers
        $("#work-export").on("click", function( ev ) {
            ev.preventDefault();
            var start_date = getDateOrToday( "work-export-start-date" );
            var end_date = getDateOrToday( "work-export-start-date");
            getExports( "works", start_date, end_date );
        });
        $("#fileset-export").on("click", function( ev ) {
            ev.preventDefault();
            var start_date = getDateOrToday( "fileset-export-start-date" );
            var end_date = getDateOrToday( "fileset-export-start-date");
            getExports( "filesets", start_date, end_date );
        });
        $("#audit-export").on("click", function( ev ) {
            ev.preventDefault();
            var start_date = getDateOrToday( "audit-export-start-date" );
            var end_date = getDateOrToday( "audit-export-start-date");
            getExports( "audit", start_date, end_date );
        });
	}

	function getExports( export_type, start_date, end_date ) {
        var url = $("#api-endpoint" ).val() + "/" + export_type + ".csv?auth=" + $("#api-token" ).val();
        window.location = url;
    }

    function getDateOrToday( field_id ) {
       return "2016-01-01"
    }

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
