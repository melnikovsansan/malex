module Console
  module BookletsPagesStats
    include ActiveSupport::NumberHelper

    GROUPS = {
      '0-100': nil..100.megabyte,
      '100-200': 100.megabyte..200.megabyte,
      '200-300': 200.megabyte..300.megabyte,
      '300-500': 300.megabyte..500.megabyte,
      '500+': 500.megabyte..nil,
    }

    def bps(period = 1.month.ago..nil)
      @bps_period = period
      bps_counts
      bps_csv
    end

    def bps_scope
      @bps_scope = Booklet.unscoped.includes(:company).where(created_at: @bps_period)
    end

    def bps_counts
      count = bps_scope.count
      @bps_counts = bps_scope.inject({}) do |result, b|
        print "\r" + ' ' * 79
        print "\r #{count -= 1} files left to download"
        b.company.using_as_current do
          name = b.company.name
          size = b.attachment.file&.size.to_i
          result[b.id] = size if size > 300.megabyte
          result
        end
      end
    end

    def bps_csv
      CSV.generate(headers: true) do |csv|
        csv << ['Company', *GROUPS.keys, 'Total Count', 'Booklet Max Pages']

        summary = {
          'TOTAL BY ALL COMPANIES': @bps_counts.values.flatten,
          **@bps_counts.sort.to_h
        }
        summary.each do |name, pages_counts|
          csv << [
            name,
            *GROUPS.values.map do |range|
              count = pages_counts.select { |n| n.in?(range) }.count
              count unless count.zero?
            end,
            pages_counts.count,
            number_to_human_size(pages_counts.max),
          ]
        end
      end
    end
  end
end

include Console::BookletsPagesStats if defined?(Rails::Console)

