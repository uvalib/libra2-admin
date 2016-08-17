(function() {
	"use strict";
	function initPage() {

		$("#show-work").on("click", function(ev) {
			ev.preventDefault();
			var button = $(this);
			var input = button.data("id");
			var el = $('input[name='+input+']');
			button.attr("disabled", "disabled");
			var workId = el.val();
			window.location = "/works/" + workId;
		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
