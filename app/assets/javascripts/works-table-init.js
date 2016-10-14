(function() {
	"use strict";
	function initPage() {
		$('.data-table.works-index').DataTable({
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
