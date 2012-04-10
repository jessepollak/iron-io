#--
# Copyright (c) 2012 Iron.io
#
# HelloWorker is a basic worker example intended to show how easy it is to queue, run, and schedule workers
# on the IronWorker system. There are two files in this package:
#
# hello_worker.rb (this file): This is the actual worker file. When ran, it will log some messages
# to it's worker log (which can be viewed through the IronWorker UI at hud.iron.io) and also sleep
# for 10 seconds so you can have time to see the worker running. Try adding some code to tehe run()
# method below.
#
# hellow_worker_runner.rb: This file configures your worker, queues it, and also schedules it. Open the file
# to see how easy it is to perform these operations.
#
# To run, simply Type: 'ruby hello_worker_runner.rb'
#
#++

require 'iron_worker'

class HelloWorker < IronWorker::Base

  attr_accessor :some_param

  def run
    log "Starting HelloWorker #{Time.now}\n"
    log "Hey. I'm a worker job, showing how this cloud-based worker thing works."
    log "I'll sleep for a little bit so you can see the workers running!"
    log "some_param --> #{some_param}\n"
    sleep 10
    log "Done running HelloWorker #{Time.now}"
  end


end