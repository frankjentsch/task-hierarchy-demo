@EndUserText.label: 'Material'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['MaterialID']

define root view entity ZRAP_C_MATERIAL
  provider contract transactional_query
  as projection on ZRAP_I_MATERIAL
{
      @ObjectModel.text.element: ['MaterialID']
  key MaterialUUID,

      @ObjectModel.text.element: ['MaterialName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
      MaterialID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
      MaterialName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold : 0.7
      @Search.ranking : #LOW
      MaterialText1,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold : 0.7
      @Search.ranking : #LOW
      MaterialText2,

      //      @Search.defaultSearchElement: true
      //      @Search.fuzzinessThreshold : 0.7
      //      @Search.ranking : #LOW
      MaterialText3,

      //      @Search.defaultSearchElement: true
      //      @Search.fuzzinessThreshold : 0.7
      //      @Search.ranking : #LOW
      MaterialText4,

      LocalLastChangedAt
}
