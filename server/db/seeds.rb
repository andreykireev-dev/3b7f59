user = User.create!(email: "test@test.com", password: "sample")

for i in 1..3 do
    campaign = user.campaigns.create!(name: "Awesome Campaign #{i}")
    for j in 1..100 do
        prospect = user.prospects.create!(
            email: "target#{j}@example.com",
            first_name: "Name#{j}",
            last_name: "Mc#{j}"
        )
        campaign.prospects << prospect
    end
end