Leafman::Command.new "skel-shoes", "<project-name>", "generate a Shoes skeleton for <project-name>, then set the 'type' accordingly" do |pname|
    include Leafman::Mixin
    error "skel-shoes is being updated"
end
