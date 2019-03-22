data "aws_route53_zone" "vault" {
  name = "${var.hosted_zone}.com."
}

resource "aws_acm_certificate" "vault" {
  domain_name   = "test.${var.hosted_zone}.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.vault.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.vault.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.vault.id}"
  records = ["${aws_acm_certificate.vault.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "vault" {
  certificate_arn         = "${aws_acm_certificate.vault.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

output "vault_certificate_arn" {
  value = "${aws_acm_certificate_validation.vault.certificate_arn}"
}