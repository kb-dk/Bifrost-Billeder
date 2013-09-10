# encoding: utf-8
module RightsHelper
  # Set the rights for an object.
  def set_rigths(rights, object)
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

    # Handling of new user-rights, if any
    unless rights[:new][:name].blank? || rights[:new][:access] == 'none'
      exists = false
      res.each do |p|
        exists = true if p[:name] == rights[:new][:name]
      end
      res << rights[:new] unless exists
    end

    # Updating with the new/changed permissions
    logger.info "Permissions after update = #{res.inspect.to_s}"
    object.permissions = res

    # Workround for removing the permissions set to access 'none'.
    # First give them edit rights, then remove them.
    # Handling of both users and groups.
    unless remove.empty?
      logger.info "Permission removed = #{remove.inspect.to_s}"
      object.set_discover_groups(remove, [])
      object.set_discover_groups([], remove)
      object.set_discover_users(remove, [])
      object.set_discover_users([], remove)
    end

    object.save
  end
end
