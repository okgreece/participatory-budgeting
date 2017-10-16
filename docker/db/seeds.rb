### Sample development data

## Admin roles

admin = Admin::Role.create(email: 's.karampatakis@gmail.com')


## Classifiers

# Districts
downtown  = District.create(name: 'Downtown')
suburbs   = District.create(name: 'Suburbs')
riverland = District.create(name: 'Riverland')

# Areas
environment = Area.create(name: 'Environmental Protection')
culture     = Area.create(name: 'Cultural Affairs')
sanitation  = Area.create(name: 'Sanitation')

# Tags
garbage   = Tag.create(name: 'Garbage Disposal')
bicycles  = Tag.create(name: 'Bicycles')
parks     = Tag.create(name: 'Parks and Recreation')
libraries = Tag.create(name: 'Libraries')

## Campaigns

class Semester
  def self.current
    Semester.new
  end

  def self.previous
    current.previous
  end

  def self.next
    current.next
  end

  def initialize(season=nil, year=nil)
    @season = season || Date.today.month <= 6 ? :spring : :fall
    @year   = year   || Date.today.year
  end

  def previous
    previous_semester_season = @season == :spring ? :fall : :spring
    previous_semester_year = @season == :spring ? @year - 1 : @year
    @previous ||= Semester.new(previous_semester_season, previous_semester_year)
  end

  def next
    next_semester_season = @season == :spring ? :fall : :spring
    next_semester_year = @season == :spring ? @year : @year + 1
    @next ||= Semester.new(next_semester_season, next_semester_year)
  end

  def season
    @season
  end

  def year
    @year
  end

  def start
    result = Date.new(@year)
    result += 6.months if fall?
    result
  end

  def end
    result = Date.new(@year).end_of_year
    result -= 6.months if spring?
    result
  end

  def to_s
    "#{season.capitalize} #{year}"
  end

  def spring?
    @season == :spring
  end

  def fall?
    @season == :fall
  end
end

def campaign_description_for(semester)
  case semester.season
  when :spring
    <<~EOD.gsub(/\s+/, " ").strip
      Once more, the annual Spring campaign is up for all the citizens to collaborate on the allocation
      of the second semester of current year's city budget.
    EOD
  when :fall
    <<~EOD.gsub(/\s+/, " ").strip
      Once more, the annual Fall campaign is up for all the citizens to collaborate on the allocation
      of the first semester of next year's city budget.
    EOD
  end
end

closed_campaign  =  Campaign.create(
                      title: "#{Semester.previous} Campaign",
                      budget: 114_192.56,
                      start_date: Semester.previous.start,
                      end_date: Semester.previous.end,
                      description: campaign_description_for(Semester.previous),
                      active: false
                    )
open_campaign    =  Campaign.create(
                      title: "#{Semester.current} Campaign",
                      budget: 252_343.45,
                      start_date: Semester.current.start,
                      end_date: Semester.current.end,
                      description: campaign_description_for(Semester.current),
                      active: true
                    )
pending_campaign =  Campaign.create(
                      title: "#{Semester.next} Campaign",
                      budget: 363_343.45,
                      start_date: Semester.next.start,
                      end_date: Semester.next.start,
                      description: campaign_description_for(Semester.next),
                      active: false
                    )
