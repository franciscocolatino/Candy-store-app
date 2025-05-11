module SimpleCommand
  class NotImplementedError < ::StandardError; end

  class Errors < Hash
    def add(key, value, opts = {})
      create_error(key, value, opts)

      self[key] ||= []
      self[key] << value
      self[key].uniq!
    end

    def add_multiple_errors(errors_hash)
      errors_hash.each do |key, values|
        values.each { |value| add key, value }
      end
    end

    def each
      each_key do |field|
        self[field].each { |message| yield field, message }
      end
    end

    def full_messages
      map { |attribute, message| full_message(attribute, message) }
    end

    private

    def full_message(attribute, message)
      return message if attribute == :base
      attr_name = attribute.to_s.tr('.', '_').capitalize
      "%s %s" % [attr_name, message]
    end

    def create_error(key, value, opts = {})
      Utils::CreateError.call(key, value, opts)
    rescue => e
      p e.to_s
      nil
    end
  end
end