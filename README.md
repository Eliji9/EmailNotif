# EmailNotif – Notificaciones contratos mixtos: País / Correo (RAP / ABAP Cloud)

Código fuente en `src/`.

Orden de creación en ADT:

1. Tabla `ZTMM_NOT_CON_MIX`
2. CDS raíz `ZR_TMM_NOT_CON_MIX`
3. CDS proyección `ZC_TMM_NOT_CON_MIX`
4. Metadata Extension `ZC_TMM_NOT_CON_MIX`
5. BDEF `ZR_TMM_NOT_CON_MIX` → quick fix crea la tabla draft `ZTMM_NOT_CON_MID` y la clase `ZBP_TMM_NOT_CON_MIX`
6. BDEF proyección `ZC_TMM_NOT_CON_MIX`
7. Service Definition `ZUI_TMM_NOT_CON_MIX_O4`
8. Service Binding `ZUI_TMM_NOT_CON_MIX_O4` (OData V4 – UI) → Publish → Preview

Ayudas de búsqueda (released, C1):
- País → `I_CountryVH` (Country), texto con `I_CountryText`


## Service Binding `ZUI_TMM_NOT_CON_MIX_O4`

- Binding Type: **OData V4 – UI**
- Service Definition: `ZUI_TMM_NOT_CON_MIX_O4`
- Activar → Publish → Preview sobre `NotConMix`

## Notas

- **Duplicados**: la clave es solo el País (un correo por país), así que el framework rechaza un país repetido al activar el draft.
- **Clase de entrega `#A`**: el dato se mantiene directo en cada ambiente (sin transporte). Si lo necesitas como customizing transportable (`#C`), hay que agregar el manejo de transporte con `I_Technical_Transport` / Business Configuration.
- **Autorización**: está abierta (`#NOT_REQUIRED` y auth global permitida). Para producción conviene un DCL y un objeto de autorización propio.

## Envío de correo MIGO

`src/migo/envio_correo_migo.abap`: reemplaza la llamada a `ZCL_MIG_OC_CONTRATOS_MIXTOS=>EMAIL_MIGO` por `ZCL_MAN_CON_MIX_DATA=>SEND_EMAIL`, con remitente por país desde `ZTMM_NOT_CON_MIX`.
