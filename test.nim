import fsm

proc cb() =
    echo "i'm evaporating"

type
    State = enum
        SOLID
        LIQUID
        GAS
        PLASMA

    Event = enum
        MELT
        EVAPORATE
        SUBLIMATE
        IONIZE

proc noop(state: State): void = discard

var m = Machine[State, Event, void](state:LIQUID)
#m.setDefaultTransition()
m.addTransition(SOLID, MELT, LIQUID, noop)
m.addTransition(LIQUID, EVAPORATE, GAS, cb)
m.addTransition(SOLID, SUBLIMATE, GAS, noop)
m.addTransition(GAS, IONIZE, PLASMA, noop)
m.addTransition(SOLID, MELT, LIQUID, noop)

echo "built state machine"

assert m.state == LIQUID
m.processEvent(EVAPORATE)
assert m.state == GAS
m.processEvent(IONIZE)
assert m.state == PLASMA

echo "done"