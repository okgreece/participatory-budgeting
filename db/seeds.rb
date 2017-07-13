### Sample development data

## Admin roles

okgre = Admin::Role.create(email: '@okfn.gr')

## Voters

raul    = Voter.create(email: 'karampatakis@okfn.gr', verified: true)

## Classifiers

# Districts
a  = District.create(name: 'Δημοτική Ενότητα Α`')
b  = District.create(name: 'Δημοτική Ενότητα Β`')
c  = District.create(name: 'Δημοτική Ενότητα Γ`')
d  = District.create(name: 'Δημοτική Ενότητα Δ`')
e  = District.create(name: 'Δημοτική Ενότητα Ε`')

# Areas
environment = Area.create(name: 'Προστασία Περιβάλλοντος')
culture     = Area.create(name: 'Πολιτισμός')
sanitation  = Area.create(name: 'Καθαριότητα')

# Tags
garbage   = Tag.create(name: 'Αποκομειδ Σκουπιδιών')
bicycles  = Tag.create(name: 'Ποδηλατόδρομοι')
parks     = Tag.create(name: 'Πάρκα και χώροι αναψυχής')
libraries = Tag.create(name: 'Βιβλιοθήκες')

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
      Για ακόμη μία φορά, η ετήσια Εαρινή διαδικασία ψηφοφορίας ξεκινά για όλους τους πολίτες,
       ώστε να συνεισφέρουν στην διαμόρφωση του προϋπολογισμού για το δεύτερο εξάμηνο του έτους
    EOD
  when :fall
    <<~EOD.gsub(/\s+/, " ").strip
    Για ακόμη μία φορά, η ετήσια Χειμερινή διαδικασία ψηφοφορίας ξεκινά για όλους τους πολίτες,
     ώστε να συνεισφέρουν στην διαμόρφωση του προϋπολογισμού για το δεύτερο εξάμηνο του έτους
    EOD
  end
end

closed_campaign  =  Campaign.create(
                      title: "#{Semester.previous} Περίοδος",
                      budget: 114_192.56,
                      start_date: Semester.previous.start,
                      end_date: Semester.previous.end,
                      description: campaign_description_for(Semester.previous),
                      active: false
                    )
open_campaign    =  Campaign.create(
                      title: "#{Semester.current} Περίοδος",
                      budget: 252_343.45,
                      start_date: Semester.current.start,
                      end_date: Semester.current.end,
                      description: campaign_description_for(Semester.current),
                      active: true
                    )
pending_campaign =  Campaign.create(
                      title: "#{Semester.next} Περίοδος",
                      budget: 363_343.45,
                      start_date: Semester.next.start,
                      end_date: Semester.next.start,
                      description: campaign_description_for(Semester.next),
                      active: false
                    )

## Proposals

trees_1 = Proposal.create(
            title: 'Δενδροφύτευση επι της Εγνατίας.',
            budget: 10_000.00,
            classifiers: [a, environment, parks],
            campaign: open_campaign,
            description: <<~EOD
              Η Εγνατία Οδός, μία από τις κεντρικότερες οδικές αρτηρίες του Δήμου θεσσαλονίκης στερείται βασικής βλάστησης.
               ... για να βελτιωθεί το μικροκλίμα και η ποιότητα του αέρα της περιοχής
            EOD
          )
park_1  = Proposal.create(
            title: 'Playground for the Docks Quarter',
            budget: 102_344.32,
            classifiers: [a],
            campaign: open_campaign,
            description: <<~EOD
              The Docks quarter lacks of any infraestructure specifically tailored for children, making it difficult to go out and play.
              Building a playground in the district would save the children, and their parents, an inconvenient trip to other areas of the city.
            EOD
          )
lane_1  = Proposal.create(
            title: 'Bike Lane in Pinetree Area',
            budget: 4_510.50,
            classifiers: [b, environment, bicycles],
            campaign: open_campaign,
            description: <<~EOD
              Pinetree Area is a beautiful place to go and ride your bike, but riding among the pedestrians is dangerous for both, the bikers and the pedestrians.
              Having a dedicated bike lane will improve security and make the visit more enjoyable.
            EOD
          )

trees_2 = Proposal.create(
            title: 'Trees for Rodeo Drive',
            budget: 15_250.25,
            classifiers: [b, environment, parks],
            campaign: open_campaign,
            description: <<~EOD
              Rodeo Drive is lacking any type of vegetation, making it little attractive to pedestrian traffic.
              Planting some trees not only would improve the looks of the street, but also have a real impact in the air quality.
            EOD
          )
park_2  = Proposal.create(
            title: 'Playground for the Bellefleur Quarter',
            budget: 50_000.00,
            classifiers: [b],
            campaign: open_campaign,
            description: <<~EOD
              The Bellefleur quarter lacks of any infraestructure specifically tailored for children, making it difficult to go out and play.
              Building a playground in the district would save the children, and their parents, an inconvenient trip to other areas of the city.
            EOD
          )
lane_2  = Proposal.create(
            title: 'Bike Lane in the Financial Center',
            budget: 14_700.00,
            classifiers: [c, environment, bicycles],
            campaign: open_campaign,
            description: <<~EOD
              The Fiancial Center is a place where communting by bike would be great, but riding among the cars is dangerous for both, the bikers and the drivers.
              Having a dedicated bike lane will improve security and make the trip more enjoyable.
            EOD
          )

trees_3 = Proposal.create(
            title: 'Trees for South Bridge',
            budget: 8_500.00,
            classifiers: [d, environment, parks],
            campaign: open_campaign,
            description: <<~EOD
              South Bridge is lacking any type of vegetation, making it little attractive to pedestrian traffic.
              Planting some trees not only would improve the looks of the street, but also have a real impact in the air quality.
            EOD
          )
park_3  = Proposal.create(
            title: 'Playground for Downtown',
            budget: 102_344.32,
            classifiers: [e],
            campaign: open_campaign,
            description: <<~EOD
              The Downtown district lacks of any infraestructure specifically tailored for children, making it difficult to go out and play.
              Building a playground in the district would save the children, and their parents, an inconvenient trip to other areas of the city.
            EOD
          )
lane_3  = Proposal.create(
            title: 'Bike Lane in North Bridge',
            budget: 6_130.70,
            classifiers: [b, environment, bicycles],
            campaign: open_campaign,
            description: <<~EOD
              North Bridge is a convenient place to go around the Riverland district, but riding your bike among the pedestrians is dangerous for both, the bikers and the pedestrians.
              Having a dedicated bike lane will improve security and make the trip more enjoyable.
            EOD
          )

## Voter secrets

local_1    = VoterSecret.create(data: { document: '53713184D', birth_date: '1974-11-29' })
local_2    = VoterSecret.create(data: { document: '279793B', birth_date: '1986-10-19' })
resident_1 = VoterSecret.create(data: { document: 'X07323369A', birth_date: '1945-11-06' })
resident_2 = VoterSecret.create(data: { document: 'Y01927564M', birth_date: '1945-11-06' })
foreign_1  = VoterSecret.create(data: { document: '423994F', birth_date: '1990-05-12'})
foreign_2  = VoterSecret.create(data: { document: '08-VU-2160/16', birth_date: '1998-11-02' })
