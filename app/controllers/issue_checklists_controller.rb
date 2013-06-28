class IssueChecklistsController < ApplicationController
  unloadable
  
  before_filter :find_checklist_item
  
  def done
    (render_403; return false) unless User.current.allowed_to?(:done_checklists, @checklist_item.issue.project)

    old_checklist_item = @checklist_item.dup
    @checklist_item.is_done = !@checklist_item.is_done
    
    if @checklist_item.save
      if RedmineIssueChecklist.settings[:save_log] && old_checklist_item.info != @checklist_item.info
        journal = Journal.new(:journalized => @checklist_item.issue, :user => User.current)
        journal.details << JournalDetail.new(:property => 'attr',
                                                      :prop_key => 'checklist',
                                                      # :old_value => old_checklist_item.info,
                                                      :value => @checklist_item.info)
        journal.save
      end
      
      if (Setting.issue_done_ratio == "issue_field") && RedmineIssueChecklist.settings[:issue_done_ratio]
        done_checklist = @checklist_item.issue.checklist.map{|c| c.is_done ? 1 : 0}
        @checklist_item.issue.done_ratio = (done_checklist.count(1) * 10) / done_checklist.count * 10
        @checklist_item.issue.save
      end
    end
    respond_to do |format|
      format.js
      format.html {redirect_to :back }
    end
    
  end     
  
  def delete
    (render_403; return false) unless User.current.allowed_to?(:edit_checklists, @checklist_item.issue.project)
    
    @checklist_item.delete
    respond_to do |format|
      format.js do 
        render :update do |page|  
            page["checklist_item_#{@checklist_item.id}"].visual_effect :fade   
        end
      end     
      format.html {redirect_to :back }
    end
    
  end     
  
  private
  
  def find_checklist_item
    @checklist_item = IssueChecklist.find(params[:checklist_item_id]) 
    @project = @checklist_item.issue.project
  end
  
  
end
