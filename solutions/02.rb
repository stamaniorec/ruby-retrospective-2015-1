def destination(snake_head, direction)
  [snake_head.first + direction.first, snake_head.last + direction.last]
end

def grow(snake, direction)
  snake.map { |item| item.dup } + [destination(snake.last, direction)]
end

def move(snake, direction)
  grow(snake, direction).drop(1)
end

def out_of_bounds?(x, y, dimensions)
  x < 0 or x >= dimensions[:width] or y < 0 or y >= dimensions[:height]
end

def generate_fruit(dimensions)
  [rand(dimensions[:width]), rand(dimensions[:height])]
end

def new_food(food, snake, dimensions)
  fruit = generate_fruit(dimensions)
  while snake.include?(fruit) or food.include?(fruit)
    fruit = generate_fruit(dimensions)
  end
  fruit
end

def obstacle_ahead?(snake, direction, dimensions)
  next_head = destination(snake.last, direction)
  ate_self = snake.include?(next_head)

  out_of_bounds?(*next_head, dimensions) or ate_self
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end