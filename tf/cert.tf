resource "aws_iam_server_certificate" "main" {
  name = "${var.environment}-${var.project}-cert-main"
  certificate_body = "${file("XXXXXX.com.cert-body.pem")}"
  certificate_chain = "${file("XXXXXX.com.cert-chain.pem")}"
  private_key = "${file("XXXXXX.com.privkey.pem")}"
  path = "/XXXXXX/"
}
