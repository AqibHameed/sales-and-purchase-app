FactoryBot.define do
  factory :tiles_count do
    smart_search { 1 }
    available_parcel { 1 }
    inbox { 1 }
    history { 1 }
    live_monitor { 1 }
    public_channels { 1 }
    feedback { 1 }
    share_app { 1 }
    invite { 1 }
    current_tenders { 1 }
    upcoming_tenders { 1 }
    protection { 1 }
    record_sale { 1 }
    past_tenders { 1 }
  end
end
