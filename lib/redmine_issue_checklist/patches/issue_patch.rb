require_dependency 'issue'  

module RedmineIssueChecklist
  module Patches    
    
    module IssuePatch
      
      def self.included(base) # :nodoc: 
        base.send(:include, InstanceMethods)
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          
          alias_method_chain :copy_from, :checklist
          has_many :checklist, :class_name => "IssueChecklist", :dependent => :destroy
        end  

      end  

      module InstanceMethods
        def copy_from_with_checklist(arg, options={})
          copy_from_without_checklist(arg, options)
          issue = arg.is_a?(Issue) ? arg : Issue.visible.find(arg)
          self.checklist = issue.checklist.map{|cl| cl.dup }
          self.checklist.each do |object|
            object.is_done = nil
          end
          self
        end
      end      
        
    end
    
  end
end  


unless Issue.included_modules.include?(RedmineIssueChecklist::Patches::IssuePatch)
  Issue.send(:include, RedmineIssueChecklist::Patches::IssuePatch)
end
