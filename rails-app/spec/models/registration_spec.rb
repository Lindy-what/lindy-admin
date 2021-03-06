require "rails_helper"
require "mollie_helper"

describe "Registration" do

  context "Creating" do

    context "with valid input" do

      before(:each) do
        @member = FactoryBot.create(:member)
        @course = FactoryBot.create(:course)
        @ticket = FactoryBot.create(:ticket)
      end

      it "creates a notification mailing" do
        expect {
          Registration.create(
            member: @member,
            course: @course,
            ticket: @ticket,
            role: true,
            status: :triage
          )
        }.to change{
          Mailing.where(label: :registration, target: :admin).count
        }.by(1)
      end

      it "creates a welcome mailing" do
        expect {
          Registration.create(
            member: @member,
            course: @course,
            ticket: @ticket,
            role: true,
            status: :triage
          )
        }.to change{
          Mailing.where(label: :registration, target: :member).count
        }.by(1)
      end

    end

  end

end
