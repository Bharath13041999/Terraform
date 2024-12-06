# Create ECR Repository
resource "aws_ecr_repository" "flask_app_repo" {
  name = "flask-app-repo"
 
  tags = {
    Name = "flask-app-repo"
  }
}