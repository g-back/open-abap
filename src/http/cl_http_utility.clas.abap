CLASS cl_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_utility.

    ALIASES string_to_fields FOR if_http_utility~string_to_fields.
    ALIASES unescape_url FOR if_http_utility~unescape_url.
    ALIASES escape_url FOR if_http_utility~escape_url.

    CLASS-METHODS decode_x_base64
      IMPORTING
        encoded TYPE string
      RETURNING
        VALUE(decoded) TYPE xstring.

    CLASS-METHODS encode_base64
      IMPORTING
        data TYPE string
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS encode_x_base64
      IMPORTING
        data           TYPE xstring
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS fields_to_string
      IMPORTING
        fields TYPE tihttpnvp
      RETURNING
        VALUE(string) TYPE string.

    CLASS-METHODS set_query
      IMPORTING
        request TYPE REF TO if_http_request
        query   TYPE string.

    CLASS-METHODS set_request_uri
      IMPORTING
        request TYPE REF TO if_http_request
        uri     TYPE string.

    CLASS-METHODS escape_xml_attr_value
      IMPORTING
        unescaped      TYPE csequence
      RETURNING
        VALUE(escaped) TYPE string.

    CLASS-METHODS escape_html
      IMPORTING
        unescaped         TYPE string
        keep_num_char_ref TYPE abap_bool DEFAULT abap_undefined
      RETURNING
        VALUE(escaped)    TYPE string.

    CLASS-METHODS escape_javascript
      IMPORTING
        unescaped      TYPE string
        inside_html    TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(escaped) TYPE string.

ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.

  METHOD set_request_uri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_html.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_javascript.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_xml_attr_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_utility~string_to_fields.
    DATA tab TYPE STANDARD TABLE OF string.
    DATA str LIKE LINE OF tab.
    DATA ls_field LIKE LINE OF fields.

    SPLIT string AT '&' INTO TABLE tab.
    LOOP AT tab INTO str.
      SPLIT str AT '=' INTO ls_field-name ls_field-value.
      APPEND ls_field TO fields.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_query.
    request->set_form_fields( string_to_fields( query ) ).
  ENDMETHOD.

  METHOD fields_to_string.
    DATA tab TYPE STANDARD TABLE OF string.
    DATA str TYPE string.
    DATA ls_field LIKE LINE OF fields.

    LOOP AT fields INTO ls_field.
      str = ls_field-name && '=' && ls_field-value.
      APPEND str TO tab.
    ENDLOOP.
    string = concat_lines_of( table = tab sep = '&' ).
  ENDMETHOD.

  METHOD encode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(data.get(), "hex");'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.

  METHOD decode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString("hex").toUpperCase());'.
  ENDMETHOD.

  METHOD if_http_utility~unescape_url.
    WRITE '@KERNEL let foo = escaped.get();'.
    WRITE '@KERNEL unescaped.set(decodeURIComponent(foo));'.
  ENDMETHOD.

  METHOD if_http_utility~escape_url.
    WRITE '@KERNEL escaped.set(encodeURIComponent(unescaped.get()));'.
  ENDMETHOD.

  METHOD encode_base64.
    WRITE '@KERNEL let buffer = Buffer.from(data.get());'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.
ENDCLASS.