(function() {
	"use strict";
	function initPage() {

		var workId;
		var field;
		var input;
		var key;
		var message;
		var dialog;
		var append;
        var split;

		function onError(jqXHR, textStatus, errorThrown) {
			var msg = jqXHR.responseJSON ? jqXHR.responseJSON.error : jqXHR.responseText.substring(0, 60);
			message.text("Error \"" + errorThrown + "\" updating server: " + msg);
			message.show();
		}

		function onSuccess() {
			var val = input.val();
			if( append === true ) {
                val = field.html() + "<br>---<br>" + val;
                field.html(val);
            } else if( split === true ) {
				field.text(val.split(",").join(","));
			} else if (key === 'advisers') {
				val = window.getAdviserDataFormatted();
				field.html(val);
			} else {
                field.text(val);
            }
			dialog.dialog( "close" );
		}

		function submitChange() {
			message.hide();
			var data = {};
			if (key === 'advisers')
				data["work["+key+"]"] = window.getAdviserData();
			else
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
					Cancel: function() {
						dialog.dialog("close");
					},
                    Apply: submitChange
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
			"text": initDialog("#dialog-text-input", 450, 350),
			"textarea": initDialog("#dialog-textarea-input", 450, 650),
			"advisers": initDialog("#dialog-advisers-input", 550, 650),
			"combo": initDialog("#dialog-combo-input", 650, 300)
		};

		$("table.work .edit, table.work .add").on("click", function(ev) {

			ev.preventDefault();
			var button = $(this);
			workId = button.data("id");
			key = button.data("field");
            var helpText = button.data("help");
            var labelText = button.data("label");
			var type = button.data("type");
			if (!type) type = "text";

			var isDate = false;
			if (type === 'date') {
				type = "text";
				isDate = true;
			}

			// special case where we append new data instead of replacing it
			append = false;
			if (type === 'textarea-append') {
				type = "textarea";
				append = true;
			}

			// special case where we split into fields and submit as an array
            split = false;
            if (type === 'textarea-split') {
                type = "textarea";
                split = true;
            }

			var parent = button.closest("tr");
			// Get the existing value for this field. If it is a simple field, then the value is what is visible. If the field needs
			// formatting, the raw value is placed in a hidden input, so use that instead.
			field = parent.find(".value");
			var val = field.text();
			var hiddenField = field.find('input[type="hidden"]');
			if (hiddenField.length > 0)
				val = hiddenField.val();

			var dlg = $("#dialog-" + type + "-input");

            var label = dlg.find('label[for="user-' + type + '-input"]');
			label.text(labelText);

            var help = dlg.find('.field_help');
            help.text( helpText );

			input = dlg.find("#user-" + type + "-input");
			if (type === "combo") {
				// remove the old options and replace them with the new options.
				input.html("");
				var options = window.selectOptions[key];
				if (options) {
					for (var i = 0; i < options.length; i++) {
						var option = options[i];
						if( Object.prototype.toString.call(option) === '[object String]' ) {
							input.append("<option>" + option + "</option>");
						} else {
							input.append('<option value="' + option.value + '">' + option.text + "</option>");
						}
					}
				}
			}
			if (type === 'advisers') {
				window.setInitialAdviserData(input, val);
			} else if (!append)
				input.val(val);

			message = dlg.find(".message");
			message.text("");
			message.hide();
			dialog = dialogs[type];
			dialog.find(".input-field").attr("name", key);
			if (isDate) {
				$( '#user-text-input' ).datepicker({
					dateFormat: "yy-mm-dd"
				});
			}
			dialog.dialog( "open" );
		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
