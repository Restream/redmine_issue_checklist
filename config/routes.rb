
 match 'checklist/done/:checklist_item_id', to: 'issue_checklists#done', via: [:get, :post]
 match 'checklist/delete/:checklist_item_id', to: 'issue_checklists#delete', via: [:get, :post]
