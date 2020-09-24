export ParticleType
export photon, electron, positron, neutron, proton

@enum ParticleType photon=1 electron=2 positron=3 neutron=4 proton=5

for pt in instances(ParticleType)
    fname = Symbol("is", pt)
    @eval $fname(p) = p.typ == $pt
    eval(Expr(:export, fname))
end

function load(path::AbstractString, T)
    open(path) do io
        load(io, T)
    end
end

function compute_u_v_w(u::Float32, v::Float32, sign_w::Float32)
    tmp = Float64(u)^2 + Float64(v)^2
    if tmp <= 1
        w = Float32(sign_w) * Float32(√(1 - tmp))
    else
        w = Float32(0)
        tmp = √(tmp)
        u = Float32(u/tmp)
        v = Float32(v/tmp)
    end
    u,v,w
end

@noinline function call_fenced(f::F, arg::A) where {F,A}
    f(arg)
end

function kwshow(io::IO, o; calle=nameof(typeof(o)))
    print(io, calle, "(")
    for pname in propertynames(o)
        pval = getproperty(o, pname)
        print(io, string(pname), "=")
        show(io, pval)
        print(io, ", ")
    end
    print(io, ")")
end
