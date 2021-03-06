require "minitest/autorun"
require "roda"

class TestMailerExt < Minitest::Test
  def setup
    @app = Class.new(Roda) do
      plugin :render
      plugin :mailer_ext, log: true, prevent_delivery: true

      route do |r|
        r.on "mail" do
          r.mail "test" do
            from    "test@example.com"
            to      "test@example.com"
            subject "Foo"

            render  inline: "The body"
          end
        end
      end
    end
  end

  def test_logging
    assert_output %r/Sending email/ do
      @app.sendmail("/mail/test")
    end
  end

  def test_delivery_prevention
    @app.sendmail("/mail/test")
    refute_empty Mail::TestMailer.deliveries
  end

  def test_callable_log
    logger = Class.new do
      attr_reader :messages

      def initialize
        @messages = []
      end

      def call(message)
        @messages << "[To: #{message.to.join(", ")}] #{message.subject}"
      end
    end.new

    @app.opts[:mailer_ext][:log] = logger

    @app.sendmail("/mail/test")

    refute_empty logger.messages
    assert_match %r(To: test@example.com), logger.messages.first
  end
end
