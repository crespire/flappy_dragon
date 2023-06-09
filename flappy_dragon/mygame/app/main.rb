def spawn_target(args)
  size = 64
  {
    x: args.grid.w * 0.6 + rand(args.grid.w * 0.4 - size),
    y: rand(args.grid.h - size * 2) + size,
    w: size,
    h: size,
    path: 'sprites/misc/target.png'
  }
end

def tick(args)
  args.state.base_speed = 10
  args.state.score ||= 0
  args.state.player ||= {
    x: 120,
    y: 280,
    w: 100,
    h: 80,
    path: 'sprites/misc/dragon-0.png'
  }
  args.state.targets ||= [spawn_target(args), spawn_target(args), spawn_target(args)]
  args.state.fireballs ||= []
  concurrent_inputs = args.inputs.keyboard.keys.down_or_held
  args.state.player.speed = concurrent_inputs.length > 3 ? args.state.base_speed * 0.707 : args.state.base_speed

  args.state.player.x += args.inputs.left_right * args.state.player.speed
  args.state.player.y += args.inputs.up_down * args.state.player.speed

  unless args.state.player.x.between?(0, args.grid.w - args.state.player.w)
    args.state.player.x = args.state.player.x.negative? ? 0 : args.grid.w - args.state.player.w
  end

  unless args.state.player.y.between?(0, args.grid.h - args.state.player.h)
    args.state.player.y = args.state.player.y.negative? ? 0 : args.grid.h - args.state.player.h
  end

  if args.inputs.keyboard.key_down.space || args.inputs.controller_one.key_down.a
    args.state.fireballs << {
      x: args.state.player.x + args.state.player.h - 12,
      y: args.state.player.y + 10,
      w: 32,
      h: 32,
      path: 'sprites/misc/fireball.png'
    }
  end

  args.state.fireballs.each do |fireball|
    fireball.x += args.state.base_speed + 2
    if fireball.x > args.grid.w
      fireball.dead = true
      next
    end

    args.state.targets.each do |target|
      next unless args.geometry.intersect_rect?(target, fireball)

      target.dead = true
      fireball.dead = true
      args.state.score += 1

      new_target = spawn_target(args)
      until args.state.targets.none? { |leftover| args.geometry.intersect_rect?(leftover, new_target) }
        new_target = spawn_target(args)
      end
      args.state.targets << new_target
    end
  end

  args.state.targets.reject!(&:dead)
  args.state.fireballs.reject!(&:dead)

  args.outputs.sprites << [args.state.player, args.state.fireballs, args.state.targets]
  args.outputs.labels << {
    x: 40,
    y: args.grid.h - 40,
    text: "Score: #{args.state.score}",
    size_enum: 4
  }
end
