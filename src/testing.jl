module Testing
using PhaseSpaceIO: IAEAParticle, ParticleType, GeneralizedEGSParticle,
EGSHeader, EGSParticle, photon, electron, positron, compute_u_v_w
using PhaseSpaceIO: Latch
export arbitrary
export testdatapath

function testdatapath(args...)
    joinpath(@__DIR__, "..", "test", "assets", args...)
end

function arbitrary(::Type{IAEAParticle{Nf,Ni}}) where {Nf, Ni}
    typ = rand([instances(ParticleType)...])
    E = 100*rand()
    weight = rand()
    x = randn(Float32)
    y = randn(Float32)
    z = randn(Float32)
    u = randn(Float32)
    v = randn(Float32)
    w = randn(Float32)
    scale = 1f0/sqrt(u^2 + v^2 + w^2)
    u *= scale
    v *= scale
    u,v,w = compute_u_v_w(u, v, sign(w))
    new_history  = rand(Bool)
    extra_floats = tuple(randn(Float32, Nf)...)
    extra_ints   = tuple(rand(Int32, Ni)...)
    IAEAParticle{Nf,Ni}(typ,
                    E,
                    weight,
                    x,y,z,
                    u,v,w,
                    new_history,
                    extra_floats,
                    extra_ints)
end

function arbitrary(H::Type{EGSHeader{P}}; 
    particlecount = Int32(rand(1:typemax(Int32))),
    photoncount = Int32(rand(1:particlecount)),
    max_E_kin = Float32(25*rand()),
    min_E_kin_electrons= Float32(rand()),
    originalcount = Float32(10^(10*rand()))
    ) where {P}
    H(particlecount,
    photoncount,
    max_E_kin,
    min_E_kin_electrons,
    originalcount)
end

function arbitrary(::Type{Latch})
    Latch(charge=rand(-1:1))
end

arbitrary_z(::Type{Nothing}) = nothing
arbitrary_z(::Type{Float32}) = randn(Float32)

function arbitrary(P::Type{GeneralizedEGSParticle{ZLAST,Z}};
        latch=arbitrary(Latch),
        E = rand(Float32),
        x = randn(Float32),
        y = randn(Float32),
        z = arbitrary_z(Z),
        ) where {ZLAST,Z}

    u = randn()
    v = randn()
    w = randn()
    scale = 1/sqrt(u^2 + v^2 + w^2)
    u = Float32(scale * u)
    v = Float32(scale * v)
    w = Float32(scale * w)
    new_history = rand(Bool)
    weight = 10*rand(Float32)
    if ZLAST == Nothing
        zlast = nothing
    else
        zlast = randn(Float32)
    end
    GeneralizedEGSParticle(
        latch=latch,
        E=E,
        weight=weight,
        x=x,
        y=y,
        z=z,
        u=u,
        v=v,
        w=w,
        new_history=new_history,
        zlast=zlast,
   )
end

end
