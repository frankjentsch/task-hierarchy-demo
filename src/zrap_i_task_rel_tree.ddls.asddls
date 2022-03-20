@EndUserText.label: 'Task Relation Tree'

@UI: { headerInfo: { typeName: 'Technical View',
                     typeNamePlural: 'Technical View' } }

@ObjectModel.query.implementedBy : 'ABAP:ZCL_RAP_TASK_REL_TREE'
define custom entity ZRAP_I_TASK_REL_TREE
{
      @UI.facet        : [ { id:            'TaskRelationTree',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Tree List 3',
                     position:      10 } ]

      @UI              : { lineItem:       [ { position: 10, importance: #HIGH } ] ,
             identification: [ { position: 10 } ] }
      @EndUserText.label: 'Task UUID'
  key task_uuid        : zrap_task_uuid;
  
  key parent_task_uuid : zrap_task_uuid; // to be deleted

      @UI              : { lineItem:       [ { position: 20, importance: #HIGH } ] ,
             identification: [ { position: 20 } ] }
      @EndUserText.label: 'Task ID'
      task_id          : zrap_task_id;

      @UI              : { lineItem:       [ { position: 30, importance: #HIGH } ] ,
             identification: [ { position: 30 } ] }
      @EndUserText.label: 'Level'
      hierarchy_level  : abap.int4;

      @UI              : { lineItem:       [ { position: 40, importance: #HIGH } ] ,
             identification: [ { position: 40 } ] }
      @EndUserText.label: 'JSON'
      json_model       : abap.string(0);
}
