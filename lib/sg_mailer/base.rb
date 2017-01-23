module SGMailer
  class Base
    class << self
      def default(values = nil)
        @default ||= {}
        @default.merge!(values) if values
        @default
      end

      def template_id(id)
        @current_template_id = id
      end

      def template_ids
        @template_ids ||= {}
      end

      private

      def instance
        @instance ||= new
      end

      def inherited(klass)
        klass.instance_variable_set(:@default, default.dup)
      end

      def method_missing(name, *args, &block)
        if public_instance_methods.include?(name)
          SGMailer.delivery_processor.new \
            instance.public_send(name, *args, &block)
        else
          super
        end
      end

      def method_added(method_name)
        if @current_template_id
          template_ids[method_name.to_s] = @current_template_id
        end

        @current_template_id = nil
      end
    end

    private

    def mail(**options)
      # Guess the template id here, so we don't have to account for extra
      # calls.
      guessed_template_id =
        self.class.template_ids[caller_locations.first.base_label]

      normalized = normalize_options({
        template_id: guessed_template_id
      }.merge(options))

      MailBuilder.build(normalized)
    end

    def normalize_options(options)
      deep_merge(self.class.default, options)
    end

    # Based on the Active Support Hash#deep_merge! core extension. Inlined
    # here, so we don't need to explicitly depend on Active Support.
    def deep_merge(hash, other_hash)
      merged = hash.dup

      other_hash.each_pair do |current_key, other_value|
	this_value = merged[current_key]

	merged[current_key] =
	  if this_value.is_a?(Hash) && other_value.is_a?(Hash)
	    deep_merge(this_value, other_value)
	  else
	    other_value
	  end
      end

      merged
    end
  end
end
