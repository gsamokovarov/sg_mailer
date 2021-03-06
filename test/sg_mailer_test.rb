require 'test_helper'

class SGMailerTest < Minitest::Test
  def setup
    SGMailer.client = nil
  end

  def test_configuration_setups_a_client_with_api_key
    api_key = 'xxx'

    SGMailer.configure(api_key: api_key)

    assert_equal api_key, SGMailer.client.api_key
  end

  def test_configuration_for_testing_client
    SGMailer.configure(test_client: true)

    assert SGMailer.client.is_a?(SGMailer::TestClient)
  end

  def test_sending_without_configuration
    assert_raises SGMailer::ConfigurationError do
      SGMailer.send({})
    end
  end
end
