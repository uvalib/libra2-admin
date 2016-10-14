(function() {
	"use strict";
	function initPage() {
		$('.data-table.audits-index').DataTable({
			"aoColumns": [
				null,
				null,
				null,
				null
			],
            "aaSorting": [ [ 0, "desc" ] ]
		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
