(function() {
  "use strict";
  function initPage() {

    var body = $("body");
    body.on("click", ".remove-advisor", function(ev) {
      ev.preventDefault();
      var self = $(this);
      var parent = self.closest(".input-group");
      parent.remove();
    });

    body.on("click", ".add-advisor", function(ev) {
      ev.preventDefault();
      var self = $(this);
      var advisorTemplate = $(".advisor-template");
      var block = advisorTemplate.html();
      block = block.replace("$id$","").replace("$first_name$","").replace("$last_name$","").replace("$department$","").replace("$institution$","");
      var target = $("#user-advisors-input");
      target.append(block);

      var parent = self.closest(".input-group");
      parent.remove();
    });

    window.setInitialAdvisorData = function(input, val) {
      var advisorTemplate = $(".advisor-template");
      var advisors = val.split("\t");
      var html = "";
      for (var i = 0; i < advisors.length; i++) {
        var advisor = advisors[i].split("\n");
        if( advisor.length == 6 ) {
          var block = advisorTemplate.html();
          block = block.replace("$id$", advisor[1]).replace("$first_name$", advisor[2]).replace("$last_name$", advisor[3]).replace("$department$", advisor[4]).replace("$institution$", advisor[5]);
          html += block;
        }
      }
      input.html(html);
    };

    window.getAdvisorData = function() {
      var advisors = $("#user-advisors-input").find(".person-input");
      var data = [];
      for (var i = 0; i < advisors.length; i++) {
        var advisor = $(advisors[i]);
        var item = [];
        item.push( i );
        item.push(advisor.find(".contributor_computing_id").val());
        item.push(advisor.find(".contributor_first_name").val());
        item.push(advisor.find(".contributor_last_name").val());
        item.push(advisor.find(".contributor_department").val());
        item.push(advisor.find(".contributor_institution").val());
        data.push(item.join("\n"));
      }
      return data.join("\t");
    };

    window.getAdvisorDataFormatted = function() {
      var html = [];
      var advisors = window.getAdvisorData().split("\t");
      for (var i = 0; i < advisors.length; i++) {
        var advisor = advisors[i].split("\n");
        if( advisor.length != 6  ){
          return '';
        }
        html.push("<span class='advisor-label'>Computing ID:</span>" + advisor[1] +
                  "<br><span class='advisor-label'>First Name:</span>" + advisor[2] +
                  "<br><span class='advisor-label'>Last Name:</span>" + advisor[3] +
                  "<br><span class='advisor-label'>Department:</span>" + advisor[4] +
                  "<br><span class='advisor-label'>Institution:</span>" + advisor[5]);
      }

      var hidden = "<input value=\"" + advisors.join("\t") + "\" type=\"hidden\", class=\"inner-value\">";
      return hidden + html.join( '<br>---<br>');
    };
  }

  document.addEventListener("turbolinks:load", function() {
    initPage();
  });
})();
