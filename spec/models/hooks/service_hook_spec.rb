require "spec_helper"

describe ServiceHook, models: true do
  describe "Associations" do
    it { is_expected.to belong_to :service }
  end

  describe "execute" do
    before(:each) do
      @service_hook = create(:service_hook)
      @data = { project_id: 1, data: {} }

      WebMock.stub_request(:post, @service_hook.url)
    end

    it "POSTs to the webhook URL" do
      @service_hook.execute(@data)
      expect(WebMock).to have_requested(:post, @service_hook.url).with(
        headers: { 'Content-Type' => 'application/json', 'X-Gitlab-Event' => 'Service Hook' }
      ).once
    end

    it "POSTs the data as JSON" do
      @service_hook.execute(@data)
      expect(WebMock).to have_requested(:post, @service_hook.url).with(
        headers: { 'Content-Type' => 'application/json', 'X-Gitlab-Event' => 'Service Hook' }
      ).once
    end

    it "catches exceptions" do
      expect(WebHook).to receive(:post).and_raise("Some HTTP Post error")

      expect { @service_hook.execute(@data) }.to raise_error(RuntimeError)
    end
  end
end
