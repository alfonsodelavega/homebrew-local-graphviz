class GraphvizAT2441 < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.44.1.tar.gz"
  sha256 "8e1b34763254935243ccdb83c6ce108f531876d7a5dfd443f255e6418b8ea313"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  livecheck do
    url "https://www2.graphviz.org/Packages/stable/portable_source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  # See https://github.com/Homebrew/homebrew-core/pull/57132
  # Fixes:
  # groff -Tps -man cdt.3 >cdt.3.ps
  #   CCLD     libcdt.la
  #   CCLD     libcdt_C.la
  # false cdt.3.ps cdt.3.pdf
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "autoreconf", "-fiv"
    system "./configure", *args
    system "make", "install"

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index cf42504..68db027 100644
--- a/configure.ac
+++ b/configure.ac
@@ -284,8 +284,7 @@ AC_CHECK_PROGS(SORT,gsort sort,false)

 AC_CHECK_PROG(EGREP,egrep,egrep,false)
 AC_CHECK_PROG(GROFF,groff,groff,false)
-AC_CHECK_PROG(PS2PDF,ps2pdf,ps2pdf,false)
-AC_CHECK_PROG(PS2PDF,pstopdf,pstopdf,false)
+AC_CHECK_PROGS(PS2PDF,ps2pdf pstopdf,false)

 PKG_PROG_PKG_CONFIG
