FactoryGirl.define do
  factory :member_student do
    first                 "first"
    last                  "last"
    dob                   "01/02/1234"
    address               "123 a st."
    city                  "b-town"
    zip                   "12345"
    contact_one           "mom"
    contact_one_primary   "(123) 456-7890"
    contact_one_secondary "(098) 675-4321"
    contact_two           "dad"
    contact_two_primary   "(123) 456-7890"
    contact_two_secondary "(098) 765-4321"
    email                 "abc@def.org"
    gender                "other"
    skill                 "intermediate"
    extra                 "This is extra info"
    access_code           12345
    password              "password"
    password_confirmation "password"
  end
 
  factory :anonymous_student do
    first                 "first"
    last                  "last"
    dob                   "01/02/1234"
    address               "123 a st."
    city                  "b-town"
    zip                   "12345"
    contact_one           "mom"
    contact_one_primary   "(123) 456-7890"
    contact_one_secondary "(098) 675-4321"
    contact_two           "dad"
    contact_two_primary   "(123) 456-7890"
    contact_two_secondary "(098) 765-4321"
    email                 "abc@def.org"
    gender                "other"
    skill                 "intermediate"
    extra                 "This is extra info"
    access_code           12345
    password              "password"
    password_confirmation "password"
  end
  
  factory :admin do
    first                 "first"
    last                  "last"
    dob                   "01/02/1234"
    address               "123 a st."
    city                  "b-town"
    zip                   "12345"
    contact_one           "mom"
    contact_one_primary   "(123) 456-7890"
    contact_one_secondary "(098) 675-4321"
    contact_two           "dad"
    contact_two_primary   "(123) 456-7890"
    contact_two_secondary "(098) 765-4321"
    email                 "admin@admin.org"
    gender                "other"
    skill                 "intermediate"
    extra                 "This is extra info"
    access_code           12345
    password              "password"
    password_confirmation "password"
  end
  
  factory :instructor do
    first                 "first"
    last                  "last"
    dob                   "01/02/1234"
    address               "123 a st."
    city                  "b-town"
    zip                   "12345"
    contact_one           "mom"
    contact_one_primary   "(123) 456-7890"
    contact_one_secondary "(098) 675-4321"
    contact_two           "dad"
    contact_two_primary   "(123) 456-7890"
    contact_two_secondary "(098) 765-4321"
    email                 "abc@def.org"
    gender                "other"
    skill                 "intermediate"
    extra                 "This is extra info"
    access_code           12345
    password              "password"
    password_confirmation "password"
  end
  
  factory :user do
    first                 "first"
    last                  "last"
    dob                   "01/02/1234"
    address               "123 a st."
    city                  "b-town"
    zip                   "12345"
    contact_one           "mom"
    contact_one_primary   "(123) 456-7890"
    contact_one_secondary "(098) 675-4321"
    contact_two           "dad"
    contact_two_primary   "(123) 456-7890"
    contact_two_secondary "(098) 765-4321"
    email                 "abc@def.org"
    gender                "other"
    skill                 "intermediate"
    extra                 "This is extra info"
    access_code           12345
    password              "password"
    password_confirmation "password"
  end
  
  factory :section do
    name                  "SEC_A"
    description           "A description"
    start_time            "10:00:00"
    end_time              "20:00:00"
    start_date            "2013-04-15"
    end_date              "2013-04-15"
    section_type          "C"
    lesson_type           "PRIVATE"
    enroll_cur            0
    enroll_max            5
    waitlist_cur          0
    waitlist_max          5
    teacher               "first last"
  end
end
