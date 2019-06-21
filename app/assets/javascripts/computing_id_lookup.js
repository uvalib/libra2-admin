(function() {
  "use strict";
  function initPage() {

    function lookup(self) {
      var index = self.data("index");
      var id = self.val();

      function onSuccess(resp) {
        //console.log(resp);
        var outerForm = self.closest(".person-input");
        var elFirstName = outerForm.find(".contributor_first_name");
        var elLastName = outerForm.find(".contributor_last_name");
        var elDepartment = outerForm.find(".contributor_department");
        var elInstitution = outerForm.find(".contributor_institution");
        if (resp.cid) {
          // The computing id was found if the object returned is not empty.
          elFirstName.val(resp.first_name);
          elLastName.val(resp.last_name);
          elDepartment.val(resp.department[0]);
          elInstitution.val(resp.institution);
        } else {
          elFirstName.val("");
          elLastName.val("");
          elDepartment.val("");
          elInstitution.val("");
        }
      }

      $.ajax("/works/computing_id.json", {
        data: { id: id, index: index },
        success: onSuccess
      });
    }

    var body = $("body");
    body.on("keyup", ".contributor_computing_id", function() {
      var self = $(this);
      lookup(self);
    });

    body.on("change", ".contributor_computing_id", function() {
      var self = $(this);
      lookup(self);
    });
  }

  document.addEventListener("turbolinks:load", function() {
    initPage();
  });
})();
