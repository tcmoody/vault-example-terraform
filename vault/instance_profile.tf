resource "aws_iam_instance_profile" "ec2_describe_instances_and_kms_profile" {
  name = "vault-describe-instances-and-kms"
  role = "${aws_iam_role.ec2_describe_instances_and_kms_role.name}"
}

resource "aws_iam_role" "ec2_describe_instances_and_kms_role" {
  name = "ec2-and-kms-describe-role"
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

resource "aws_iam_role_policy" "describe_instances_and_kms_role_policy" {
  name   = "Describe-Instances-and-KMS"
  role   = "${aws_iam_role.ec2_describe_instances_and_kms_role.id}"
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
    },
    {
      "Action": [
        "kms:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}