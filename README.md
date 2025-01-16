# PowerSystemsReduction.jl


## This package is now archived. The network reduction functionality has been now integrated into [PowerNetworkMatrices.jl](https://github.com/NREL-Sienna/PowerNetworkMatrices.jl) and it doesn't modify the system input data. 

The `PowerSystemsReduction.jl` package provides utilities and routines to reduce the size and complexity of a `System` represented in [PowerSystems.jl](https://github.com/NREL-SIIP/PowerNetworkMatrices.jl). Use with care as it modifies the input data. 

## Installation

```julia
using Pkg
Pkg.add("https://github.com/NREL-SIIP/PowerSystemsReduction.jl")
```

## Example

```julia

julia> using PowerSystems

julia> using PowerSystemCaseBuilder

julia> using PowerSystemsReduction

julia> sys = build_system(PSSETestSystems, "pti_case73_sys")
System
┌───────────────────┬─────────────┐
│ Property          │ Value       │
├───────────────────┼─────────────┤
│ System Units Base │ SYSTEM_BASE │
│ Base Power        │ 100.0       │
│ Base Frequency    │ 60.0        │
│ Num Components    │ 460         │
└───────────────────┴─────────────┘

Static Components
┌─────────────────┬───────┬────────────────────────┬───────────────┐
│ Type            │ Count │ Has Static Time Series │ Has Forecasts │
├─────────────────┼───────┼────────────────────────┼───────────────┤
│ Arc             │ 108   │ false                  │ false         │
│ Area            │ 3     │ false                  │ false         │
│ Bus             │ 73    │ false                  │ false         │
│ FixedAdmittance │ 3     │ false                  │ false         │
│ Line            │ 105   │ false                  │ false         │
│ LoadZone        │ 3     │ false                  │ false         │
│ PowerLoad       │ 51    │ false                  │ false         │
│ TapTransformer  │ 15    │ false                  │ false         │
│ ThermalStandard │ 99    │ false                  │ false         │
└─────────────────┴───────┴────────────────────────┴───────────────┘



julia> rollup = transmission_rollup!(sys)
┌ Info: removing leaf nodes
└   length(leaf_nodes) = 2
Dict{Any, Any} with 2 entries:
  "208" => Any["207"]
  "308" => Any["307"]

julia> sys
System
┌───────────────────┬─────────────┐
│ Property          │ Value       │
├───────────────────┼─────────────┤
│ System Units Base │ SYSTEM_BASE │
│ Base Power        │ 100.0       │
│ Base Frequency    │ 60.0        │
│ Num Components    │ 454         │
└───────────────────┴─────────────┘

Static Components
┌─────────────────┬───────┬────────────────────────┬───────────────┐
│ Type            │ Count │ Has Static Time Series │ Has Forecasts │
├─────────────────┼───────┼────────────────────────┼───────────────┤
│ Arc             │ 106   │ false                  │ false         │
│ Area            │ 3     │ false                  │ false         │
│ Bus             │ 71    │ false                  │ false         │
│ FixedAdmittance │ 3     │ false                  │ false         │
│ Line            │ 103   │ false                  │ false         │
│ LoadZone        │ 3     │ false                  │ false         │
│ PowerLoad       │ 51    │ false                  │ false         │
│ TapTransformer  │ 15    │ false                  │ false         │
│ ThermalStandard │ 99    │ false                  │ false         │
└─────────────────┴───────┴────────────────────────┴───────────────┘
```

## Development

Contributions to the development and enahancement of PowerSystems is welcome. Please see [CONTRIBUTING.md](https://github.com/NREL-SIIP/InfrastructureSystems.jl/blob/master/CONTRIBUTING.md) for code contribution guidelines.

## License

PowerSystemsReduction is released under a BSD [license](https://github.com/NREL-SIIP/PowerSystemsReduction.jl/blob/master/LICENSE). PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning (SIIP)
initiative at the U.S. Department of Energy's National Renewable Energy Laboratory ([NREL](https://www.nrel.gov/))
