@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Notificaciones contratos mixtos'
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Usuario', 'Pais' ]
define root view entity ZC_TMM_NOT_CON_MIX
  provider contract transactional_query
  as projection on ZR_TMM_NOT_CON_MIX
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: [ 'UsuarioNombre' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BusinessUserVH', element: 'UserID' } }]
  key Usuario,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'PaisNombre' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CountryVH', element: 'Country' } }]
  key Pais,

      @Semantics.text: true
      _Usuario.PersonFullName as UsuarioNombre,

      @Semantics.text: true
      _PaisTexto.CountryName  as PaisNombre,

      Correo,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Usuario,
      _PaisTexto
}
