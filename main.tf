# 1. Configuración de AWS con tu región exacta de GitHub Actions
provider "aws" {
  region = "eu-north-1" 
}

# 2. Truco inteligente: Terraform busca tu red por defecto en AWS automáticamente
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 3. Creamos el Clúster de ECS con el nombre exacto de tu GitHub
resource "aws_ecs_cluster" "cluster_windows" {
  name = "primer-docker-windows-cluster"
}

# 4. Definimos el plano del contenedor de Windows
resource "aws_ecs_task_definition" "tarea_node_windows" {
  family                   = "app-node-windows-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"       # Windows requiere mínimo 1 vCPU
  memory                   = "2048"       # Windows requiere mínimo 2 GB de RAM

  runtime_platform {
    operating_system_family = "WINDOWS_SERVER_2022_CORE"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = "mi-contenedor-ubuntu" # El nombre que espera tu GitHub Actions
    image     = "ghcr.io/Mois-sgv/docker-api-nodejs:latest" # Aquí irá tu imagen de GitHub Packages
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

# 5. El Servicio que mantiene tu app viva en internet
resource "aws_ecs_service" "servicio_windows" {
  name            = "primer-docker-service"
  cluster         = aws_ecs_cluster.cluster_windows.id
  task_definition = aws_ecs_task_definition.tarea_node_windows.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids # Usa las subredes automáticas que buscamos arriba
    assign_public_ip = true
  }
}
# 6. Crear el conector de confianza oficial con GitHub (OIDC) - Corregido
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://githubusercontent.com"
  client_id_list  = ["://amazonaws.com"]
  thumbprint_list = [
    "69ac29567e7d38440049730c4598a235311c0227", 
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
    "15e29108718111e59b3ded3195507ae2931ec6d4"] 
}

# 7. Crear el Rol de Seguridad Flexible para tu Repositorio
resource "aws_iam_role" "rol_github_actions" {
  name = "github-actions-ecs-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            # Usamos StringLike y un asterisco para evitar fallos por mayúsculas en tu nombre de usuario
            "://githubusercontent.com:sub" = "repo:Mois-sgv/Docker-Api-Nodejs:*"
          }
          StringEquals = {
            "://githubusercontent.com:aud" = "://amazonaws.com"
          }
        }
      }
    ]
  })
}

# 8. Darle permisos de Administrador a este rol para que pueda actualizar ECS
resource "aws_iam_role_policy_attachment" "github_admin" {
  role       = aws_iam_role.rol_github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 9. Imprimir en pantalla el código del Rol cuando termine
output "arn_del_rol_para_github" {
  value       = aws_iam_role.rol_github_actions.arn
  description = "Copia este código y ponlo en tu archivo del workflow de GitHub"
}
# 10. Le pedimos a Terraform que busque los datos de red del servicio en tiempo real
#data "aws_network_interface" "ip_contenedor" {
 # filter {
 #   name   = "description"
 #   values = ["AWS Fargate task*"]
#  }
#}

# 11. Imprime la dirección IP pública directamente en la terminal
#output "url_publica_de_mi_app" {
#  value       = "http://${data.aws_network_interface.ip_contenedor.association[0].public_ip}:3000"
#  description = "Copia y pega este enlace en tu navegador para ver tu Hola Mundo"
#}
