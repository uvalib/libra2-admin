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
    var file_id;

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
      } else if (key === 'advisors') {
        val = window.getAdviserDataFormatted();
        field.html(val);
      } else if (key === 'file_label') {
        var fields = $(field.context.parentElement).find('.file_label')
        fields.siblings('div.file_label').html("Display: "+val)
        fields.siblings('input').val(val)
      } else {
        field.text(val);
      }
      dialog.dialog( "close" );
    }

    function submitChange() {
      message.hide();
      var data = {};
      var path = "/works/"+workId+".json";
      if (key === 'advisors') {
        data["work[" + key + "]"] = window.getAdviserData();
      } else if (key === 'file_label') {
        data["work_file"] = {label: input.val(), work_id: workId};
        // File updates have a different path
        path = "/work_files/" + file_id + ".json"
      } else {
        data["work[" + key + "]"] = input.val();
      }

      $.ajax(path, {
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
      "advisors": initDialog("#dialog-advisors-input", 550, 650),
      "dropdown": initDialog("#dialog-dropdown-input", 650, 300),
      "combo": initDialog("#dialog-combo-input", 650, 300),
      "date": initDialog("#dialog-date-input", 450, 350)
    };

    $("table.work .edit, table.work .add").on("click", function(ev) {

      ev.preventDefault();
      var button = $(this);
      workId = button.data("id");
      file_id = button.data("fileId");
      key = button.data("field");
      var helpText = button.data("help");
      var labelText = button.data("label");
      var type = button.data("type");
      if (!type) type = "text";

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
      var val = field.html();
      var hiddenField = button.siblings('input[type="hidden"]');
      if (hiddenField.length > 0) {
        val = hiddenField.val();
      }

      var dlg = $("#dialog-" + type + "-input");

      var label = dlg.find('label[for="user-' + type + '-input"]');
      label.text(labelText);

      var help = dlg.find('.field_help');
      help.text( helpText );

      input = dlg.find("#user-" + type + "-input");
      if( (type === "dropdown") || (type === "combo" ) ) {
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

      if( type === "combo" ) {
        input = dlg.find("#user-" + type + "-edit");
        input.val( val );
      }

      if (type === 'advisors') {
        window.setInitialAdviserData(input, val);
      } else if (!append)
        input.val(val);

      message = dlg.find(".message");
      message.text("");
      message.hide();
      dialog = dialogs[type];
      dialog.find(".input-field").attr("name", key);
      if( type === 'date' ) {
        $( '#user-date-input' ).datepicker({
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
