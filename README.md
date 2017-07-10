Lib::HPDF
========

This is an experimental backend that put the LibHaru PDF module to
work in the PDF tool-chains. Note that LibHaru doesn't read PDFs,
but what's there looks good.

This is a bottom-up integration, which is centered on representing
and serializing PDF objects. The intent is to map Dicts, Arrays
and primary objects to LibHaru objects.

Hopefully access may ber somewhat quicker and with a lower memory footprint.

Serialization, has to be quicker, we can directly output dictionarys and
arrays to memory or files.

I'm not so interested in the high level stuff: Pages, Catalogs, etc. That
can be done in Perl.

There's some other areas of the toolkit that may be of interest such as
encodings, fonts, xrefs.
