public with sharing class ClosedOpportunityTriggerHandler extends TriggerHandler {

    private List<Opportunity> OpportunitiesAfterUpdateList;
    private Map<id,Opportunity> OpportunitiesBeforeUpdateMap;
    private List<Task> tasksToInsert=new List<Task>();

    public ClosedOpportunityTriggerHandler(){
        this.OpportunitiesAfterUpdateList=(List<Opportunity>)Trigger.new;
        this.OpportunitiesBeforeUpdateMap=(Map<id,Opportunity>)Trigger.oldMap;
    }

    public override void afterInsert(){
        insertTasksWhenStageClosedWon(OpportunitiesAfterUpdateList, OpportunitiesBeforeUpdateMap);
    }

    public override void afterUpdate(){
        insertTasksWhenStageClosedWon(OpportunitiesAfterUpdateList, OpportunitiesBeforeUpdateMap);
    }

    private void insertTasksWhenStageClosedWon(List<Opportunity> updatedOpportunities ,Map<id,Opportunity> oldOpportunities ){
       for(Opportunity opp:updatedOpportunities){
           if(opp.StageName=='Closed Won' && oldOpportunities.get(opp.id).StageName!='Closed Won') {
            tasksToInsert.add(new Task(
                Subject='Create new contract '+ opp.Name + ' Created from Custom Metadata Trigger Framework',
                WhatId=opp.id,
                OwnerId=opp.OwnerId
            ));
        }
    }
    insert tasksToInsert;
    }
}