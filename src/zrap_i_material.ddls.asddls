@EndUserText.label: 'Material'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZRAP_I_MATERIAL
  as select from zrap_material as Material
{
  key material_uuid         as MaterialUUID,

      material_id           as MaterialID,
      material_name         as MaterialName,

      @EndUserText.label: 'Text 1 (CHAR)'
      material_text1        as MaterialText1,

      @EndUserText.label: 'Text 2 (SSTRING)'
      material_text2        as MaterialText2,

      @EndUserText.label: 'Text 3 (STRING)'
      material_text3        as MaterialText3,

      @EndUserText.label: 'Text 4 (STRING)'
      material_text4        as MaterialText4,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
 
      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
