class Article < ApplicationRecord
  serialize :tag_list, Array, coder: YAML
  belongs_to :user
end
