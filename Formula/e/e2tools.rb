class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "https://e2tools.github.io/"
  url "https://github.com/e2tools/e2tools/releases/download/v0.1.0/e2tools-0.1.0.tar.gz"
  sha256 "c1a06b5ae2cbddb6f04d070e889b8bebf87015b8585889999452ce9846122edf"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189a32d6a537cf7f38e4f935a2f6bb4f83ca9ab39140aa3e7b521f1611ed13cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e1f3be71a478efda672fea5d23fc466c5d23d571809b459a56cb4967258fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4764d51ea5016a50dc90a7665db17f327742011eb24d6bc3635b5e4cb7e3efda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c94d559938d504bc7ddc19139c8af004385b57db58bfd24946c451b4752928"
    sha256 cellar: :any_skip_relocation, sonoma:         "e52f7c024b90aa5c602325b326a1fab7f1a4eaea0c2f6c4eda8b1ab5c9cdddd4"
    sha256 cellar: :any_skip_relocation, ventura:        "2a0c41e09aefd7f4029d97c076a63281bbff422eeff81839e5b5a809934f3576"
    sha256 cellar: :any_skip_relocation, monterey:       "46ec372f7ee195a92d3d0f3ffca17192b48a2e9f1dd1f74b721aed99ad90cdc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "38978d9bea279b06c646bc82631d59edee4a519164f4b0a4f39b33621ae1183b"
    sha256 cellar: :any_skip_relocation, catalina:       "93eab5f2d207ac8f27a9b27db13408b4b7f8a3cfee4ecbca9d9977a851a41576"
    sha256 cellar: :any_skip_relocation, mojave:         "1ad81d83b87fc67a54698e6af829dd0945119a41a445383268f1d0190ff7b38d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "069988a622ce0587927a4a50b70b778b461840d2db2e49259e1123123bf6a2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc52ded6e99ba793baaf68c70a158ab156829f74e090b1182f9dc15d816357ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin/"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}/e2ls test.raw")
  end
end
