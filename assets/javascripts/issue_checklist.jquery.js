window.onload = function() {
  $('#checklist_form_items').sortable();
};

var Redmine = Redmine || {};

$.fn.issue_check_list = function(element, input, button, fileInput) {};

Redmine.IssueChecklist = jQuery.klass({
  init: function(element, input, button, fileInput) {
    this.element   = $('#' + element);
    this.input     = $('#' + input);
    this.button    = $('#' + button);
    this.fileInput = $('#' + fileInput);
    this.checklist = {};
    this.button.click($.proxy(this.readChecklist, this));
    this.fileInput.on('change', $.proxy(this.onFileInputChange, this));
    this.input.keypress($.proxy(this.onKeyPress, this));
    this.input.on('dragover', $.proxy(this.onDragOver, this));
    this.input.on('drop', $.proxy(this.onDrop, this));
  },

  readChecklist: function(event) {
    this.addChecklistItem(this.input.val());
    this.input.val('');
    event.preventDefault();
  },

  onKeyPress: function(event) {
    if (13 == event.keyCode) {
      this.readChecklist(event);
      event.preventDefault();
    }
  },

  addChecklistItem: function(сhecklistItem, isDone, id) {
    if ($.isEmptyObject(сhecklistItem)) {
      return;
    }

    isDone = isDone || false;

    var hidden = $(document.createElement('input'));
    hidden.attr({'type': 'hidden', 'name': 'check_list_items[][subject]', 'value':$.trim(сhecklistItem)});
    var button = $(document.createElement('span'));
    button.attr({'href': '#', 'class': 'delete icon icon-del' });
    var checkbox = $(document.createElement('input'));
    checkbox.attr({'type': 'checkbox', 'name': 'check_list_items[][is_done]', 'value': '1', 'id': 'checklist_item_checkbox_'+id});
    var label  = $(document.createElement('span'));
    label.attr({ 'class': 'checklist-item' }).append(hidden).append(checkbox).append($.trim(сhecklistItem)).append(button);

    if (isDone == true) {
      checkbox.attr('checked', 'checked');
      label.addClass('is-done-checklist-item');
    }

    this.checklist[сhecklistItem] = 1;
    this.element.append(label);

    button.click($.proxy(function(){
      this.checklist[сhecklistItem] = null;
      label.remove();
      // Event.stop(event);
    }, this));

    checkbox.click($.proxy(function(){
      if (checkbox.is(':checked')) {
        label.addClass('is-done-checklist-item');
      } else {
        label.removeClass('is-done-checklist-item');
      };
    }, this));

  },

  addChecklist: function(checklist) {
    for (var i = 0; i < checklist.length; i++) {
      this.addChecklistItem(checklist[i]['subject'], checklist[i]['is_done'], checklist[i]['id']);
    }
  },

  getChecklist: function() {
    return this.checklist;
  },

  onDragOver: function(event) {
    event.stopPropagation();
    event.preventDefault();
    event.originalEvent.dataTransfer.dropEffect = 'copy';
  },

  onDrop: function(event) {
    var file = event.dataTransfer.files[0];

    event.stopPropagation();
    event.preventDefault();

    if (file) {
      this.parseMultiLineFile(file);
    }
  },

  onFileInputChange: function(event) {
    var file = event.target.files[0];
    if (file) {
      this.parseMultiLineFile(file);
    }
  },

  parseMultiLineFile: function (file) {
    if (!(window.File && window.FileReader) || !file ||
        !file.type.match('text.*')) {
      return false;
    }

    var _this = this;
    var reader = new window.FileReader();

    reader.onload = function(event) {
      var result = event.target.result;
      var lines = result.split("\n").filter(function(el) {
        return !$.isEmptyObject(el);
      });

      if (lines.length && window.confirm('Import ' + lines.length + ' checklist items?')) {
        lines.forEach(function(line) {
          _this.addChecklistItem(line);
        });
      };
    };

    reader.readAsText(file);
  }
});

function observeIssueChecklistField(element, input, add_button, fileInput) {
  issueChecklist = new Redmine.IssueChecklist(element, input,
                                              add_button, fileInput);
}

function createIssueChecklist(checkList) {
  issueChecklist.addChecklist(checkList);
}

function checklist_item_done(elem,url,id){
  $.ajax({url: url,
          dataType: 'script',
          data: 'checklist_item_' + id});
  var checkbox = $('#checklist_item_checkbox_'+id);
  if (checkbox.is(':checked')) {
    checkbox.removeAttr('checked');
  } else {
    checkbox.attr('checked', true);
  }
}
