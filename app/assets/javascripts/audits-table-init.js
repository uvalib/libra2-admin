(function() {
	"use strict";
	function initPage() {
		$('.data-table.audits-index').DataTable({
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
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
