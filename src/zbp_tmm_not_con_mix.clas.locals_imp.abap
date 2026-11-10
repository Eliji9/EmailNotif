CLASS lhc_ParamPaisUsr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ParamPaisUsr RESULT result.

    METHODS validarCorreo FOR VALIDATE ON SAVE
      IMPORTING keys FOR ParamPaisUsr~validarCorreo.

    METHODS validarUsuario FOR VALIDATE ON SAVE
      IMPORTING keys FOR ParamPaisUsr~validarUsuario.

    METHODS validarPais FOR VALIDATE ON SAVE
      IMPORTING keys FOR ParamPaisUsr~validarPais.

ENDCLASS.

CLASS lhc_ParamPaisUsr IMPLEMENTATION.

  METHOD get_global_authorizations.
    result = VALUE #( %create      = if_abap_behv=>auth-allowed
                      %update      = if_abap_behv=>auth-allowed
                      %delete      = if_abap_behv=>auth-allowed
                      %action-Edit = if_abap_behv=>auth-allowed ).
  ENDMETHOD.

  METHOD validarUsuario.
    READ ENTITIES OF zr_tmm_not_con_mix IN LOCAL MODE
      ENTITY ParamPaisUsr
        FIELDS ( Usuario ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_registros).

    IF lt_registros IS INITIAL.
      RETURN.
    ENDIF.

    SELECT UserID
      FROM I_BusinessUserVH
      FOR ALL ENTRIES IN @lt_registros
      WHERE UserID = @lt_registros-Usuario
      INTO TABLE @DATA(lt_usuarios).

    LOOP AT lt_registros INTO DATA(ls_reg).

      " Limpia mensajes previos del área
      APPEND VALUE #( %tky        = ls_reg-%tky
                      %state_area = 'VALIDAR_USUARIO' ) TO reported-parampaisusr.

      IF ls_reg-Usuario IS INITIAL
         OR NOT line_exists( lt_usuarios[ UserID = ls_reg-Usuario ] ).

        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-parampaisusr.

        APPEND VALUE #( %tky             = ls_reg-%tky
                        %state_area      = 'VALIDAR_USUARIO'
                        %msg             = new_message_with_text(
                                             severity = if_abap_behv_message=>severity-error
                                             text     = COND #( WHEN ls_reg-Usuario IS INITIAL
                                                                THEN `El usuario es obligatorio`
                                                                ELSE |El usuario { ls_reg-Usuario } no existe| ) )
                        %element-Usuario = if_abap_behv=>mk-on ) TO reported-parampaisusr.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validarPais.
    READ ENTITIES OF zr_tmm_not_con_mix IN LOCAL MODE
      ENTITY ParamPaisUsr
        FIELDS ( Pais ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_registros).

    IF lt_registros IS INITIAL.
      RETURN.
    ENDIF.

    SELECT Country
      FROM I_Country
      FOR ALL ENTRIES IN @lt_registros
      WHERE Country = @lt_registros-Pais
      INTO TABLE @DATA(lt_paises).

    LOOP AT lt_registros INTO DATA(ls_reg).

      APPEND VALUE #( %tky        = ls_reg-%tky
                      %state_area = 'VALIDAR_PAIS' ) TO reported-parampaisusr.

      IF ls_reg-Pais IS INITIAL
         OR NOT line_exists( lt_paises[ Country = ls_reg-Pais ] ).

        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-parampaisusr.

        APPEND VALUE #( %tky          = ls_reg-%tky
                        %state_area   = 'VALIDAR_PAIS'
                        %msg          = new_message_with_text(
                                          severity = if_abap_behv_message=>severity-error
                                          text     = COND #( WHEN ls_reg-Pais IS INITIAL
                                                             THEN `El país es obligatorio`
                                                             ELSE |El país { ls_reg-Pais } no existe| ) )
                        %element-Pais = if_abap_behv=>mk-on ) TO reported-parampaisusr.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validarCorreo.
    READ ENTITIES OF zr_tmm_not_con_mix IN LOCAL MODE
      ENTITY ParamPaisUsr
        FIELDS ( Correo ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_registros).

    LOOP AT lt_registros INTO DATA(ls_reg).

      APPEND VALUE #( %tky        = ls_reg-%tky
                      %state_area = 'VALIDAR_CORREO' ) TO reported-parampaisusr.

      DATA(lv_correo) = condense( val = CONV string( ls_reg-Correo ) ).

      IF lv_correo IS INITIAL
         OR NOT matches( val  = lv_correo
                         pcre = `^[^@\s]+@[^@\s]+\.[^@\s]+$` ).

        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-parampaisusr.

        APPEND VALUE #( %tky            = ls_reg-%tky
                        %state_area     = 'VALIDAR_CORREO'
                        %msg            = new_message_with_text(
                                            severity = if_abap_behv_message=>severity-error
                                            text     = COND #( WHEN lv_correo IS INITIAL
                                                               THEN `El correo es obligatorio`
                                                               ELSE |El correo { lv_correo } no es válido| ) )
                        %element-Correo = if_abap_behv=>mk-on ) TO reported-parampaisusr.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
