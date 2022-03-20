@EndUserText.label: 'Task Relation'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZRAP_I_TASK_REL
  as select from zrap_task_rel as TaskRelation

  association        to parent ZRAP_I_TASK as _Task       on $projection.ParentUUID = _Task.TaskUUID
  association [0..1] to ZRAP_I_TASK        as _ParentTask on $projection.ParentTaskUUID = _ParentTask.TaskUUID

{
  key task_rel_uuid         as TaskRelUUID,

      @EndUserText.label: 'Task ID'
      parent_uuid           as ParentUUID,

      @EndUserText.label: 'Parent Task ID'
      parent_task_uuid      as ParentTaskUUID,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Task,
      _ParentTask
}
