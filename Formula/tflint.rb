class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.42.2.tar.gz"
  sha256 "3c6eaa453bba28a5948da4fc9455f74976e371291dad9fe1b0164a61e6d3d820"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02270648a8065cdb0bdf1443ddb68592f3fd295f6e19fc1a80e02db10f29a99c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c7d3489673f14dc009b249165b5b37f332baac7103b38ae4239a58415af224"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5e78fd682914327cabfeb30bcc443dab9070d4210bb995c6df03f6cc3b7405"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a054c9e8a31bcde70a7d8f67eb307b4f67fe43f1ceb620df50b4b6cf5fe866"
    sha256 cellar: :any_skip_relocation, catalina:       "61f877c33bda840d138814e47f1d38b0056503dfca489ca816f77693b00aca89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1ada3680db503edb7e2dcd231d7ef925207e0de79242c59e44220224d2b445"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
