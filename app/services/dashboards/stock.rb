class Dashboards::Stock  
  prepend SimpleCommand

  def call
    lots = Lot.includes(:product).where("quantity > 0")

    total_items = lots.sum(:quantity)

    products = lots.group(:product_id).sum(:quantity)

    product_details = Product.where(id: products.keys).index_by(&:id)

    {
      total_stock_items: total_items,
      stock_per_product: products.transform_keys { |id| product_details[id]&.name || "Produto ##{id}" }
    }
  end
end
