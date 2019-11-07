# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


def find_and_update_or_create(model_or_relation, finder, data)
  thing = model_or_relation.find_by(finder)
  if thing.present?
    thing.update_columns(data)
    thing
  else
    model_or_relation.create(data)
  end
end


uuid = '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
client_data = {

    uuid: uuid,
    name: 'Sample Client',
}


client = find_and_update_or_create(Client, {uuid: uuid}, client_data)


[
    {
        uuid: '918d0752-4e78-d251-bcdf-fe4d77a4b8fa',
        interval: 7,
        name: 'Inspect The Garden',
        first_inspection_date: 3.weeks.ago
    },
    {
        uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa',
        interval: 14,
        name: 'Inspect The House',
        first_inspection_date: 3.weeks.ago
    }
].each do |inspection_type|
  find_and_update_or_create(client.inspection_types, {uuid: inspection_type[:uuid]}, inspection_type)
end


uuid = 'fe4d77a4b8fa-d251-4e78-bcdf-918d0752'
client_data = {

    uuid: uuid,
    name: 'Second Client',
}

inspection_time_frame_end = 1.year.from_now

client = find_and_update_or_create(Client, {uuid: uuid}, client_data)

[
    {
        uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-bcdf',
        interval: 17,
        name: 'Inspect The Garage',
        first_inspection_date: 3.weeks.ago
    },
    {
        uuid: 'fe4d77a4b8fa-918d0752-d251-bcdf-4e78',
        interval: 21,
        name: 'Inspect The Shed',
        first_inspection_date: 3.days.ago
    }
].each do |inspection_type|
  inspection_type = find_and_update_or_create(client.inspection_types, {uuid: inspection_type[:uuid]}, inspection_type)

end

inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')

[
    {
        uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-1',
        sequence: 1,
        text: 'When was the grass cut?',
        answers: [{uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-2', display_text: 'Today', value: 100},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-3', display_text: 'This week', value: 75},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-4', display_text: 'Last week', value: 50},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-5', display_text: "It's been a while", value: 75}]
    },
    {
        uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-2',
        sequence: 2,
        text: 'Has the hedge been trimmed?',
        answers: [{uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-2', display_text: 'Today', value: 100},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-3', display_text: 'This week', value: 75},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-4', display_text: 'Last week', value: 50},
                  {uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-5', display_text: "It's been a while", value: 75}],
        allow_not_applicable_response: true
    }
].each do |question|
  find_and_update_or_create(inspection_type.questions, {uuid: question[:uuid]}, question.merge({client_id: inspection_type.client_id}))
end

Inspection.delete_all

InspectionType.all.each do |inspection_type|

  count = 0
  inspection_date = inspection_type.first_inspection_date

  while inspection_date < inspection_time_frame_end
    count += 1
    inspection = inspection_type.inspections.create!({due_date: inspection_date, client_id: inspection_type.client_id, uuid: "#{count}-uuid-kkk"})
    inspection_date = inspection_date + inspection_type.interval.days

  end
end

inspection_type.reload

inspection = inspection_type.inspections.first

answers = [
    {
        uuid: 'fe4d77a4b8fa-918d0752-4e78-d251-bcdf',
        question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1',
        answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-4',
        not_applicable: false
    },
    {
        uuid: 'fe4d77a4b8fa-918d0752-4e78-bcdf-d251',
        question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-2',
        answer_id: nil,
        not_applicable: true
    },
]

inspection.answers = answers
inspection.save