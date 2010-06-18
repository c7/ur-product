module UR
  class Product
    class DistributionEvent
      attr_reader :start_date, :end_date, :platform, 
                  :event_type, :receiving_agent_group
      
      def initialize(data)
        @start_date = Time.parse(data['startdate']) if !data['startdate'].nil?
        @end_date = Time.parse(data['enddate']) if !data['enddate'].nil?
        @receiving_agent_group = data['receivingagentgroup']
        @platform = data['platform']
        @event_type = data['type']
      end
      
      def active?
        (start_date < Time.now && end_date > Time.now) ? true : false
      end
      
      def in_the_future?
        Time.now < @start_date
      end
      
      def translated_platform
        translations = {
          'dab'       => 'Digital radio',
          'internet'  => 'Webben',
          'k'         => 'Kunskapskanalen',
          'p1'        => 'P1',
          'p2'        => 'P2',
          'p3'        => 'P3',
          'p4'        => 'P4',
          'svt1'      => 'SVT 1',
          'svt2'      => 'SVT 2',
          'svtb'      => 'Barnkanalen'
        }
        translations.has_key?(platform) ? translations[platform] : platform
      end
    end
  end
end