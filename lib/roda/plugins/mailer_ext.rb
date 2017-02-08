require "roda"

module Roda::RodaPlugins
  module MailerExt
    module ResponseMethods
      def finish
        value = super

        _log_mail(value) if _should_log_mail(value)

        value
      end

      def _log_mail(message)
        puts <<~EOM

        ==> Sending email to #{message.to.join(", ")}
        #{message}

        EOM
      end

      def _should_log_mail(value)
        value.is_a?(Mail::Message) && roda_class.opts[:mailer_ext][:log]
      end
    end

    def self.load_dependencies(app, opts = {})
      app.plugin :mailer
    end

    def self.configure(app, opts = {})
      app.opts[:mailer_ext] = { log: false, prevent_delivery: false }.merge(opts).freeze

      if app.opts[:mailer_ext][:prevent_delivery]
        Mail.defaults do
          delivery_method :test
        end
      end
    end
  end

  register_plugin :mailer_ext, MailerExt
end
