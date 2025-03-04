terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# Run docker compose build before deployment
resource "null_resource" "execute_compose_build" {
  provisioner "local-exec" {
    command     = "powershell.exe -ExecutionPolicy Bypass -File ./buildImg.ps1"
    working_dir = path.module
  }
}

# Run docker compose up after build
resource "null_resource" "run_compose" {
  provisioner "local-exec" {
    command     = "docker compose up -d"
    working_dir = path.module
  }
  depends_on = [null_resource.execute_compose_build]
}

# ตรวจสอบว่า Container Node.js และ Nginx รันอยู่
resource "null_resource" "check_containers_status" {
  provisioner "local-exec" {
    command     = <<EOT
      $nodejs = docker ps | Select-String "nodejs"
      $nginx = docker ps | Select-String "nginx"
      if (-not $nodejs) {
          Write-Host "❌ Node.js ไม่ได้รันอยู่!"
          exit 1
      } 
      elseif (-not $nginx) {
          Write-Host "❌ Nginx ไม่ได้รันอยู่!"
          exit 1
      }
      else {
          Write-Host "✅ Node.js และ Nginx ทำงานอยู่"
      }
    EOT
    interpreter = ["PowerShell", "-Command"]
    working_dir = path.module
  }
  depends_on = [null_resource.run_compose]
}
