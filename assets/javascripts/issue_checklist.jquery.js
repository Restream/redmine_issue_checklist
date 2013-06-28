window.onload = function() {
	$('#checklist_form_items').sortable()
};

var Redmine = Redmine || {};

$.fn.issue_check_list = function(element, input, button) {

}

Redmine.IssueChecklist = jQuery.klass({
	init: function(element, input, button) {
		this.element   = $('#'+element);
		this.input     = $('#'+input);
		this.button    = $('#'+button);
		this.checklist = {};
		this.button.click($.proxy(this.readChecklist, this));
		this.input.keypress($.proxy(this.onKeyPress, this));
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
		if ($.isEmptyObject(сhecklistItem)) return;

		isDone = isDone || false;


		var hidden = $(document.createElement('input'))
        hidden.attr({'type': 'hidden', 'name': 'check_list_items[][subject]', 'value':$.trim(сhecklistItem)});
		var button = $(document.createElement('span'))
        button.attr({'href': '#', 'class': 'delete icon icon-del' });
		var checkbox = $(document.createElement('input'))
        checkbox.attr({'type': 'checkbox', 'name': 'check_list_items[][is_done]', 'value': '1', 'id': 'checklist_item_checkbox_'+id});
		var label  = $(document.createElement('span'))
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
			}
			else {
				label.removeClass('is-done-checklist-item');
			}

		}, this));

	},

	addChecklist: function(checklist) {
		for (var i = 0; i < checklist.length; i++) {
			this.addChecklistItem(checklist[i]['subject'], checklist[i]['is_done'], checklist[i]['id']);
		}
	},

	getChecklist: function() {
		return this.checklist;
	}

});

function observeIssueChecklistField(element, input, add_button) {
	issueChecklist = new Redmine.IssueChecklist(element, input, add_button);
}

function createIssueChecklist(checkList) {
	issueChecklist.addChecklist(checkList);
}

function checklist_item_done(elem,url,id){
    $.ajax({url: url,
        dataType: 'script',
        data: 'checklist_item_' + id})
    var checkbox = $('#checklist_item_checkbox_'+id)
    if (checkbox.is(':checked'))
        checkbox.removeAttr('checked')
    else
        checkbox.attr('checked', true)

}