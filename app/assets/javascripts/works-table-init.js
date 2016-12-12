(function() {
	"use strict";
	function initPage() {
		$('.data-table.works-index').DataTable({
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
			"aoColumns": [
                {"bSortable": false},
				null,
				null,
				null,
				null,
                null,
				{"bSortable": false}
			],
            "aaSorting": [ [ 0, "desc" ], [ 1, "desc" ] ]
		});

	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
