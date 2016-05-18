class VaultSerializer < ActiveModel::Serializer
  #self.root = false
  attributes  :id,
              :name,
              :created

  def created
    object.created_at.to_i
  end

end