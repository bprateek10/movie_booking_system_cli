
class MovieTicketBookingSystem
  def initialize
    @movies = {}
  end

  def add_movie(title, genre, show_timings, total_seats)
    @movies[title.downcase] = {
      genre: genre.downcase,
      show_timings: show_timings,
      total_seats: total_seats,
      available_seats: Hash[show_timings.map { |timing| [timing, (1..total_seats).to_a] }],
      booked_seats:  Hash[show_timings.map { |timing| [timing, []] }]
    }
  end

  def display_movies
    puts "Available Movies:"
    @movies.each do |title, details|
      puts "Title: #{title.capitalize}, Genre: #{details[:genre].capitalize}, Show Timings: #{details[:show_timings].join(', ')}"
    end
  end

  def book_ticket(title, timing, seat_count)
    movie = find_movie(title)
    return unless movie
    
    seats = movie[:available_seats][timing]
    if seats.nil?
      puts "Invalid Show Timing!"
    elsif seats.length < seat_count
      puts "Not enough available seats for #{title.capitalize} at #{timing}."
    else
      booked_seats = seats.shift(seat_count)
      movie[:booked_seats][timing].concat(booked_seats)
      puts "Booking confirmed! Movie: #{title.capitalize}, Timing: #{timing}, Seats: #{booked_seats.join(', ')}"
    end
  end

  def cancel_ticket(title, timing, seat_numbers)
    movie = find_movie(title)
    return unless movie

    available_seats = movie[:available_seats][timing]
    booked_seats = movie[:booked_seats][timing]
    
    unless seat_numbers.all? { |seat| booked_seats.include?(seat) }
      puts "Invalid Seat Numbers!" 
      return
    end

    movie[:available_seats][timing].concat((seat_numbers))
    movie[:booked_seats][timing].reject! { |seat| seat_numbers.include?(seat) }
    puts "Ticket canceled for Movie: #{title.capitalize}, Timing: #{timing}, Seat: #{seat_numbers.join(', ')}"
  end

  def display_movie_status(title)
    movie = find_movie(title)
    return unless movie

    unless movie.nil?
      puts "\nMovie: #{title.capitalize}, Genre: #{movie[:genre].capitalize}"
      puts "Show Timings: #{movie[:show_timings].join(', ')}"
      puts "Available Seats:"
      movie[:available_seats].each do |timing, seats|
        puts "#{timing}: #{seats.join(', ')}"
      end
    else
      puts "Movie not found."
    end
  end

  private

  def find_movie(title)
    movie = @movies[title.downcase]
    puts "Movie not found." unless movie
    movie
  end
end


def print_menu
  puts "\nMovie Ticket Booking System Menu:"
  puts "1. Add Movie"
  puts "2. Display Movies"
  puts "3. Book Ticket"
  puts "4. Cancel Ticket"
  puts "5. Display Movie Status"
  puts "6. Exit"
end

def add_movie_inputs
  print "Enter movie title: "
  title = gets.chomp
  print "Enter genre: "
  genre = gets.chomp
  print "Enter show timings (comma-separated): "
  show_timings = gets.chomp.split(',').map(&:strip)
  print "Enter total seats: "
  total_seats = gets.chomp.to_i
  [title, genre, show_timings, total_seats]
end

def book_tickets_inputs
  print "Enter movie title: "
  title = gets.chomp
  print "Enter show timing: "
  timing = gets.chomp
  print "Enter number of seats to book: "
  seat_count = gets.chomp.to_i
  [title, timing, seat_count]
end

def cancel_ticket_inputs
  print "Enter movie title: "
  title = gets.chomp
  print "Enter show timing: "
  timing = gets.chomp
  print "Enter comma-separated seat numbers to cancel: "
  seat_numbers = gets.chomp.split(',').map(&:strip).map(&:to_i)
  [title, timing, seat_numbers]
end

def main
  booking_system = MovieTicketBookingSystem.new
  
  # Seeding initial set of movies
  booking_system.add_movie('jawan', 'action', ['9AM', '12PM', '3PM', '6PM'], 10)
  booking_system.add_movie('tiger3', 'action', ['9AM', '12PM', '3PM', '6PM'], 10)
  booking_system.add_movie('dunki', 'drama', ['9AM', '12PM', '3PM', '6PM'], 10)
  booking_system.add_movie('animal', 'drama', ['9AM', '12PM', '3PM', '6PM'], 10)
  
  loop do
    print_menu
    print "Enter your choice (1-6): "
    choice = gets.chomp.to_i

    case choice
    when 1
      title, genre, show_timings, total_seats = add_movie_inputs
      booking_system.add_movie(title, genre, show_timings, total_seats)
      puts "Movie added successfully!"
    when 2
      booking_system.display_movies
    when 3
      title, timing, seat_count = book_tickets_inputs
      booking_system.book_ticket(title, timing, seat_count)
    when 4
      title, timing, seat_numbers = cancel_ticket_inputs
      booking_system.cancel_ticket(title, timing, seat_numbers)
    when 5
      print "Enter movie title: "
      title = gets.chomp
      booking_system.display_movie_status(title)
    when 6
      puts "Exiting. Thank you!"
      break
    else
      puts "Invalid choice. Please enter a number between 1 and 6."
    end
  end
end

# Run the main function when the script is executed
main
