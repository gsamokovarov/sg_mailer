module SGMailer
  class TransactionalMailer
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
          mail = instance.public_send(name, *args, &block)
          MessageDelivery.new(mail)
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
      template_id = self.class.template_ids[caller_locations.first.base_label]

      normalized = normalize_options({ template_id: template_id }.merge(options))

      builder = SG::MailBuilder.new(normalized)
      builder.build
    end

    def normalize_options(options)
      self.class.default.deep_merge(options)
    end
  end
end
