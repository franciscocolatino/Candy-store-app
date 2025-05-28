# Criação de usuários
User.create!(name: "Admin", cpf: "12345678901", password: "123", is_admin: true)
User.create!(name: "Anderson Passos", cpf: "12345678903", password: "123", is_admin: true)
User.create!(name: "Francisco Colatino", cpf: "12345678904", password: "123", is_admin: true)
User.create!(name: "Jônatas Leite", cpf: "12345678905", password: "123", is_admin: true)
User.create!(name: "Rayane Duarte", cpf: "12345678906", password: "123", is_admin: true)
User.create!(name: "Thallys Alcantara", cpf: "12345678907", password: "123", is_admin: true)

User.create!(name: "User", cpf: "12345678902", password: "123", is_admin: false)

# Criação de produtos
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

# Criação dos lotes
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

# Criação das mesas
tables = []
5.times do |i|
  tables << Table.create!(number: i + 1)
end

# Criação de pedidos simulados
user = User.find_by(cpf: "12345678902")
lots = Lot.all

# Pedido 1 - Mesa 1
order1 = Order.create!(
  user_cpf: user.cpf,
  table: tables[0],
  is_finished: false,
  total_price: 0.0
)

lot_2 = lots.sample
OrderLot.create!(
  order: order1,
  lot: lot_2,
  quantity: 2,
  subtotal: lot_2.product.price * 2
)

order1.update!(total_price: order1.order_lots.sum(:subtotal))

# Pedido 2 - Mesa 2
order2 = Order.create!(
  user_cpf: user.cpf,
  table: tables[1],
  is_finished: false,
  total_price: 0.0
)

lot_3 = lots.sample
OrderLot.create!(
  order: order2,
  lot: lot_3,
  quantity: 1,
  subtotal: lot_3.product.price * 1
)

lot_4 = lots.sample
OrderLot.create!(
  order: order2,
  lot: lot_4,
  quantity: 3,
  subtotal: lot_4.product.price * 3
)

order2.update!(total_price: order2.order_lots.sum(:subtotal))

# Pedido 3 - Mesa 3 (finalizado)
order3 = Order.create!(
  user_cpf: user.cpf,
  table: tables[2],
  is_finished: true,
  total_price: 0.0,
  date: Date.today - 1
)

lot_1 = lots.sample

OrderLot.create!(
  order: order3,
  lot: lot_1,
  quantity: 4,
  subtotal: lot_1.product.price * 4
)

order3.update!(total_price: order3.order_lots.sum(:subtotal))

puts "Seed data created successfully!"
