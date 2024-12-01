require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:another_user) { create(:user) }
  let(:comment) { build(:comment, user: another_user, post: post, body: "This is a test comment") }

  describe "callbacks" do
    describe "after_create_commit :notify_recipient" do
      it "calls notify_recipient" do
        expect(comment).to receive(:notify_recipient)
        comment.save
      end

      it "calls deliver_later on CommentNotification" do
        expect(CommentNotification).to receive(:with).and_call_original
        comment.save
      end

      it "enqueues a notification job" do
        ActiveJob::Base.queue_adapter = :test
        comment.save
        puts ActiveJob::Base.queue_adapter.enqueued_jobs # デバッグ用
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq(1)
      end
    end
  end
end
