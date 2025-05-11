class Utils::CreateError
  prepend SimpleCommand

  def initialize(key, value, opts)
    @key = key
    @value = value
    @opts = opts
  end

  def call
    p "------------! Error !-------------"
    p "Key Error: #{@key}"
    p "Message Error: #{@value}"
    p "Payload: #{@opts}"
    p "--------- ! --------- ! ----------"
  rescue
    nil
  end
end