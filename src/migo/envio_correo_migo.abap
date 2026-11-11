*----------------------------------------------------------------------*
* Envío de correo MIGO para OC de contratos mixtos
* Reemplaza la llamada anterior:
*   zcl_mig_oc_contratos_mixtos=>email_migo( i_migo    = e_mblnr
*                                             i_ebeln   = ls_ekko-purchaseorder
*                                             i_lifnr   = ls_ekko-supplier
*                                             i_name    = ls_ekko-supplierfullname
*                                             it_correos = lt_correos
*                                             it_error  = et_return ).
*
* Requisitos:
*  - ZCL_MAN_CON_MIX_DATA=>SEND_EMAIL y =>GET_SENDER_EMAIL públicos y estáticos
*  - lv_pais: país de la OC (remitente parametrizado en ZTMM_NOT_CON_MIX)
*  - COMMIT WORK: quitar si este punto ya corre después del commit de la MIGO
*    o dentro de una BAdI donde no se permite commit
*----------------------------------------------------------------------*

          " Destinatarios: de tt_correos a tabla de strings
          DATA(lt_destinatarios) = VALUE string_table(
            FOR ls_correo IN lt_correos WHERE ( emailaddress IS NOT INITIAL )
            ( CONV string( ls_correo-emailaddress ) ) ).

          " Asunto (igual que EMAIL_MIGO)
          DATA(lv_asunto) = COND so_obj_des(
            WHEN e_mblnr IS NOT INITIAL
            THEN |Migo creada: { e_mblnr }, OC: { ls_ekko-purchaseorder }|
            ELSE |Error Migo para OC: { ls_ekko-purchaseorder }| ) ##NO_TEXT.

          " Cuerpo (igual que EMAIL_MIGO)
          DATA(lt_cuerpo) = COND bcsy_text(
            WHEN et_return IS INITIAL
            THEN VALUE #(
                   ( line = |Se ha creado un migo: { e_mblnr }| )
                   ( line = |OC: { ls_ekko-purchaseorder }| )
                   ( line = |Proveedor: { ls_ekko-supplier } - { ls_ekko-supplierfullname }| ) )
            ELSE VALUE #(
                   ( line = |Error al crear migo (OC { ls_ekko-purchaseorder })| )
                   ( line = `` )
                   ( LINES OF VALUE bcsy_text( FOR ls_err IN et_return
                                               ( line = ls_err-message ) ) ) ) ) ##NO_TEXT.

          IF lt_destinatarios IS NOT INITIAL.
            TRY.
                zcl_man_con_mix_data=>send_email(
                  it_recipients   = lt_destinatarios
                  iv_subject      = lv_asunto
                  it_body         = lt_cuerpo
                  iv_sender_email = zcl_man_con_mix_data=>get_sender_email( iv_country = lv_pais ) ).
                COMMIT WORK.
              CATCH cx_bcs.
                " Error en envío de correo
            ENDTRY.
          ENDIF.
