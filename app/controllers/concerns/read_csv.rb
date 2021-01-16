module ReadCsv
  extend ActiveSupport::Concern
  FILE_FORMAT = ['.csv']
  REQUIRE_HEADER = ["name", "location", "species", "gender", "affiliations", "weapon", "vehicle"]

  def read_csv(file)
    content = []
    header = []
    begin
      require 'csv'
      CSV.foreach(file, headers: true, skip_blanks: true, encoding: 'ISO-8859-1', return_headers: true, header_converters: :downcase) do |row|
        header = row.headers if row.header_row?
        if row.field_row?
          _row = Hash[row.to_a].deep_symbolize_keys
          next if _row.values.all?(&:blank?)
          content.push(_row)
        end
      end
    rescue Exception => e
      raise e.message
    end
    { content: content, header: header }
  end
end