# frozen-string-literal: true

require "roda"

module Roda::RodaPlugins # :nodoc:
  # The mailer_ext plugin extends the mailer plugin with enhanced logging and
  # configuration options.
  #
  #   plugin :mailer_ext, log: (ENV["RACK_ENV"] != "test"),
  #                       prevent_delivery: (ENV["RACK_ENV"] != "production")
  #
  # = Plugin Options
  #
  # The following plugin options are supported:
  #
  # :log :: When true, output the body of the email to STDOUT before delivery.
  #         If passed an object that responds to +call+, it will be called with
  #         the email object.
  # :prevent_delivery :: Uses the +Mail+ test mailer instead of actually
  #                      attempting the delivery to a SMTP server.
  #
  # = Testing
  #
  # With +:prevent_delivery+ set to true, any outgoing emails are stored inside
  # the +Mail+ test mailer. You can access these during your tests.
  #
  #   refute_empty Mail::TestMailer.deliveries
  module MailerExt
    module ResponseMethods # :nodoc:
      def finish
        value = super

        _log_mail(value) if _should_log_mail(value)

        value
      end

      def _log_mail(message)
        log = roda_class.opts[:mailer_ext][:log]

        if log.respond_to?(:call)
          log.call(message)
        else
          puts(_format_mail(message))
        end
      end

      def _format_mail(message)
        <<~EOM

        ==> Sending email to #{message.to.join(", ")}
        #{message}

        EOM
      end

      def _should_log_mail(value)
        value.is_a?(Mail::Message) && roda_class.opts[:mailer_ext][:log]
      end
    end

    def self.load_dependencies(app, opts = {}) # :nodoc:
      app.plugin :mailer
    end

    def self.configure(app, opts = {}) # :nodoc:
      app.opts[:mailer_ext] = { log: false, prevent_delivery: false }.merge(opts)

      if app.opts[:mailer_ext][:prevent_delivery]
        Mail.defaults do
          delivery_method :test
        end
      end
    end
  end

  register_plugin :mailer_ext, MailerExt
end
