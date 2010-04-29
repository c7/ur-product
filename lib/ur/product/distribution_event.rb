module UR
  class Product
    class DistributionEvent      
      attr_reader :start_date, :end_date, :platform, 
                  :event_type, :receiving_agent_group
      
      def initialize(data)
        @start_date = Time.parse(data['startdate']) if !data['startdate'].nil?
        @end_date = Time.parse(data['enddate']) if !data['enddate'].nil?
        @receiving_agent_group = data['recievingagentgroup']
        @platform = data['platform']
        @event_type = data['type']
      end
    end
  end
end