module My
  module HandleWorkers
    module_function

    def call
      jobs_count = Delayed::Job.order(:run_at).where(queue: :default, run_at: nil..Time.current).count
      puts jobs_count
      if jobs_count > 20
        Bash['heroku ps:restart worker.1 --app legal-accounts']
        Bash['heroku ps:restart worker.2 --app legal-accounts']
      end
      sleep 30
      call
    end
  end
end
