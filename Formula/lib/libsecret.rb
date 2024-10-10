class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.21/libsecret-0.21.4.tar.xz"
  sha256 "163d08d783be6d4ab9a979ceb5a4fecbc1d9660d3c34168c581301cd53912b20"
  license "LGPL-2.1-or-later"

  # libsecret doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libsecret[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "50e5f771aa551730a1f311d965730283ba5e0aef8665b71c4ba12ec75db03d3f"
    sha256 cellar: :any, arm64_sonoma:   "844f8b10821660e2cf4ee2a41870ef5157475e7bd983ad4902364bee227b7d9e"
    sha256 cellar: :any, arm64_ventura:  "366983f28d6e6d1902f3db15dd6820b1d98f3a5d428fcbcff96b5acbae5f8f33"
    sha256 cellar: :any, arm64_monterey: "ba020d35c50475b48171733da01a4e64d9c9eddb44cb2628e16aa9aa8d90aa75"
    sha256 cellar: :any, sonoma:         "ce2e4f76aff32ff460e9e2d7e0b33b793b21198ff129263284e261ce787fd744"
    sha256 cellar: :any, ventura:        "597ef705442807a894e8da264b91fd9c3a459b86d2cbc603a9d20009a1cc4a8f"
    sha256 cellar: :any, monterey:       "852e9303bb505b035ac0be971ebc5cc1575cb04478cbf38bdbe3488ec61e1070"
    sha256               x86_64_linux:   "54a706903821db3696f0ace2272830f2f04b524edd6f01d4aa4dad0ba2d2287f"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgcrypt"
  uses_from_macos "libxslt" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", "-Dbashcompdir=#{bash_completion}",
                                      "-Dgtk_doc=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsecret/secret.h>

      const SecretSchema * example_get_schema (void) G_GNUC_CONST;

      const SecretSchema *
      example_get_schema (void)
      {
          static const SecretSchema the_schema = {
              "org.example.Password", SECRET_SCHEMA_NONE,
              {
                  {  "number", SECRET_SCHEMA_ATTRIBUTE_INTEGER },
                  {  "string", SECRET_SCHEMA_ATTRIBUTE_STRING },
                  {  "even", SECRET_SCHEMA_ATTRIBUTE_BOOLEAN },
                  {  "NULL", 0 },
              }
          };
          return &the_schema;
      }

      int main()
      {
          example_get_schema();
          return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libsecret-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
