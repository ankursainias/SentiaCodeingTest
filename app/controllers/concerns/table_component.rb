# frozen_string_literal: true

module TableComponent
	
	extend ActiveSupport::Concern

	private

 	 def page_number
 		return 1 if params[:start].blank?
 		(params[:start].to_i / page_length) + 1
 	 end

 	 def page_length(default = 10)
 	 	return default if params[:length].blank?
 	 	params[:length].to_i	
 	 end

 	 def total_count(klass)
    return klass.constantize.count if params[:export] == 'true'
    page_length
 	 end

 	 def column_number
 	 	 return '1' if params.dig(:order,'0', :column).blank?
 	 	 params[:order]['0'][:column]
 	 end

 	 def direction
 	 		return :asc if params.dig(:order,'0',:dir).blank?
 	 		params[:order]['0'][:dir].to_sym
 	 end

		def column_name(default)
 	 		if params.dig(:columns,column_number,:data).present?
 	 			return params.dig(:columns,column_number,:data).to_sym
 	 		else
 	 			return default
 	 		end
 	 end

 	 def search_query
 	 	return params.dig(:search,:value) if params.dig(:search,:value).present?
 	 	return ""
 	 end

 	 def respond(records,total, q=search_query)
 	 		{ "iTotalRecords": records.count, "iTotalDisplayRecords": total, data: records, query: q }
 	 end

end