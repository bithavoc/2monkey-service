# == Schema Information
#
# Table name: vaults
#
#  id         :integer          not null, primary key
#  name       :string
#  password   :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Vault < ActiveRecord::Base
  def new_token
    update({token: SecureRandom.base64(64)})
  end
end
