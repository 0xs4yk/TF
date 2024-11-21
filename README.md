# TF

## Maxence Lancosme M2 Infra CLoud

# Déploiement AWS avec Terraform

Ce projet utilise **Terraform** pour déployer une infrastructure AWS simple comprenant :

- Un Load Balancer (ALB) pour distribuer le trafic.
- Un Target Group pour connecter les instances EC2 au Load Balancer.
- Une Launch Template pour définir les paramètres des instances EC2.
- Un Auto Scaling Group pour gérer automatiquement les instances.
- Une Key Pair pour permettre l'accès SSH aux instances.

## Contenu du fichier `main.tf`

Le fichier `main.tf` contient :

1. **Load Balancer**  
   - Crée un Application Load Balancer (ALB) pour gérer le trafic HTTP sur le port 80.

2. **Target Group**  
   - Définit un groupe cible pour les instances EC2, avec un contrôle de santé des instances.

3. **Launch Template**  
   - Configure les instances EC2 avec une AMI, un type d'instance, et un script d'initialisation pour installer un serveur HTTP (`httpd`).

4. **Auto Scaling Group**  
   - Gère dynamiquement le nombre d'instances EC2 en fonction de la charge et connecte ces instances au Target Group.

5. **Key Pair**  
   - Ajoute une clé SSH pour accéder aux instances.

## Instructions

1. Initialisez Terraform :  
   ```bash
   terraform init

2. Vérifier ce qui va être déployer :
  ```bash
  terraform pla
  ```

3. Appliquer la configuration sur AWS :
  ```bash
  terraform apply
  ```
