CLASS zcl_rap_task_rel_tree DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    TYPES BEGIN OF ty_s_data.
    TYPES   task_uuid        TYPE zrap_task_uuid.
    TYPES   task_id          TYPE zrap_task_id.
    TYPES   hierarchy_level  TYPE i.
    TYPES   json_model       TYPE string.
    TYPES END OF ty_s_data.

    TYPES ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    METHODS get_main_task
      IMPORTING iv_task_uuid             TYPE zrap_task_uuid
      RETURNING VALUE(rv_main_task_uuid) TYPE zrap_task_uuid.

    METHODS build_hierarchy
      IMPORTING VALUE(iv_task_uuid)       TYPE zrap_task_uuid
                VALUE(iv_hierarchy_level) TYPE i
      CHANGING  ct_data                   TYPE ty_t_data
                cv_json_model             TYPE string.

ENDCLASS.


CLASS zcl_rap_task_rel_tree IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    ASSERT io_request->get_entity_id( ) = 'ZRAP_I_TASK_REL_TREE'.

    "get current TASK_UUID
    DATA lv_task_uuid TYPE zrap_task_uuid.

    TRY.
        DATA(lt_filter_ranges) = io_request->get_filter( )->get_as_ranges( ).

      CATCH cx_rap_query_filter_no_range.
        ASSERT 1 = 2.
    ENDTRY.

    READ TABLE lt_filter_ranges ASSIGNING FIELD-SYMBOL(<ls_filter_range>)
               WITH KEY name = 'TASK_UUID'.
    IF sy-subrc = 0.
      READ TABLE <ls_filter_range>-range ASSIGNING FIELD-SYMBOL(<ls_range>)
                 WITH KEY sign   = 'I'
                          option = 'EQ'.
      IF sy-subrc = 0.
        lv_task_uuid = <ls_range>-low.
      ENDIF.
    ENDIF.

    "get main task
    DATA(lv_main_task_uuid) = get_main_task( lv_task_uuid ).

    "build hierarchy (recursive)
    DATA lt_data       TYPE ty_t_data.
    DATA lv_json_model TYPE string.

    build_hierarchy(
      EXPORTING
        iv_task_uuid       = lv_main_task_uuid
        iv_hierarchy_level = 0
      CHANGING
        ct_data            = lt_data
        cv_json_model      = lv_json_model
    ).

    DATA(lv_paging_offset) = io_request->get_paging( )->get_offset( ).
    DATA(lv_paging_page_size) = io_request->get_paging( )->get_page_size( ).

    IF lv_paging_offset > 0.
      DELETE lt_data FROM 1 TO lv_paging_offset.
    ENDIF.

    IF lv_paging_page_size > 0.
      DELETE lt_data FROM lv_paging_page_size + 1.
    ENDIF.

    "workaround: transfer calculated JSON in first row :)
    READ TABLE lt_data INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_data>).
    IF sy-subrc = 0.
      <ls_data>-json_model = `[ ` && lv_json_model && ` ]`.
    ENDIF.

    TRY.
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.

        IF io_request->is_data_requested( ).
          io_response->set_data( it_data = lt_data ).
        ENDIF.

      CATCH cx_rap_query_response_set_twic.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.

  METHOD get_main_task.

    CHECK iv_task_uuid IS NOT INITIAL.

    "existence check
    SELECT SINGLE FROM zrap_task FIELDS is_main WHERE task_uuid = @iv_task_uuid INTO @DATA(lv_is_main).
    IF sy-subrc <> 0.
      "task does not exist
      RETURN.
    ENDIF.

    IF lv_is_main = abap_true.
      "main task already found
      rv_main_task_uuid = iv_task_uuid.
    ELSE.
      DATA(lv_task_uuid) = iv_task_uuid.
      DO.
        SELECT SINGLE FROM zrap_task_rel FIELDS parent_task_uuid WHERE parent_uuid = @lv_task_uuid INTO @DATA(lv_parent_task_uuid). "#EC WARNOK
        IF sy-subrc = 0.
          lv_task_uuid = lv_parent_task_uuid.
        ELSE.
          "main task found
          rv_main_task_uuid = lv_task_uuid.
          RETURN.
        ENDIF.
      ENDDO.
    ENDIF.

  ENDMETHOD.

  METHOD build_hierarchy.

    "TODO: cycles are not detected yet

    CHECK iv_task_uuid IS NOT INITIAL.

    "process task
    SELECT SINGLE FROM zrap_task FIELDS task_id WHERE task_uuid = @iv_task_uuid INTO @DATA(lv_task_id).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND VALUE #( task_uuid       = iv_task_uuid
                    task_id         = lv_task_id
                    hierarchy_level = iv_hierarchy_level ) TO ct_data.

    cv_json_model = cv_json_model && `{ "text": "` && lv_task_id && `", "ref": "sap-icon://create"` ##NO_TEXT.

    "process sub tasks
    SELECT FROM zrap_task_rel AS r INNER JOIN zrap_task AS t ON r~parent_uuid = t~task_uuid FIELDS r~parent_uuid WHERE r~parent_task_uuid = @iv_task_uuid ORDER BY t~task_id INTO TABLE @DATA(lt_sub_task_uuid).

    IF lt_sub_task_uuid IS NOT INITIAL.
      cv_json_model = cv_json_model && `, "nodes": [` ##NO_TEXT.

      LOOP AT lt_sub_task_uuid INTO DATA(lv_sub_task_uuid).
        DATA(lv_tabix) = sy-tabix.

        build_hierarchy(
          EXPORTING
            iv_task_uuid       = lv_sub_task_uuid-parent_uuid
            iv_hierarchy_level = iv_hierarchy_level + 1
          CHANGING
            ct_data            = ct_data
            cv_json_model      = cv_json_model
        ).

        IF lv_tabix < lines( lt_sub_task_uuid ).
          cv_json_model = cv_json_model && `, `.
        ENDIF.
      ENDLOOP.

      cv_json_model = cv_json_model && ` ]`.
    ELSE.

    ENDIF.

    cv_json_model = cv_json_model && ` }`.

  ENDMETHOD.

ENDCLASS.
