class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :author_full_name

  has_many :answers

  # to specify a serializer for an associated model,
  # you nest a serializer of that model inside your
  # serializer. ð is used to serialize the answers
  # rendered from `has_many :answers`
  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body
  end

  # We can define custom methods to render custom json
  # fields when serializing. This method name must still
  # be given to the `attributes` if you want it to be rendered.
  def author_full_name
    object.user&.full_name
  end
end
