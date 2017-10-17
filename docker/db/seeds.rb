### Sample development data

## Admin roles

admin = Admin::Role.create(email: 's.karampatakis@gmail.com')


## Classifiers

# Districts
#use rails console to add classifiers
District.create(name: "Α' Δημοτική Κοινότητα")
District.create(name: "Β' Δημοτική Κοινότητα")
District.create(name: "Γ' Δημοτική Κοινότητα")
District.create(name: "Δ' Δημοτική Κοινότητα")
District.create(name: "Ε' Δημοτική Κοινότητα")
District.create(name: "Δημοτική Κοινότητα Τριανδρίας")


# Areas
Area.create(name: 'Δράσεις Πολιτισμού')
Area.create(name: 'Προστασία Περιβάλλοντος')
Area.create(name: 'Καθαριότητα')

# Tags
#garbage   = Tag.create(name: 'Garbage Disposal')
Tag.create(name:"Πάρκα αναψυχής")
Tag.create(name:"Πολιτιστικές Εκδηλώσεις")
Tag.create(name:"Παιδικές Χαρές")
Tag.create(name:"Κάδοι")
Tag.create(name:"Πεζοδρόμηση")
Tag.create(name:"Δενδροφύτευση")
Tag.create(name:"Ανάπλαση χώρου")

## Campaigns
=begin
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
#use rails console to add campaigns
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
=end
date_start = "2017-11-01"
date_end = "2018-01-01"
description = "Δοκιμαστική λειτουργία ιστοτόπου Συμμετοχικού Προϋπολογισμού.
              Τίποτα από τα αναφερθέντα έργα και ποσά δεν ανταποκρίνονται
              στην πραγματικότητα. Σκοπός αυτού του ιστοτόπου είναι η πιλοτική
              λειτουργία της εφαρμογής 'Συμμετοχικός Προϋπολογισμος' που αναπτύχθηκε στα πλαίσια του έργου OpenBudgets.eu."

Campaign.create(
                      title: "Διαβούλευση Προϋπολογισμού 2017",
                      budget: 20_000,
                      start_date: date_start,
                      end_date: date_end,
                      description: description,
                      active: true
                    )
