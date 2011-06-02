class UnattendedInstallItem < ActiveRecord::Base
  magic_mixin :item
end
# == Schema Information
#
# Table name: unattended_install_items
#
#  id                :integer         not null, primary key
#  package_branch_id :integer
#  package_id        :integer
#  manifest_id       :integer
#  manifest_type     :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

