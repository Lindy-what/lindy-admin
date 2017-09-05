class Payment < ApplicationRecord
  belongs_to :registration

  enum status: {
    created: 0,
    submitted: 1,
    completed: 2,
    failed: 3
  }

  after_create :submit_to_payment_provider

  def submit_to_payment_provider
    mollie = Mollie::API::Client.new(Rails.application.secrets.mollie_api_key)
    mollie_payment = mollie.payments.create(
      amount:       registration.ticket.price,
      description:  registration.course.title,
      redirect_url: "https://admin.dev/payments/#{self.id}",
      webhook_url:  "https://webshop.example.org/mollie-webhook/"
    )

    self.remote_id = mollie_payment.id
    self.payment_url = mollie_payment.payment_url
    self.save!
  end
end