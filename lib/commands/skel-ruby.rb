Leafman::Command.new "skel-ruby", "<project-name> [classes...]", "generate a Ruby skeleton (with class skeletons) for <project-name>, then set the 'type' accordingly" do |pname, *classes|
    include Leafman::Mixin
    error "skel-ruby being updated"
end
