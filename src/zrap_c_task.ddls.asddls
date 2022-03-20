@EndUserText.label: 'Task'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TaskID']

define root view entity ZRAP_C_TASK
  provider contract transactional_query
  as projection on ZRAP_I_TASK
{
      @ObjectModel.text.element: ['TaskID']
  key TaskUUID,

      @ObjectModel.text.element: ['TaskName']
      @Search.defaultSearchElement: true
      TaskID,

      @Search.defaultSearchElement: true
      TaskName,

      IsMain,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['MaterialID']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZRAP_I_MATERIAL_VH', element: 'MaterialUUID' } }]
      @UI.textArrangement: #TEXT_ONLY
      MaterialUUID,

      _Material.MaterialID as MaterialID,

      LocalLastChangedAt,

      _Relation : redirected to composition child ZRAP_C_TASK_REL,
      _RelationTree
}
