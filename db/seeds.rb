# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample products
puts "Creating sample products..."

User.create!(name: "Admin", cpf: "12345678901", password: "123", is_admin: true)
User.create!(name: "User", cpf: "12345678902", password: "123", is_admin: false)

puts "Seed data created successfully!"