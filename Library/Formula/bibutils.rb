require 'formula'

class Bibutils < Formula
  homepage 'http://sourceforge.net/p/bibutils/home/Bibutils/'
  url 'http://sourceforge.net/projects/bibutils/files/bibutils_4.12_src.tgz'
  sha1 '027be11cbad8261d0a6fc1056010480b23385ba2'

  def install
    system "./configure", "--install-dir", prefix

    # The configure script replaces the CC variable wrong, so fix it here
    inreplace 'Makefile' do |s|
      s.change_make_var! 'CC', "CC=#{ENV.cc}"
    end

    system "make"

    cd 'bin' do
      bin.install %w{bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
        biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end xml2isi xml2ris
        xml2wordbib modsclean}
    end
  end
end
