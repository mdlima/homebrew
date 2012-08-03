require 'formula'

class Player < Formula
  homepage 'http://playerstage.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/playerstage/Player/3.0.2/player-3.0.2.tar.gz'
  sha1 '34931ca57148db01202afd08fdc647cc5fdc884c'

  head 'https://playerstage.svn.sourceforge.net/svnroot/playerstage/code/player/trunk'

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" unless ARGV.include? "--without-gui"
  depends_on "libgnomecanvas" unless ARGV.include? "--without-gui"
  depends_on "gdk-pixbuf" unless ARGV.include? "--without-gui"
  depends_on "gsl" unless ARGV.include? "--without-gui"
  depends_on 'boost'

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      clang: error: unsupported option '--fast-math'
      EOS
  end

  def options
    [
      ["--universal",          "Build in universal mode"    ],
      ["--without-gui",        "Build whithout GUI"         ],
      ["--no-ruby-bindings",   "Do not build Ruby bindings" ],
      ["--no-python-bindings", "Do not build Python bindings" ]
    ]
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    # ENV.universal_binary if ARGV.build_universal?
    args = std_cmake_args
    # puts std_cmake_args
    # args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if ARGV.build_universal?
    args << "-DBUILD_RUBY_BINDINGS=OFF" if ARGV.include? "--no-ruby-bindings"
    args << "-DBUILD_PYTHONC_BINDINGS=OFF" if ARGV.include? "--no-python-bindings"
    # puts args

    system "cmake", ".", *args
    system "make"
    system "make install"
  end
  
  def caveats
    <<-EOS.undent
    Can't build universal version. Errors with guile library for i386 build.
    Python and Ruby bindings are not working as well.
    EOS
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test player`.
    system "player"
  end
end
