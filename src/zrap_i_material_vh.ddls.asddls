@EndUserText.label: 'Material'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true

define root view entity ZRAP_I_MATERIAL_VH
  as select from zrap_material as Material
{
      @ObjectModel.text.element: ['MaterialID']
      @UI.hidden: true
  key material_uuid as MaterialUUID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      material_id   as MaterialID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      material_name as MaterialName
}
