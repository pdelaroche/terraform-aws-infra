# Availability Zones
# Permite obtener las zonas de disponibilidad disponibles en la region especificada
data "aws_availability_zones" "available" {
  state = "available"
}