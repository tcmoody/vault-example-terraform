resource "aws_elb" "vault-lb" {
    name = "vault-server-lb"
    security_groups = [
        "${var.tcp_outbound_all_id}",
        "${var.elb_inbound_https_id}"
    ]
    listener {
        instance_port     = 8200
        instance_protocol = "http"
        lb_port           = 443
        lb_protocol       = "https"
        ssl_certificate_id = "${var.ssl_certificate_id}"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "TCP:8200"
        interval            = 10
    }

    instances                   = ["${aws_instance.vault-servers.*.id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400
    subnets = ["${var.public_subnet_ids}"]

    tags = {
        Name = "vault-elb"
    }
}

data "aws_route53_zone" "vault" {
  name = "${var.hosted_zone}.com."
}

resource "aws_route53_record" "vault-lb-record" {
  zone_id = "${data.aws_route53_zone.vault.id}"
  name    = "test.${var.hosted_zone}.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.vault-lb.dns_name}"]
}