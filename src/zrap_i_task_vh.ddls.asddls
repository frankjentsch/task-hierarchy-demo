@EndUserText.label: 'Task'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true

define root view entity ZRAP_I_TASK_VH
  as select from zrap_task as Task

  association [0..1] to ZRAP_I_MATERIAL as _Material on $projection.MaterialUUID = _Material.MaterialUUID

{
      @ObjectModel.text.element: ['TaskID']
      @UI.hidden: true
  key task_uuid     as TaskUUID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.6
      task_id       as TaskID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.6
      task_name     as TaskName,

      @EndUserText.label: 'Is Main Task'
      is_main       as IsMain,

      @UI.hidden: true
      material_uuid as MaterialUUID,

      _Material.MaterialID,

      _Material.MaterialName
}
