# frozen-string-literal: true

require "roda"

module Roda::RodaPlugins
  # The +mailer_ext+ plugin extends the mailer plugin with enhanced logging and
  # configuration options.
  #
  # @example
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
    module ResponseMethods
      # Log mail if configured to do so
      # @api private
      def finish
        value = super

        _log_mail(value) if _should_log_mail(value)

        value
      end

      # Log message
      # @param message [Mail::Message]
      # @api private
      def _log_mail(message)
        log = roda_class.opts[:mailer_ext][:log]

        if log.respond_to?(:call)
          log.call(message)
        else
          puts(_format_mail(message))
        end
      end

      # Generate a formatted string based on +message+
      # @param message [Mail::Message]
      # @return [String]
      # @api private
      def _format_mail(message)
        <<~EOM

        ==> Sending email to #{message.to.join(", ")}
        #{message}

        EOM
      end

      # Check if message is loggable
      # @param value [Mail::Message]
      # @return [Boolean]
      # @api private
      def _should_log_mail(value)
        value.is_a?(Mail::Message) && roda_class.opts[:mailer_ext][:log]
      end
    end

    # @api private
    def self.load_dependencies(app, opts = {})
      app.plugin :mailer
    end

    # @api private
    def self.configure(app, opts = {})
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
