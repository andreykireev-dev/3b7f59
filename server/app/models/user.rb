class User < ApplicationRecord
    has_secure_password
    has_many :campaigns
    has_many :prospects
    validates :email, uniqueness: true

    # JSON without private fields.
    def as_public_json
        self.as_json.except('password_digest')
    end
end
