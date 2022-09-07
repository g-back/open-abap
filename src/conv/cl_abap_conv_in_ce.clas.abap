CLASS cl_abap_conv_in_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding    TYPE abap_encoding DEFAULT 'UTF-8'
          input       TYPE xstring OPTIONAL
          replacement TYPE char1 DEFAULT '#'
          ignore_cerr TYPE abap_bool DEFAULT abap_false
          endian      TYPE char1 OPTIONAL
        RETURNING
          VALUE(ret)  TYPE REF TO cl_abap_conv_in_ce.

    CLASS-METHODS
      uccpi
        IMPORTING
          value TYPE i
        RETURNING
          VALUE(ret) TYPE string.

    TYPES ty_char2 TYPE c LENGTH 2.
    CLASS-METHODS uccp
      IMPORTING
        uccp TYPE simple
      RETURNING
        VALUE(char) TYPE ty_char2.

    METHODS
      convert
        IMPORTING
          input TYPE xstring
          n     TYPE i OPTIONAL
        EXPORTING
          data  TYPE string.
    METHODS
      read
        IMPORTING
          n     TYPE i OPTIONAL
        EXPORTING
          data  TYPE string.
  PRIVATE SECTION.
    DATA mv_input TYPE xstring.
    DATA mv_js_encoding TYPE string.
ENDCLASS.

CLASS cl_abap_conv_in_ce IMPLEMENTATION.
  METHOD create.
    ASSERT replacement = '#'. " todo
    ASSERT ignore_cerr IS INITIAL. " todo
    ASSERT endian IS INITIAL. " todo

    CREATE OBJECT ret.

    CASE encoding.
      WHEN 'UTF-8'.
        ret->mv_js_encoding = 'utf8'.
      WHEN '4103'.
        ret->mv_js_encoding = 'utf16le'.
      WHEN OTHERS.
        ASSERT 1 = 'not supported'.
    ENDCASE.

    ret->mv_input = input.
  ENDMETHOD.

  METHOD uccp.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD uccpi.
    DATA lv_hex TYPE x LENGTH 2.
    DATA lo_in TYPE REF TO cl_abap_conv_in_ce.

    lv_hex(1) = value MOD 255.
    lv_hex+1(1) = value DIV 255.

    lo_in = create( encoding = '4103' ).

    lo_in->convert(
      EXPORTING
        input = lv_hex
      IMPORTING
        data  = ret ).
  ENDMETHOD.

  METHOD convert.
    IF input IS INITIAL.
      RETURN.
    ENDIF.
    ASSERT mv_js_encoding IS NOT INITIAL.
    WRITE '@KERNEL let result = Buffer.from(input.get(), "hex").toString(this.mv_js_encoding.get());'.
    WRITE '@KERNEL data.set(result);'.
  ENDMETHOD.

  METHOD read.
    convert(
      EXPORTING
        input = mv_input
        n     = n
      IMPORTING
        data  = data ).
  ENDMETHOD.

ENDCLASS.