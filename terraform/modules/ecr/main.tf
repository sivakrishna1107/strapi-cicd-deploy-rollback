resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-repo-siva-t11"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}