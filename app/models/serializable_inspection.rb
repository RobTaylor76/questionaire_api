class SerializableInspection   < JSONAPI::Serializable::Resource
 type 'inspection'

  attributes  :due_date, :complete, :score

  id { @object.uuid}

  # attribute :date do
  #   @object.created_at
  # end
  #
  # belongs_to :author
  #
  # has_many :comments do
  #   data do
  #     @object.published_comments
  #   end
  #
  #   link :related do
  #     @url_helpers.user_posts_url(@object.id)
  #   end
  #
  #   meta do
  #     { count: @object.published_comments.count }
  #   end
  # end
  #
  # link :self do
  #   @url_helpers.post_url(@object.id)
  # end
  #
  # meta do
  #   { featured: true }
  # end
end