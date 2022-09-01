require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.102.tgz"
  sha256 "91b9cc86ba320ea965011faa8fd068966ee1b1b580612286ed49e6c89bc470e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9add08ae4753f58bf0503ce99ec4023c61db04149bc574dfbddc270587b2e46"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
