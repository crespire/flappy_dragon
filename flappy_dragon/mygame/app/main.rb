def tick(args)
  args.state.player_x ||= 120
  args.state.player_y ||= 280

  # Sprite speed
  concurrent_inputs = args.inputs.keyboard.keys.down_or_held
  speed = 10
  speed *= 0.707 if concurrent_inputs.length > 3

  # Sprite size
  player_w = 100
  player_h = 80

  args.state.player_x += args.inputs.left_right * speed
  args.state.player_y += args.inputs.up_down * speed

  unless args.state.player_x.between?(0, args.grid.w - player_w)
    args.state.player_x = args.state.player_x.negative? ? 0 : args.grid.w - player_w
  end

  unless args.state.player_y.between?(0, args.grid.h - player_h)
    puts args.grid.h - player_h
    args.state.player_y = args.state.player_y.negative? ? 0 : args.grid.h - player_h
  end

  puts "Player Y: #{args.state.player_y}"

  args.outputs.sprites << {
    x: args.state.player_x,
    y: args.state.player_y,
    w: player_w,
    h: player_h,
    path: 'sprites/misc/dragon-0.png'
  }
end
