
function get_leaf_nodes(sys::System)
    arcs = get_components(Arc, sys)
    degree = StatsBase.countmap(vcat(get_from.(arcs), get_to.(arcs)))
    return [b for (b, d) in degree if d == 1]
end

function move_components!(sys::System, leaf_node::Bus)
    radial_arcs = get_components(
        Arc,
        sys,
        x -> (get_from(x) == leaf_node) || (get_to(x) == leaf_node),
    )
    if length(radial_arcs) > 1
        throw(error("can't have more than 1 arc connected to leaf bus"))
    elseif length(radial_arcs) == 1
        arc = first(radial_arcs)
        to_node = leaf_node == get_from(arc) ? get_to(arc) : get_from(arc)
        for leaf_component in
            get_components(StaticInjection, sys, x -> get_bus(x) == leaf_node)
            set_bus!(leaf_component, to_node)
        end
        for br in get_components(Branch, sys, x -> get_arc(x) == arc)
            remove_component!(sys, br)
        end
        remove_component!(sys, arc)
        remove_component!(sys, leaf_node)
        return get_name(to_node)
    end
end

"""
Routine to remove leaf nodes and stem branches from a System. Recursively moves any component connected
to a leaf node to other side of the stem branch and deletes the leaf node and stem branch.
"""
function transmission_rollup!(sys::System)
    leaf_nodes = get_leaf_nodes(sys)

    bus_reassignments = Dict()
    while !isempty(leaf_nodes)
        @info "removing leaf nodes" length(leaf_nodes)
        for leaf_node in leaf_nodes
            to_node = move_components!(sys, leaf_node)
            node_list = get(bus_reassignments, to_node, [])
            if haskey(bus_reassignments, get_name(leaf_node))
                node_list = vcat(node_list, bus_reassignments[get_name(leaf_node)])
                pop!(bus_reassignments, get_name(leaf_node))
            end

            bus_reassignments[to_node] = vcat(node_list, get_name(leaf_node))
        end
        leaf_nodes = get_leaf_nodes(sys)
    end
    return bus_reassignments
end

function write_reassignments!(fname, bus_reassignments)
    open(fname, "w") do io
        JSON3.pretty(io, bus_reassignments)
    end
end
