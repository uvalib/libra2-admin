(function() {
	"use strict";
	function initPage() {
		$('.data-table.six-col').DataTable({
			"aoColumns": [
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
