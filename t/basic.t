use v6;
use Test;
plan 6;

use Lib::HPDF;
use NativeCall;

constant NullPointer = Pointer.new;

my Lib::HPDF::Error $error .= new;
my Lib::HPDF::MMgr $mmgr .= new: :$error;
my $b-true = Lib::HPDF::Boolean.new: :$mmgr, :value(True);
say nativecast(Pointer, $b-true.obj);
is $b-true.obj.obj_class, +Lib::HPDF::OCLASS_BOOLEAN;
is ?$b-true.obj, True;
is $b-true.so, True;

my $b-false = Lib::HPDF::Boolean.new: :$mmgr, :value(False);
is ?$b-false, False;
is $b-false.so, False;

my $stream = Lib::HPDF::MemStream.new: :$mmgr;

$b-true.write($stream);
$stream.write(' ');
$b-false.write($stream);
my $ptr = $stream.Buf;
is $ptr.decode("latin-1"), "true false";
