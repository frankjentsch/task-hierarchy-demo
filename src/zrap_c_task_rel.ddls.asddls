@EndUserText.label: 'Task Relation'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRAP_C_TASK_REL
  as projection on ZRAP_I_TASK_REL
{
  key TaskRelUUID,

      ParentUUID,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['ParentTaskID']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZRAP_I_TASK_VH', element: 'TaskUUID' } }]
      @UI.textArrangement: #TEXT_ONLY
      ParentTaskUUID,
      _ParentTask.TaskID as ParentTaskID,

      LocalLastChangedAt,

      _Task : redirected to parent ZRAP_C_TASK
}
