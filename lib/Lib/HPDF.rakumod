use v6;
unit module Lib::HPDF;

use LibraryMake;
use NativeCall;

# Find our compiled library.
constant $LIB-HPDF = 'hpdf';

constant HPDF_BOOL   = int32;
constant HPDF_UINT   = uint32;
constant HPDF_UINT32 = uint32;
constant HPDF_UINT16 = uint16;
constant HPDF_STATUS = ulong;
constant HPDF_Error_Handler = Pointer; # stub
constant HPDF_Alloc_Func = Pointer; # stub
constant HPDF_Free_Func = Pointer; # stub

enum ObjectClass (
    :OCLASS_UNKNOWN(1),
    "OCLASS_NULL"     ,
    "OCLASS_BOOLEAN"  ,
    "OCLASS_NUMBER"   ,
    "OCLASS_REAL"     ,
    "OCLASS_NAME"     ,
    "OCLASS_STRING"   ,
    "OCLASS_BINARY"   ,
    "OCLASS_ARRAY"    ,
    "OCLASS_DICT"     ,
    "OCLASS_PROXY"    ,
    :OCLASS_ANY(0xFF)
    );


enum HPDF_STATUS_CODE (
    HPDF_OK                          =>    0x0000,
    ARRAY_COUNT_ERR                  =>    0x1001,
    ARRAY_ITEM_NOT_FOUND             =>    0x1002,
    ARRAY_ITEM_UNEXPECTED_TYPE       =>    0x1003,
    BINARY_LENGTH_ERR                =>    0x1004,
    CANNOT_GET_PALLET                =>    0x1005,
    DICT_COUNT_ERR                   =>    0x1007,
    DICT_ITEM_NOT_FOUND              =>    0x1008,
    DICT_ITEM_UNEXPECTED_TYPE        =>    0x1009,
    DICT_STREAM_LENGTH_NOT_FOUND     =>    0x100A,
    DOC_ENCRYPTDICT_NOT_FOUND        =>    0x100B,
    DOC_INVALID_OBJECT               =>    0x100C,
#                                          0x100D 
    DUPLICATE_REGISTRATION           =>    0x100E,
    EXCEED_JWW_CODE_NUM_LIMIT        =>    0x100F,
#                                          0x1010
    ENCRYPT_INVALID_PASSWORD         =>    0x1011,
#                                          0x1012
    ERR_UNKNOWN_CLASS                =>    0x1013,
    EXCEED_GSTATE_LIMIT              =>    0x1014,
    FAILD_TO_ALLOC_MEM               =>    0x1015,
    FILE_IO_ERROR                    =>    0x1016,
    FILE_OPEN_ERROR                  =>    0x1017,
#                                          0x1018
    FONT_EXISTS                      =>    0x1019,
    FONT_INVALID_WIDTHS_TABLE        =>    0x101A,
    INVALID_AFM_HEADER               =>    0x101B,
    INVALID_ANNOTATION               =>    0x101C,
#                                          0x101D
    INVALID_BIT_PER_COMPONENT        =>    0x101E,
    INVALID_CHAR_MATRICS_DATA        =>    0x101F,
    INVALID_COLOR_SPACE              =>    0x1020,
    INVALID_COMPRESSION_MODE         =>    0x1021,
    INVALID_DATE_TIME                =>    0x1022,
    INVALID_DESTINATION              =>    0x1023,
#                                          0x1024
    INVALID_DOCUMENT                 =>    0x1025,
    INVALID_DOCUMENT_STATE           =>    0x1026,
    INVALID_ENCODER                  =>    0x1027,
    INVALID_ENCODER_TYPE             =>    0x1028,
#                                          0x1029
#                                          0x102A
    INVALID_ENCODING_NAME            =>    0x102B,
    INVALID_ENCRYPT_KEY_LEN          =>    0x102C,
    INVALID_FONTDEF_DATA             =>    0x102D,
    INVALID_FONTDEF_TYPE             =>    0x102E,
    INVALID_FONT_NAME                =>    0x102F,
    INVALID_IMAGE                    =>    0x1030,
    INVALID_JPEG_DATA                =>    0x1031,
    INVALID_N_DATA                   =>    0x1032,
    INVALID_OBJECT                   =>    0x1033,
    INVALID_OBJ_ID                   =>    0x1034,
    INVALID_OPERATION                =>    0x1035,
    INVALID_OUTLINE                  =>    0x1036,
    INVALID_PAGE                     =>    0x1037,
    INVALID_PAGES                    =>    0x1038,
    INVALID_PARAMETER                =>    0x1039,
#                                          0x103A
    INVALID_PNG_IMAGE                =>    0x103B,
    INVALID_STREAM                   =>    0x103C,
    MISSING_FILE_NAME_ENTRY          =>    0x103D,
#                                          0x103E
    INVALID_TTC_FILE                 =>    0x103F,
    INVALID_TTC_INDEX                =>    0x1040,
    INVALID_WX_DATA                  =>    0x1041,
    ITEM_NOT_FOUND                   =>    0x1042,
    LIBPNG_ERROR                     =>    0x1043,
    NAME_INVALID_VALUE               =>    0x1044,
    NAME_OUT_OF_RANGE                =>    0x1045,
#                                          0x1046
#                                          0x1047
    PAGE_INVALID_PARAM_COUNT         =>    0x1048,
    PAGES_MISSING_KIDS_ENTRY         =>    0x1049,
    PAGE_CANNOT_FIND_OBJECT          =>    0x104A,
    PAGE_CANNOT_GET_ROOT_PAGES       =>    0x104B,
    PAGE_CANNOT_RESTORE_GSTATE       =>    0x104C,
    PAGE_CANNOT_SET_PARENT           =>    0x104D,
    PAGE_FONT_NOT_FOUND              =>    0x104E,
    PAGE_INVALID_FONT                =>    0x104F,
    PAGE_INVALID_FONT_SIZE           =>    0x1050,
    PAGE_INVALID_GMODE               =>    0x1051,
    PAGE_INVALID_INDEX               =>    0x1052,
    PAGE_INVALID_ROTATE_VALUE        =>    0x1053,
    PAGE_INVALID_SIZE                =>    0x1054,
    PAGE_INVALID_XOBJECT             =>    0x1055,
    PAGE_OUT_OF_RANGE                =>    0x1056,
    REAL_OUT_OF_RANGE                =>    0x1057,
    STREAM_EOF                       =>    0x1058,
    STREAM_READLN_CONTINUE           =>    0x1059,
#                                          0x105A
    STRING_OUT_OF_RANGE              =>    0x105B,
    THIS_FUNC_WAS_SKIPPED            =>    0x105C,
    TTF_CANNOT_EMBEDDING_FONT        =>    0x105D,
    TTF_INVALID_CMAP                 =>    0x105E,
    TTF_INVALID_FOMAT                =>    0x105F,
    TTF_MISSING_TABLE                =>    0x1060,
    UNSUPPORTED_FONT_TYPE            =>    0x1061,
    UNSUPPORTED_FUNC                 =>    0x1062,
    UNSUPPORTED_JPEG_FORMAT          =>    0x1063,
    UNSUPPORTED_TYPE1_FONT           =>    0x1064,
    XREF_COUNT_ERR                   =>    0x1065,
    ZLIB_ERROR                       =>    0x1066,
    INVALID_PAGE_INDEX               =>    0x1067,
    INVALID_URI                      =>    0x1068,
    PAGE_LAYOUT_OUT_OF_RANGE         =>    0x1069,
    PAGE_MODE_OUT_OF_RANGE           =>    0x1070,
    PAGE_NUM_STYLE_OUT_OF_RANGE      =>    0x1071,
    ANNOT_INVALID_ICON               =>    0x1072,
    ANNOT_INVALID_BORDER_STYLE       =>    0x1073,
    PAGE_INVALID_DIRECTION           =>    0x1074,
    INVALID_FONT                     =>    0x1075,
    PAGE_INSUFFICIENT_SPACE          =>    0x1076,
    PAGE_INVALID_DISPLAY_TIME        =>    0x1077,
    PAGE_INVALID_TRANSITION_TIME     =>    0x1078,
    INVALID_PAGE_SLIDESHOW_TYPE      =>    0x1079,
    EXT_GSTATE_OUT_OF_RANGE          =>    0x1080,
    INVALID_EXT_GSTATE               =>    0x1081,
    EXT_GSTATE_READ_ONLY             =>    0x1082,
    INVALID_U3D_DATA                 =>    0x1083,
    NAME_CANNOT_GET_NAMES            =>    0x1084,
    INVALID_ICC_COMPONENT_NUM        =>    0x1085,
    );

class HPDF_Error is repr('CStruct') {
    has HPDF_STATUS             $.error_no;
    has HPDF_STATUS             $.detail_no;
    has HPDF_Error_Handler      $.error_fn;
    has Pointer                 $.user_data;
}

class HPDF_MMgr is repr('CPointer') {
    method DESTROY
        is symbol('HPDF_MMgr_Free')
        is native($LIB-HPDF) {*}
}

class HPDF_Stream is repr('CPointer') {
    method Write(Blob $data, HPDF_UINT $size)
        returns HPDF_STATUS
        is symbol('HPDF_Stream_Write')
        is native($LIB-HPDF) {*}
}

class HPDF_MemStream is HPDF_Stream is repr('CPointer') {
    method GetBufPtr(HPDF_UINT    $index,
                     HPDF_UINT    $length is rw)
        returns CArray[uint8]
        is symbol('HPDF_MemStream_GetBufPtr')
        is native($LIB-HPDF) {*}
}

class HPDF_Obj is repr('CStruct') {
    has HPDF_UINT32  $.obj_id is rw;
    has HPDF_UINT16  $.gen_no is rw;
    has HPDF_UINT16  $.obj_class;
    method write(HPDF_Stream $stream)
        returns HPDF_STATUS
        is symbol('HPDF_Obj_Write')
        is native($LIB-HPDF) {*}
}

class HPDF_Boolean is repr('CStruct') 
is HPDF_Obj {
    has HPDF_BOOL        $.value;
}

class Error {
    has $.obj handles <error_no detail_no error_fn user_data>
        = HPDF_Error.new;
}

class MMgr {
    has HPDF_MMgr $.obj;
    sub HPDF_MMgr_New (HPDF_Error   $error,
                       HPDF_UINT        $buf_size,
                       HPDF_Alloc_Func  $alloc_fn,
                       HPDF_Free_Func   $free_fn)
        returns HPDF_MMgr
        is native($LIB-HPDF) {*};

    submethod TWEAK(
        Error:D :$error!,
        UInt :$size = 0,
        Pointer :$alloc_fn,
        Pointer :$free_fn,
    ) {
        $!obj = HPDF_MMgr_New($error.obj, $size, $alloc_fn, $free_fn);
    }     
}

our sub stat(Mu $status) {
    my $res = HPDF_STATUS_CODE($status) // $status;
    fail($res) if $status;
    $res
}

my class Stream { }

class MemStream is Stream {
    has HPDF_MemStream $.obj;
    sub HPDF_MemStream_New(HPDF_MMgr  $mmgr,
                           HPDF_UINT  $buf_siz)
    returns HPDF_MemStream
    is native($LIB-HPDF) {*};
    submethod TWEAK(
        MMgr :$mmgr!,
        UInt :$size = 0,
    ) {
        $!obj = HPDF_MemStream_New($mmgr.obj, $size);
    }
    multi method write(Str $byte-string) {
         stat( $!obj.Write($_, .bytes) )
            with $byte-string.encode: "latin-1";
    }
    method Buf(Int(Cool) $index = 0) {
        my HPDF_UINT $len;
        my $carray = $!obj.GetBufPtr($index, $len);
        buf8.new: $carray[0 ..^ $len];
    }
}

class Object {
    method write(Stream $stream) { $.obj.write($stream.obj) }
}

class Boolean is Object does Bool {
    has HPDF_Boolean $.obj;
    sub HPDF_Boolean_New(HPDF_MMgr  $mmgr,
                         HPDF_BOOL  $value)
        returns HPDF_Boolean
        is native($LIB-HPDF) {*}
    method Bool { ? $!obj.value }
    submethod TWEAK(MMgr :$mmgr!, :$value!) {
        $!obj = HPDF_Boolean_New($mmgr.obj, $value)
    }
}
