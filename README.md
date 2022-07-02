# Custom-metadata-driven-trigger-framework-task
## The metadata trigger is expending Kevin O'hara trigger framework -->  https://github.com/kevinohara80/sfdc-trigger-framework.There are some changes in the TriggerHandler --> https://www.diffchecker.com/h89HDA4o
## There is only one implemented trigger related to the task :

As a Sales User I want to have task automatically created to prepare contract when opportunity is closed won.
Acceptance Criteria:
- New Task is created for owner of Opportunity when status changes to Closed Won
- Task is connected to Opportunity from which it was triggered from

Execute using:
- Flow (bonus)
- Trigger
    - TriggerHandler framework
    - Custom Metadata Driven framework
