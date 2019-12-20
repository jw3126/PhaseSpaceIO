import Setfield
using StaticArrays: @SVector, normalize
using Setfield: setproperties
export position
export direction

function position end
function direction end

Setfield.set(o, ::typeof(@lens position(_)), val) = set_position(o, val)
Setfield.set(o, ::typeof(@lens direction(_)), val) = set_direction(o, val)

function direction(p)
    @SVector [p.u, p.v, p.w]
end

function position(p::EGSParticle; z=nothing)
    if z === nothing
        @SVector[p.x, p.y]
    else
        @SVector[p.x, p.y, z]
    end
end

function position(p::AbstractIAEAParticle)
    @SVector[p.x, p.y, p.z]
end

function set_direction(p, dir)
    u,v,w = dir
    setproperties(p, (u=u,v=v,w=w))
end

function set_position(p::IAEAParticle, pos)
    x,y,z = pos
    setproperties(p, (x=x,y=y,z=z))
end

function set_position(p::EGSParticle, pos)
    x,y = pos
    setproperties(p, (x=x,y=y))
end

function set_position(p::CompressedIAEAParticle, pos)
    set_position(IAEAParticle(p), pos)
end
function set_direction(p::CompressedIAEAParticle, dir)
    set_direction(IAEAParticle(p), dir)
end
function set_position_direction(p::CompressedIAEAParticle, pos, dir)
    set_position_direction(IAEAParticle(p), pos, dir)
end

function set_position_direction(p::EGSParticle, pos, dir)
    x,y = pos
    u,v,w = dir
    setproperties(p, (x=x,y=y,u=u,v=v,w=w))
end

function set_position_direction(p::IAEAParticle, pos, dir)
    x,y,z = pos
    u,v,w = dir
    setproperties(p, (x=x,y=y,z=z,u=u,v=v,w=w))
end
