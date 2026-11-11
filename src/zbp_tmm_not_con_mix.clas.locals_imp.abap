CLASS lhc_NotConMix DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR NotConMix RESULT result.

    METHODS validarPais FOR VALIDATE ON SAVE
      IMPORTING keys FOR NotConMix~validarPais.

    METHODS validarCorreo FOR VALIDATE ON SAVE
      IMPORTING keys FOR NotConMix~validarCorreo.

ENDCLASS.

CLASS lhc_NotConMix IMPLEMENTATION.

  METHOD get_global_authorizations.
    result = VALUE #( %create      = if_abap_behv=>auth-allowed
                      %update      = if_abap_behv=>auth-allowed
                      %delete      = if_abap_behv=>auth-allowed
                      %action-Edit = if_abap_behv=>auth-allowed ).
  ENDMETHOD.

  METHOD validarPais.
    READ ENTITIES OF zr_tmm_not_con_mix IN LOCAL MODE
      ENTITY NotConMix
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
                      %state_area = 'VALIDAR_PAIS' ) TO reported-notconmix.

      IF ls_reg-Pais IS INITIAL
         OR NOT line_exists( lt_paises[ Country = ls_reg-Pais ] ).

        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-notconmix.

        APPEND VALUE #( %tky          = ls_reg-%tky
                        %state_area   = 'VALIDAR_PAIS'
                        %msg          = new_message_with_text(
                                          severity = if_abap_behv_message=>severity-error
                                          text     = COND #( WHEN ls_reg-Pais IS INITIAL
                                                             THEN `El país es obligatorio`
                                                             ELSE |El país { ls_reg-Pais } no existe| ) )
                        %element-Pais = if_abap_behv=>mk-on ) TO reported-notconmix.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validarCorreo.
    READ ENTITIES OF zr_tmm_not_con_mix IN LOCAL MODE
      ENTITY NotConMix
        FIELDS ( Correo ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_registros).

    LOOP AT lt_registros INTO DATA(ls_reg).

      APPEND VALUE #( %tky        = ls_reg-%tky
                      %state_area = 'VALIDAR_CORREO' ) TO reported-notconmix.

      DATA(lv_correo) = condense( val = CONV string( ls_reg-Correo ) ).

      IF lv_correo IS INITIAL
         OR NOT matches( val  = lv_correo
                         pcre = `^[^@\s]+@[^@\s]+\.[^@\s]+$` ).

        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-notconmix.

        APPEND VALUE #( %tky            = ls_reg-%tky
                        %state_area     = 'VALIDAR_CORREO'
                        %msg            = new_message_with_text(
                                            severity = if_abap_behv_message=>severity-error
                                            text     = COND #( WHEN lv_correo IS INITIAL
                                                               THEN `El correo es obligatorio`
                                                               ELSE |El correo { lv_correo } no es válido| ) )
                        %element-Correo = if_abap_behv=>mk-on ) TO reported-notconmix.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
