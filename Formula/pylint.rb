class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/4e/9d/fa68dd17140373786c5a379f6b313ceeb324dfe47ff13f717710c2e63c1d/pylint-2.15.5.tar.gz"
  sha256 "3b120505e5af1d06a5ad76b55d8660d44bf0f2fc3c59c2bdd94e39188ee3a4df"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23fec3f779a92b41fd0e0ab633d8664b866e4f7487d16a02ac74ea08ca43186d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a23cbe40914a7c9be50a22068dd1333d998d992357e7b477db1afe82a516d8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce41cb981f0211c163ef691624f1a358476fd59e375d0e847010ef98a8e7ccb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b2ae693f257a82f6d2d5dabf89e0531dced06b98ea904505240fcdaff068f61"
    sha256 cellar: :any_skip_relocation, catalina:       "57fd56b0cc420ab520e2d390e931ef355e159ccef1e8112960fab90fd036617e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746e9df2797f34a7f1ccb03fb6ef440b430c30eac8eaaf0e0b227b7f0f612a5f"
  end

  depends_on "isort"
  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/be/61/5a97efa0622b3413e3d01d6bc6b019a87bcc23058c378dbd24b8c2474860/astroid-2.12.12.tar.gz"
    sha256 "1c00a14f5a3ed0339d38d2e2e5b74ea2591df5861c0936bb292b84ccf3a78d83"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/59/46/634d5316ee8984e7dac658fb2e297a19f50a1f4007b09acb9c7c4e15bd67/dill-0.3.5.1.tar.gz"
    sha256 "d75e41f3eff1eee599d738e76ba8f4ad98ea229db8b085318aa2b3333a208c86"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/75/93/3fc1cc28f71dd10b87a53b9d809602d7730e84cc4705a062def286232a9c/lazy-object-proxy-1.7.1.tar.gz"
    sha256 "d609c75b986def706743cdebe5e47553f4a5a1da9c5ff66d76013ef396b5a8a4"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0c/2b/7823f215c6aec294f5ab5ff2f529aca1d85e8bec2208ae7ea89ca1413620/tomlkit-0.11.5.tar.gz"
    sha256 "571854ebbb5eac89abcb4a2e47d7ea27b89bf29e09c35395da6f03dd4ae23d1c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
