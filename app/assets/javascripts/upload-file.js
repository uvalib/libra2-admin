(function() {
	"use strict";
	function initPage() {

		var message;
		var dialog;
		var fileInput = $("#file-to-upload");
        var work_id = $( "#work_id" ).text( );

		function uploadProgress(evt) {
			var m;
			if (evt.lengthComputable) {
				m = Math.round(evt.loaded * 100 / evt.total) + "%";
			} else {
				m = 'Not computable';
			}
			console.log("percent complete: " + m);
		}

		function uploadComplete(evt) {
			console.log("complete: " + evt.currentTarget.status + ", response: " + this.response );
            var jobj = JSON.parse( this.response )
            if( jobj.status == 200 ) {
                $.ajax("/work_files.json", {
                    type: "POST",
                    data: { work: work_id, file: jobj.id },
                    success: onSuccess,
                    error: onError
                });
            }
		}

		function uploadFailed() {
			// Evidently, there is no way to tell what the error was. It is not reported from the browser.
			message.text("There was a CORS error in connecting to the server. The file was not uploaded.");
			message.show();
		}

		function onError(jqXHR, textStatus, errorThrown) {
			var msg = jqXHR.responseJSON ? jqXHR.responseJSON.error : jqXHR.responseText.substring(0, 60);
			message.text("Error \"" + errorThrown + "\" updating server: " + msg);
			message.show();
		}

		function onSuccess() {
			dialog.dialog( "close" );
		}

		function submitChange() {
			// upload the file to Libra2 using CORS.
			// When the upload is successful, then do another ajax to our server.

			message.hide();
			var url = fileInput.data("url");

			var data = new FormData();

            // only support a single file in the form
            data.append('file', fileInput[0].files[0]);
			//$.each(fileInput[0].files, function(i, file) {
			//	data.append('file-'+i, file);
			//});

			var xhr = new XMLHttpRequest();

			xhr.upload.addEventListener("progress", uploadProgress, false);
			xhr.addEventListener("load", uploadComplete, false);
			xhr.addEventListener("error", uploadFailed, false);

			xhr.open('POST', url, true); //MUST BE LAST LINE BEFORE YOU SEND
			xhr.send(data);
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
			message = dlg.find(".message");
			message.text("");
			message.hide();
			return dlg;
		}

		dialog = initDialog("#dialog-file-input", 550, 250);
		$(".file-upload").on("click", function(ev) {
			ev.preventDefault();

			dialog.dialog( "open" );

		});
	}

	document.addEventListener("turbolinks:load", function() {
		initPage();
	});
})();
