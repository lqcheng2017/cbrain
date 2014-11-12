
#
# CBRAIN Project
#
# Copyright (C) 2008-2012
# The Royal Institution for the Advancement of Learning
# McGill University
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.  
#

class CbrainTask::StartVM #:nodoc:
  
  def validate_params #:nodoc:
    message = ""
    message += "Missing disk image file! "  if params[:disk_image].blank?

    message += "Missing VM user! "  if params[:vm_user].blank?

    message += "Missing VM boot timeout! "  if params[:vm_boot_timeout].blank?
    message += "Boot timeout has to be an integer! " if !is_integer? params[:vm_boot_timeout]

    message += "Missing number of instances! " if params[:number_of_vms].blank? 
    message += "Please don't try to start more than 20 instances at once for now. " if params[:number_of_vms].to_i > 20
    message += "Number of instances has to be an integer! " if !is_integer? params[:number_of_vms]

    message += "Missing number of job slots! " if params[:job_slots].blank? 
    message += "Number of job slots has to be an integer! " if !is_integer? params[:job_slots]

    bourreau = Bourreau.find(ToolConfig.find(self.tool_config_id).bourreau_id)
    if !bourreau.scir_class.new.is_a? ScirCloud
      message+= "Missing number of CPUs ! " if params[:vm_cpus].blank?
      message+= "Number of CPUs has to be an integer! " if !is_integer? params[:vm_cpus]

      message+= "Missing RAM! " if params[:vm_ram_gb].blank? 
      message+= "RAM has to be a numeric value " if !is_float? params[:vm_ram_gb]
    else
      message+= "Missing cloud instance type" if params[:instance_type].blank?
    end

    raise message unless message == ""

  end

  def is_integer?(a) #:nodoc:
    return true if a.is_a?(Integer)
    return true if a.is_an_integer? # added to class String in utilities
    return false
  rescue => ex # reached when a is not an Integer and it's not a String
    return false
  end

  def is_float?(a) #:nodoc:
    return true if a.is_a?(Numeric)
    return true if a.is_a_float? # added to class String in utilities
    return false
  rescue => ex # reached when a is not a Numeric and it's not a String
    return false
  end
end