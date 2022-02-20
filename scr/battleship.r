# battleship_game

# place a ship
place_ship <- function(dims, ship, board) {
  directions <- c("up", "right", "down", "left")
  end_pos_row <- 12
  end_pos_col <- 12
  place_empty <- 1
  counter <<- 0
  .stop <- 100
  # check the place is empty
  while (place_empty == 1 & counter < .stop) {

    # generate position
    while ((end_pos_row > 8 | end_pos_row < 1) |
      (end_pos_col > 8 | end_pos_col < 1) &
        counter < .stop) {
      # init ship dim
      init_pos_row <- sample(x = 1:dims[1], size = 1)
      init_pos_col <- sample(x = 1:dims[2], size = 1)
      direction <- sample(x = directions, size = 1)
      # calculate ship dims
      if (direction == "up") {
        end_pos_row <- init_pos_row - (ship - 1)
        end_pos_col <- init_pos_col
      } else if (direction == "right") {
        end_pos_row <- init_pos_row
        end_pos_col <- init_pos_col + (ship - 1)
      } else if (direction == "down") {
        end_pos_row <- init_pos_row + (ship - 1)
        end_pos_col <- init_pos_col
      } else if (direction == "left") {
        end_pos_row <- init_pos_row
        end_pos_col <- init_pos_col - (ship - 1)
      } else {
        stop("unknown direction")
      }
      # increase counter
      counter <<- counter + 1
    }

    # check if there is already a ship
    if (sum(board[(init_pos_row:end_pos_row), (init_pos_col:end_pos_col)] > 0)) {
      place_empty <- 1
    } else {
      place_empty <- 0
    }
    # increase counter
    counter <<- counter + 1
  }

  # place a ship of while ended
  if (counter >= .stop) {
    stop("Couldn't place a ship on the board")
  } else {
    board[(init_pos_row:end_pos_row), (init_pos_col:end_pos_col)] <- ship
    return(board)
  }
}

game <- function(dims = c(8, 8),
                 ships = c(5, 4, 3, 3, 2)) {
  # init game
  board <- matrix(0, nrow = dims[1], ncol = dims[2])

  for (ship in ships) {
    board <- place_ship(dims, ship, board)
  }
  return(board)
}