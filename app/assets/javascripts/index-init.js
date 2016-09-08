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
			]

		});

	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
