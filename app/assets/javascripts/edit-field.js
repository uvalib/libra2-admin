(function() {
	"use strict";
	function initPage() {

		var workId;
		var field;
		var input;
		var key;
		var message;
		var dialog;

		function onError(jqXHR, textStatus, errorThrown) {
			var message = jqXHR.responseJSON ? jqXHR.responseJSON.error : jqXHR.responseText.substring(0, 60);
			message.text("Error \"" + errorThrown + "\" updating server: " + message);
			message.show();
		}

		function onSuccess() {
			field.text(input.val());
			dialog.dialog( "close" );
		}

		function submitChange() {
			message.hide();
			var data = {};
			data["work["+key+"]"] = input.val();
			$.ajax("/works/"+workId+".json", {
				method: "PATCH",
				data: data,
				success: onSuccess,
				error: onError
			});
		}

		function initDialog(selector, width, height) {
			var dlg = $(selector).dialog({
				autoOpen: false,
				height: height,
				width: width,
				modal: true,
				buttons: {
					Apply: submitChange,
					Cancel: function() {
						dialog.dialog("close");
					}
				},
				close: function() {
					dialog.find( "form" )[0].reset();
				}
			});

			dlg.find( "form" ).on( "submit", function( event ) {
				event.preventDefault();
				submitChange();
			});
			return dlg;
		}

		var dialogs = {
			"text": initDialog("#dialog-text-input", 350, 350),
			"textarea": initDialog("#dialog-textarea-input", 450, 700),
			"state": initDialog("#dialog-state-input", 350, 350),
			"period": initDialog("#dialog-period-input", 350, 350)
		};

		$("table.work .edit").on("click", function(ev) {
			ev.preventDefault();
			var button = $(this);
			workId = button.data("id");
			key = button.data("field");
			var labelText = button.data("label");
			var type = button.data("type");
			if (!type) type = "text";
			var parent = button.closest("tr");
			field = parent.find(".value");
			var val = field.text();

			var dlg = $("#dialog-" + type + "-input");
			var label = dlg.find('label[for="user-' + type + '-input"]');
			label.text(labelText);
			input = dlg.find("#user-" + type + "-input");
			input.val(val);
			message = dlg.find(".message");
			message.text("");
			message.hide();
			dialog = dialogs[type];
			dialog.find(".input-field").attr("name", key);
			dialog.dialog( "open" );
		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
