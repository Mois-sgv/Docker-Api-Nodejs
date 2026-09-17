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
  name = "primer-docker-cluster"
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
