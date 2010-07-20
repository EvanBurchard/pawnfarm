desc "Runs cron tasks."
task :cron do
  puts "Running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
  Pawn.execute!
end
