public with sharing class MetadataTriggerHandler extends TriggerHandler {
 
    override public void run(){
        if(!validateRun()) {
            return;
          }
      
          addToLoopCount();
          
           String objType = getSObjectType();
           List<Meta__mdt> metaTriggers=[
                SELECT 
                    Class__c 
                FROM 
                    Meta__mdt
                WHERE 
                    Object__c =: objType 
                AND 
                    isActive__c = TRUE
                ORDER BY 
                    Executing_Order__c

            ];

            for(Meta__mdt mdt :metaTriggers){
                TriggerHandler handler;
                try {
                    handler=(TriggerHandler) Type.forName(mdt.Class__c).newInstance();
                } catch (Exception ex) {
                    continue;
                }
                switch on this.context {
                    when BEFORE_INSERT {
                        handler.beforeInsert();
                    }
                    when BEFORE_UPDATE {
                        handler.beforeUpdate();
                    }
                    when BEFORE_DELETE {
                        handler.beforeDelete();
                    }
                    when AFTER_INSERT {
                        handler.afterInsert();
                    }
                    when AFTER_UPDATE {
                        handler.afterUpdate();
                    }
                    when AFTER_DELETE {
                        handler.afterDelete();
                    }
                    when AFTER_UNDELETE {
                        handler.afterUndelete();
                    }
                 }
                
            }
        
    }

    private String  getSObjectType(){
        if(Trigger.new != null){
            return Trigger.new[0].getSObjectType().getDescribe().getName();
        }else{
            return Trigger.old[0].getSObjectType().getDescribe().getName();
        } 

    }

}