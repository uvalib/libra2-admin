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
            var include_pending = $("#include_pending").is(':checked');
            var start_date = getDateOrBeginingOfTime( "work-export-start-date" );
            var end_date = getDateOrToday( "work-export-end-date");
            var constraints = "create_date=" + start_date + ":" + end_date;
            if( include_pending === false ) {
                constraints = constraints + "&status=submitted";
            }
            getExports( "works/search", constraints );
        });

        $("#fileset-export").on("click", function( ev ) {
            ev.preventDefault();
            var start_date = getDateOrBeginingOfTime( "fileset-export-start-date" );
            var end_date = getDateOrToday( "fileset-export-end-date");
            var constraints = "create_date=" + start_date + ":" + end_date;
            getExports( "filesets", constraints );
        });

        $("#audit-export").on("click", function( ev ) {
            ev.preventDefault();
            var start_date = getDateOrBeginingOfTime( "audit-export-start-date" );
            var end_date = getDateOrToday( "audit-export-end-date");
            var constraints = "create_date=" + start_date + ":" + end_date;
            getExports( "audit", constraints );
        });
	}

	function getExports( export_type, constraints ) {
        var url = $("#api-endpoint" ).val() + "/" + export_type + ".csv?auth=" + $("#api-token" ).val() +
            "&" + constraints;
        console.log( "export URL: " + url );
        window.location = url;
    }

    function getDateOrToday( field_id ) {
        var date = $( "#" + field_id ).val( );
        if ( date.length === 0 ) {
            date = new Date( ).toISOString( ).slice( 0, 10 );
        }
        return date
    }

    function getDateOrBeginingOfTime( field_id ) {
        var date = $( "#" + field_id ).val( );
        if ( date.length === 0 ) {
            date = '2000-01-01';
        }
        return date
    }

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
