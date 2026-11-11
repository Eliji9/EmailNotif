@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Notificaciones contratos mixtos'
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Pais' ]
define root view entity ZC_TMM_NOT_CON_MIX
  provider contract transactional_query
  as projection on ZR_TMM_NOT_CON_MIX
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'PaisNombre' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CountryVH', element: 'Country' } }]
  key Pais,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      Correo,

      @Semantics.text: true
      _PaisTexto.CountryName as PaisNombre,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _PaisTexto
}
