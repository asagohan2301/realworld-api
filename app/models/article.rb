class Article < ApplicationRecord
  before_save :set_slug

  serialize :tag_list, Array, coder: YAML
  belongs_to :user

  private
    def set_slug
      self.slug = title.parameterize if title_changed?
    end
end

