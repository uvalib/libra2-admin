(function() {
	"use strict";
	function initPage() {

		var body = $("body");
		body.on("click", ".remove-adviser", function(ev) {
			ev.preventDefault();
			var self = $(this);
			var parent = self.closest(".input-group");
			parent.remove();
		});

		body.on("click", ".add-adviser", function(ev) {
			ev.preventDefault();
			var self = $(this);
			var adviserTemplate = $(".advisor-template");
			var block = adviserTemplate.html();
			block = block.replace("$id$","").replace("$first_name$","").replace("$last_name$","").replace("$department$","").replace("$institution$","");
			var target = $("#user-advisors-input");
			target.append(block);

			var parent = self.closest(".input-group");
			parent.remove();
		});

		window.setInitialAdviserData = function(input, val) {
			var adviserTemplate = $(".advisor-template");
			var advisers = val.split("\t");
			var html = "";
			for (var i = 0; i < advisers.length; i++) {
				var adviser = advisers[i].split("\n");
				var block = adviserTemplate.html();
				block = block.replace("$id$",adviser[0]).replace("$first_name$",adviser[1]).replace("$last_name$",adviser[2]).replace("$department$",adviser[3]).replace("$institution$",adviser[4]);
				html += block;
			}
			input.html(html);
		};

		window.getAdviserData = function() {
			var advisers = $("#user-advisors-input").find(".person-input");
			var data = [];
			for (var i = 0; i < advisers.length; i++) {
				var adviser = $(advisers[i]);
				var item = [];
				item.push(adviser.find(".contributor_computing_id").val());
				item.push(adviser.find(".contributor_first_name").val());
				item.push(adviser.find(".contributor_last_name").val());
				item.push(adviser.find(".contributor_department").val());
				item.push(adviser.find(".contributor_institution").val());
				data.push(item.join("\n"));
			}
			return data.join("\t");
		};

		window.getAdviserDataFormatted = function() {
			var html = [];
			var advisers = window.getAdviserData().split("\t");
			for (var i = 0; i < advisers.length; i++) {
				var adviser = advisers[i].split("\n");
				html.push("<span class='adviser-label'>Computing ID:</span>" + adviser[0] + "<br><span class='adviser-label'>First Name:</span>" + adviser[1] + "<br><span class='adviser-label'>Last Name:</span>" + adviser[2] + "<br><span class='adviser-label'>Department:</span>" + adviser[3] + "<br><span class='adviser-label'>Institution:</span>" + adviser[4]);
			}
			return html.join( '<br>---<br>');
		};
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
