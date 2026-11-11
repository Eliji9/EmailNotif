@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Notificaciones contratos mixtos'
define root view entity ZR_TMM_NOT_CON_MIX
  as select from ztmm_not_con_mix

  association [0..1] to I_CountryText as _PaisTexto
    on  $projection.Pais    = _PaisTexto.Country
    and _PaisTexto.Language = $session.system_language
{
  key pais                  as Pais,
  key correo                as Correo,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _PaisTexto
}
