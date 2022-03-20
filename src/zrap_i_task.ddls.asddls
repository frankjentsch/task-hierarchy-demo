@EndUserText.label: 'Task'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZRAP_I_TASK
  as select from zrap_task as Task

  composition [0..*] of ZRAP_I_TASK_REL      as _Relation

  association [0..*] to ZRAP_I_TASK_REL_TREE as _RelationTree on $projection.TaskUUID = _RelationTree.task_uuid
  association [0..1] to ZRAP_I_MATERIAL      as _Material     on $projection.MaterialUUID = _Material.MaterialUUID

{
  key task_uuid             as TaskUUID,

      task_id               as TaskID,
      task_name             as TaskName,

      @EndUserText.label: 'Is Main Task'
      is_main               as IsMain,

      @EndUserText.label: 'Material ID'
      material_uuid         as MaterialUUID,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      _Relation,
 
      @ObjectModel.filter.enabled: false
      _RelationTree,
      
      _Material
}
