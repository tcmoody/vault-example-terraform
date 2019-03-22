resource "aws_iam_instance_profile" "ec2_describe_instances_profile" {
  name = "consul-describe-instances"
  role = "${aws_iam_role.ec2_describe_instances_role.name}"
}

resource "aws_iam_role" "ec2_describe_instances_role" {
  name = "ec2-describe-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "describe_instances_role_policy" {
  name   = "Describe-Instances"
  role   = "${aws_iam_role.ec2_describe_instances_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}