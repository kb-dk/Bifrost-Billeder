# encoding: utf-8
module RightsHelper
  # set both permissions and embargo
  def set_rights(rights, object)
    set_permissions(rights[:rights], object) && set_embargo(rights[:embargo], object)
  end

  # Set the permission rights for an object.
  def set_permissions(rights, object)
    logger.debug "Setting new rights #{rights.inspect.to_s}"
    res = Array.new
    remove = Array.new
    # Handling of public rights
    unless rights[:public].blank?
      unless rights[:public][:access] == 'none'
        res << rights[:public]
      else
        remove << rights[:public][:name]
      end
    end
    # Handling of registered rights
    unless rights[:registered].blank?
      unless rights[:registered][:access] == 'none'
        res << rights[:registered]
      else
        remove << rights[:registered][:name]
      end
    end

    # Handling of non-default rights already defined
    unless rights[:specific].blank?
      rights[:specific].each do |p|
        unless p.last[:access] == 'none'
          res << p.last
        else
          remove << p.last[:name]
        end
      end
    end

    # Handling of new user-rights, if any. Verify, that it does not already exist.
    unless rights[:new][:name].blank? || rights[:new][:access] == 'none'
      res.each do |p|
        if p[:name] == rights[:new][:name]
          object.errors.add(:new_permission, "#{rights[:new][:name]} already exists")
          return false
        end
      end
      res << rights[:new]
    end

    # Updating with the new/changed permissions
    logger.debug "Permissions after update = #{res.inspect.to_s}"
    object.permissions = res

    # Workround for removing the permissions set to access 'none'.
    # First give them edit rights, then remove them.
    # Handling of both users and groups.
    unless remove.empty?
      logger.debug "Permission removed = #{remove.inspect.to_s}"
      object.set_discover_groups(remove, [])
      object.set_discover_groups([], remove)
      object.set_discover_users(remove, [])
      object.set_discover_users([], remove)
    end

    object.save
  end

  # Set the embargo rights for an object.
  def set_embargo(rights, object)
    logger.debug "embargo rights #{rights}"
    unless rights.blank? || rights[:embargo_date].blank?
      object.rightsMetadata.embargo_release_date = DateTime.parse rights[:embargo_date]
    else
      object.rightsMetadata.update_values({[:embargo,:machine,:date]=>nil})
    end
    object.save
  rescue => e
    object.errors.add(:embargo, "Unable to parse embargo date: '#{e.inspect.to_s}' -> required format #{DateTime.now.to_s}")
    false
  end
end
