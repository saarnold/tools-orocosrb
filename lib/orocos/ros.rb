module Orocos
    module ROS
        def self.available?
            defined? TRANSPORT_ROS
        end
        def self.disable
            @enabled = false
        end
        def self.enabled?
            available? && @enabled && (ENV['ROS_MASTER_URI'] && ENV['ROCK_ROS_INTEGRATION'] != '0')
        end
        @enabled = true

        # Returns the ROS name service that gives access to the master listed in
        # ROS_MASTER_URI
        #
        # @return [NameService,false] the name service object, or false if it
        #   cannot be accessed
        def self.name_service
            if @name_service
                return @name_service
            else
                ns = Orocos::ROS::NameService.new
                ns.validate
                @name_service = ns
            end
        end
    end

    if ROS.available?
        Port.transport_names[TRANSPORT_ROS] = 'ROS'
    end
end
require 'xmlrpc/client'
require 'utilrb/thread_pool'
require 'orocos/ros/rpc'
require 'orocos/ros/types'
require 'orocos/ros/name_service'
require 'orocos/ros/node'
require 'orocos/ros/topic'
require 'orocos/ros/ports'
require 'orocos/ros/name_mappings'

# If ROS_MASTER_URI is set, auto-add the name service to the default
# list. One can remove it manually afterwards.
if Orocos::ROS.enabled?
    begin
        Orocos::ROS.name_service
    rescue Orocos::ROS::ComError
        Orocos.warn "ROS integration was enabled, but I cannot contact the ROS master at #{ns.uri}, disabling"
        Orocos::ROS.disable
    end
end
