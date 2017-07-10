use v6;
unit module Lib::HPDF;

use LibraryMake;
use NativeCall;

# Find our compiled library.
sub libhpdf is export(:libhpdf) {
    state $ = do {
	my $so = get-vars('')<SO>;
	~(%?RESOURCES{"library/libhpdf$so"});
    }
}

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

class HPDF_Error is repr('CStruct') {
    has HPDF_STATUS             $.error_no;
    has HPDF_STATUS             $.detail_no;
    has HPDF_Error_Handler      $.error_fn;
    has Pointer                 $.user_data;
}

class HPDF_MMgr is repr('CPointer') {
    method DESTROY
        is symbol('HPDF_MMgr_Free')
        is native {*}
}

class HPDF_Stream is repr('CPointer') {
    method GetBufPtr(HPDF_UINT    $index,
                     HPDF_UINT    $length is rw)
        returns CArray[uint8]
        is symbol('HPDF_MemStream_GetBufPtr')
        is native {*}
    method Write(Blob $data, HPDF_UINT $size)
        is symbol('HPDF_Stream_Write')
        is native {*}
}

class HPDF_Obj_Header is repr('CStruct') {
    has HPDF_UINT32  $.obj_id is rw;
    has HPDF_UINT16  $.gen_no is rw;
    has HPDF_UINT16  $.obj_class;
}

class HPDF_Boolean is repr('CStruct') 
is HPDF_Obj_Header {
    has HPDF_BOOL        $.value;
    method write(HPDF_Stream $stream)
        is symbol('HPDF_Boolean_Write')
        is native {*}
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
        is native(libhpdf) {*};

    submethod TWEAK(
        Error:D :$error!,
        UInt :$buf_size = 1_000_000,
        Pointer :$alloc_fn,
        Pointer :$free_fn,
    ) {
        $!obj = HPDF_MMgr_New($error.obj, $buf_size, $alloc_fn, $free_fn);
    }     
}

my class Stream { }

class MemStream is Stream {
    has HPDF_Stream $.obj;
    sub HPDF_MemStream_New(HPDF_MMgr  $mmgr,
                           HPDF_UINT  $buf_siz)
    returns HPDF_Stream
    is native(libhpdf) {*};
    submethod TWEAK(
        MMgr :$mmgr!,
        UInt :$buf_size = 10_000,
    ) {
        $!obj = HPDF_MemStream_New($mmgr.obj, $buf_size);
    }
    multi method write(Str $byte-string) {
        $!obj.Write($_, .bytes)
            with $byte-string.encode: "latin-1";
    }
    method Buf(Int(Cool) $index = 0) {
        my HPDF_UINT $len;
        my $carray = $!obj.GetBufPtr($index, $len);
        buf8.new: $carray[0 ..^ $len];
    }
}

class Boolean does Bool {
    has HPDF_Boolean $.obj;
    sub HPDF_Boolean_New(HPDF_MMgr  $mmgr,
                         HPDF_BOOL  $value)
        returns HPDF_Boolean
        is native(libhpdf) {*}
    method Bool { ? $!obj.value }
    method write(Stream $stream) { $!obj.write($stream.obj) }
    submethod TWEAK(MMgr :$mmgr!, :$value!) {
        $!obj = HPDF_Boolean_New($mmgr.obj, $value)
    }
}
