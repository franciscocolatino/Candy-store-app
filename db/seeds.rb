# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample products
puts "Creating sample products..."

User.create!(name: "Admin", cpf: "12345678901", password: "123", is_admin: true)
User.create!(name: "Anderson Passos", cpf: "12345678903", password: "123", is_admin: true)
User.create!(name: "Francisco Colatino", cpf: "12345678904", password: "123", is_admin: true)
User.create!(name: "Jônatas Leite", cpf: "12345678905", password: "123", is_admin: true)
User.create!(name: "Rayane Duarte", cpf: "12345678906", password: "123", is_admin: true)
User.create!(name: "Thallys Alcantara", cpf: "12345678907", password: "123", is_admin: true)


User.create!(name: "User", cpf: "12345678902", password: "123", is_admin: false)

Product.create!([
  {
    name: "Bolo de Chocolate",
    description: "Bolo fofinho de chocolate com cobertura de brigadeiro.",
    category: "Bolos",
    price: 45.90
  },
  {
    name: "Torta de Limão",
    description: "Torta crocante com recheio de creme de limão e cobertura de merengue.",
    category: "Tortas",
    price: 38.50
  },
  {
    name: "Cupcake de Red Velvet",
    description: "Cupcake macio de red velvet com cobertura de cream cheese.",
    category: "Cupcakes",
    price: 7.50
  },
  {
    name: "Cheesecake de Frutas Vermelhas",
    description: "Cheesecake tradicional com calda artesanal de frutas vermelhas.",
    category: "Tortas",
    price: 52.00
  },
  {
    name: "Pão de Mel",
    description: "Pão de mel recheado com doce de leite e coberto com chocolate meio amargo.",
    category: "Doces",
    price: 5.00
  },
  {
    name: "Bolo de Cenoura com Chocolate",
    description: "Bolo de cenoura fofinho com cobertura generosa de chocolate.",
    category: "Bolos",
    price: 39.90
  },
  {
    name: "Brigadeiro Gourmet",
    description: "Brigadeiro feito com chocolate belga e granulado gourmet.",
    category: "Doces",
    price: 3.50
  },
  {
    name: "Brownie Tradicional",
    description: "Brownie macio por dentro, crocante por fora, com pedaços de chocolate.",
    category: "Doces",
    price: 8.00
  },
  {
    name: "Mini Naked Cake de Morango",
    description: "Mini naked cake recheado com creme de baunilha e morangos frescos.",
    category: "Bolos",
    price: 29.90
  },
  {
    name: "Torta de Nozes",
    description: "Torta cremosa com nozes caramelizadas e massa amanteigada.",
    category: "Tortas",
    price: 58.00
  }
])

products = Product.all

  products.each do |product|
    Lot.create!(
      product: product,
      quantity: 20,
      manufacturing_date: Date.today - 10,
      expiration_date: Date.today + 20
    )

    Lot.create!(
      product: product,
      quantity: 15,
      manufacturing_date: Date.today - 5,
      expiration_date: Date.today + 25
    )
  end


puts "Seed data created successfully!"
