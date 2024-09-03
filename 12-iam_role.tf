resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

###
resource "aws_iam_role" "ecs_cluster_policy" {
  name               = "ecs-cluster-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_cluster_role.json
}

data "aws_iam_policy_document" "ecs_cluster_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_cluster_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_cluster_policy.arn
  role       = aws_iam_role.ecs_cluster_policy.name
}
