output "control_plane_ip" {
  value = yandex_compute_instance.control-plane-vm.network_interface.0.nat_ip_address
}

output "workers_ip" {
  value = yandex_compute_instance_group.worker-nodes-group.instances[*].network_interface[0].nat_ip_address
}

output "network_balancer_ip" {
  value = yandex_lb_network_load_balancer.grafana-balancer.listener.*.external_address_spec[*].*.address
}

output "container_registry_id" {
  value = yandex_container_registry.netology-registry.id
}

output "netology_registry_service_account_key" {
  value = {
    id                 = yandex_iam_service_account_key.netology-registry-service-account-key.id
    service_account_id = yandex_iam_service_account_key.netology-registry-service-account-key.service_account_id
    created_at         = yandex_iam_service_account_key.netology-registry-service-account-key.created_at
    key_algorithm      = yandex_iam_service_account_key.netology-registry-service-account-key.key_algorithm
    public_key         = yandex_iam_service_account_key.netology-registry-service-account-key.public_key
    private_key        = yandex_iam_service_account_key.netology-registry-service-account-key.private_key
  }
  sensitive = true
}

resource "local_file" "tf_nodes_ip" {
  content  = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    # Generated by Terraform mgmt configuration.

    tf_master_ip: ${yandex_compute_instance.control-plane-vm.network_interface.0.nat_ip_address}
    tf_worker1_ip: ${yandex_compute_instance_group.worker-nodes-group.instances[0].network_interface.0.nat_ip_address}
    tf_worker2_ip: ${yandex_compute_instance_group.worker-nodes-group.instances[1].network_interface.0.nat_ip_address}
    tf_worker3_ip: ${yandex_compute_instance_group.worker-nodes-group.instances[2].network_interface.0.nat_ip_address}
    DOC
  filename = "../tf_nodes_ip.yml"
}