/* IAM roles and policies */
resource "aws_iam_role" "ecs" {
    name = "${var.environment}-${var.project}-iam-role-ecs"
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

resource "aws_iam_policy_attachment" "ecs_for_ec2" {
  name = "${var.environment}-${var.project}-iam-policy-ecs-for-ec2"
  roles = ["${aws_iam_role.ecs.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_elb" {
    name = "${var.environment}-${var.project}-iam-role-ecs-elb"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_elb" {
  name = "${var.environment}-${var.project}-iam-policy-ecs-elb"
  roles = ["${aws_iam_role.ecs_elb.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


resource "aws_iam_role_policy" "weave" {
  name = "weave-${var.environment}-${var.project}-iam-role-policy"
  role = "${aws_iam_role.ecs.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:Submit*",
                "ecs:ListClusters",
                "ecs:ListContainerInstances",
                "ecs:DescribeContainerInstances",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "autoscaling:DescribeAutoScalingInstances",
                "s3:GetObject"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

/*
 @todo remove local-exec once this has been resolved and we using
 terraform >v0.6.14:
 https://github.com/hashicorp/terraform/issues/5862
 */
resource "aws_iam_instance_profile" "profile" {
  name = "${var.environment}-${var.project}-profile"
  roles = ["${aws_iam_role.ecs.name}"]
}
