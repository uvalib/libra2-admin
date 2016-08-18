(function() {
	"use strict";
	function initPage() {

		var workId;
		var field;
		var input;
		var key;
		var message;

		function onError(jqXHR, textStatus, errorThrown) {
			message.text("Error updating server: " + jqXHR.responseJSON.error);
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

		var dialog = $( "#dialog-text-input" ).dialog({
			autoOpen: false,
			height: 350,
			width: 350,
			modal: true,
			buttons: {
				Apply: submitChange,
				Cancel: function() {
					dialog.dialog( "close" );
				}
			},
			close: function() {
				form[ 0 ].reset();
			}
		});

		var form = dialog.find( "form" ).on( "submit", function( event ) {
			event.preventDefault();
			submitChange();
		});

		$("table.work .edit").on("click", function(ev) {
			ev.preventDefault();
			var button = $(this);
			workId = button.data("id");
			key = button.data("field");
			var labelText = button.data("label");
			var parent = button.closest("tr");
			field = parent.find(".value");
			var val = field.text();

			var dlg = $("#dialog-text-input");
			var label = dlg.find('label[for="user-text-input"]');
			label.text(labelText);
			input = dlg.find("#user-text-input");
			input.val(val);
			message = dlg.find(".message");
			message.text("");
			message.hide();
			dialog.dialog( "open" );
		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
