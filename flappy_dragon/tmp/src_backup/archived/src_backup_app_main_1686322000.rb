def tick args
  args.outputs.sprites << { x: 576,
                              y: 280,
                              w: 128,
                              h: 101,
                              path: 'dragonruby.png',
                              angle: args.state.tick_count }
end
