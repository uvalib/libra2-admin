(function() {
	"use strict";
	function initPage() {
		$('.data-table.five-col').DataTable({
			"aoColumns": [
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
